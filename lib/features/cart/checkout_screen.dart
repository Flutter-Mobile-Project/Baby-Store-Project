import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';
import 'package:baby_store_app/services/order_service.dart';
import '../shell/main_shell_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total; // kept for compatibility (not used for calculation)
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

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    super.dispose();
  }

  // =========================
  // ✅ CONSISTENT CALCULATION
  // =========================

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Your cart is empty")),
      );
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

    setState(() => _isLoading = true);

    final error = await OrderService.placeOrder(
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

    if (error != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to place order: $error")),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Order placed successfully using $selectedPayment!",
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        // Trigger callback to clear cart in MainShellScreen
        widget.onOrderComplete?.call();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = SingleChildScrollView(
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

          // SHIPPING ADDRESS
          _sectionTitle(Icons.local_shipping_outlined, "Shipping Address"),
          const SizedBox(height: 15),

          _inputField(controller: fullNameController, hint: "Full Name"),
          const SizedBox(height: 12),
          _inputField(controller: addressController, hint: "Shipping Address"),
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

          // PAYMENT
          _sectionTitle(Icons.credit_card, "Payment Method"),
          const SizedBox(height: 15),

          _paymentTile(
            icon: Icons.credit_card,
            title: "Credit / Debit Card",
            value: "card",
          ),
          const SizedBox(height: 10),

          _paymentTile(
            icon: Icons.account_balance,
            title: "ABA Pay",
            value: "aba",
          ),
          const SizedBox(height: 10),

          _paymentTile(
            icon: Icons.account_balance_wallet,
            title: "Acleda Bank",
            value: "acleda",
          ),

          const SizedBox(height: 30),

          // ORDER ITEMS
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
                        errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag),
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

          // SUMMARY BOX
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

          // COMPLETE ORDER
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
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
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
    );

    if (widget.isTab) return body;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(child: body),
    );
  }

  // =========================
  // UI HELPERS
  // =========================

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
        fillColor: Colors.white,
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
        setState(() => selectedPayment = value);
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
