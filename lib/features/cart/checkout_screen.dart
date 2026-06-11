import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';
import 'package:baby_store_app/services/order_service.dart';
import '../shell/main_shell_screen.dart';
// import 'package:baby_store_app/features/cart/success_screen.dart';
import 'dart:async';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;
  final double discountAmount;
  final bool isTab;
  final VoidCallback? onOrderComplete;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.total,
    required this.discountAmount,
    this.isTab = false,
    this.onOrderComplete,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = 'card';
  bool useBillingAddress = true;
  bool _isLoading = false;
  bool _showSuccessOverlay = false;
  String _orderId = '';

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  // Card Controllers
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  // Timer for QR Payment
  Timer? _paymentTimer;
  int _secondsRemaining = 120; // 2 minutes

  @override
  void initState() {
    super.initState();
    // No timer at start, only when ABA/Acleda selected?
    // Or maybe start when selected.
  }

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    _paymentTimer?.cancel();
    super.dispose();
  }

  void _startPaymentTimer() {
    _paymentTimer?.cancel();
    setState(() {
      _secondsRemaining = 120;
    });
    _paymentTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        _paymentTimer?.cancel();
        // Maybe show a timeout message
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  double get subtotal {
    return widget.cartItems.fold(0.0, (sum, item) {
      final price = (item["price"] ?? 0).toDouble();
      final qty = (item["qty"] ?? 1);
      return sum + (price * qty);
    });
  }

  double get discount => widget.discountAmount;

  double get total => (subtotal - discount).clamp(0, double.infinity);

  void _handleCompletePurchase() async {
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Your cart is empty")));
      return;
    }

    if (fullNameController.text.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all shipping details")),
      );
      return;
    }

    // Additional validations for Card
    if (selectedPayment == 'card') {
      if (cardNumberController.text.isEmpty ||
          expiryController.text.isEmpty ||
          cvvController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in card details")),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    final result = await OrderService.placeOrder(
      items: widget.cartItems,
      subtotal: subtotal,
      discount: discount,
      total: total,
      fullName: fullNameController.text.trim(),
      address: addressController.text.trim(),
      city: cityController.text.trim(),
      paymentMethod: selectedPayment,
    );

    if (mounted) setState(() => _isLoading = false);

    if (result.containsKey('error')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to place order: ${result['error']}")),
        );
      }
    } else {
      final orderId = result['orderId'] ?? 'N/A';

      print("ORDER SUCCESS");
      print(result);

      if (mounted) {
        setState(() {
          _orderId = orderId.toString();
          _showSuccessOverlay = true;
        });

        print("_showSuccessOverlay = $_showSuccessOverlay");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Checkout",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              _sectionTitle(Icons.local_shipping_outlined, "Shipping Address"),
              const SizedBox(height: 15),
              _inputField(controller: fullNameController, hint: "Full Name"),
              const SizedBox(height: 12),
              _inputField(
                controller: addressController,
                hint: "Shipping Address",
              ),
              const SizedBox(height: 12),
              _inputField(controller: cityController, hint: "City"),

              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Use as Billing Address"),
                  Switch(
                    value: useBillingAddress,
                    onChanged: (value) {
                      setState(() => useBillingAddress = value);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _sectionTitle(Icons.credit_card, "Payment Method"),
              const SizedBox(height: 15),

              _paymentTile(
                icon: Icons.credit_card,
                title: "Credit / Debit Card",
                value: "card",
              ),
              if (selectedPayment == 'card') _buildCardInputs(),
              const SizedBox(height: 10),

              _paymentTile(
                icon: Icons.account_balance,
                title: "ABA Pay",
                value: "aba",
              ),
              if (selectedPayment == 'aba') _buildQRPayment("ABA Pay"),
              const SizedBox(height: 10),

              _paymentTile(
                icon: Icons.account_balance_wallet,
                title: "Acleda Bank",
                value: "acleda",
              ),
              if (selectedPayment == 'acleda') _buildQRPayment("Acleda Bank"),

              const SizedBox(height: 30),

              _sectionTitle(Icons.shopping_bag_outlined, "Order Summary"),
              const SizedBox(height: 15),
              ...widget.cartItems.map((item) {
                final price = (item["price"] ?? 0).toDouble();
                final qty = (item["qty"] ?? 1);
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: item["image"].startsWith('assets/')
                          ? Image.asset(
                              item["image"],
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              item["image"],
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.shopping_bag),
                            ),
                    ),
                    title: Text(
                      item["title"],
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("Qty: $qty"),
                    trailing: Text(
                      "\$${(price * qty).toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFDDEBE3),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [
                    _summaryRow("Subtotal", "\$${subtotal.toStringAsFixed(2)}"),
                    const SizedBox(height: 10),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Shipping"),
                        Text(
                          "FREE",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (discount > 0) ...[
                      const SizedBox(height: 10),
                      _summaryRow(
                        "Coupon Discount",
                        "-\$${discount.toStringAsFixed(2)}",
                        labelStyle: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                        valueStyle: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                    const SizedBox(height: 15),
                    _summaryRow(
                      "Total",
                      "\$${total.toStringAsFixed(2)}",
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      valueStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              GestureDetector(
                onTap: _isLoading ? null : _handleCompletePurchase,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF556B7B),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Complete Purchase",
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),

        if (_showSuccessOverlay)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 700),
                tween: Tween(begin: 0, end: 1),
                curve: Curves.easeOutBack,
                builder: (context, value, child) {
                  // Curve (easeOutBack) may overshoot >1. Clamp opacity to [0,1]
                  final double clamped = value.clamp(0.0, 1.0).toDouble();
                  return Transform.scale(
                    scale: value,
                    child: Opacity(opacity: clamped, child: child),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFDDEBE3),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Color(0xFF7A9E8E),
                          size: 60,
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Payment Successful!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      const Text(
                        "Your order has been placed successfully.",
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Order ID: $_orderId",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 25),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MainShellScreen(),
                              ),
                              (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF556B7B),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "Back to Home",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    if (widget.isTab) return body;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(child: body),
    );
  }

  Widget _buildCardInputs() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF556B7B).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          _inputField(
            controller: cardNumberController,
            hint: "Card Number (0000 0000 0000 0000)",
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _inputField(controller: expiryController, hint: "MM/YY"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _inputField(controller: cvvController, hint: "CVV"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQRPayment(String bankName) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF556B7B).withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Scan to Pay with $bankName",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          // Placeholder for QR Code
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.qr_code_2,
              size: 150,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Payment expires in:",
            style: TextStyle(color: Colors.grey.shade600),
          ),
          Text(
            _formatTime(_secondsRemaining),
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Please don't close this screen until payment is confirmed.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    String label,
    String value, {
    TextStyle? labelStyle,
    TextStyle? valueStyle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textPrimary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Nunito',
          ),
        ),
      ],
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.cream.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _paymentTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    final isSelected = selectedPayment == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPayment = value;
          if (value == 'aba' || value == 'acleda') {
            _startPaymentTimer();
          } else {
            _paymentTimer?.cancel();
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF556B7B) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: const Color(0xFF556B7B),
            ),
            const SizedBox(width: 10),
            Icon(icon),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontFamily: 'Nunito'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
