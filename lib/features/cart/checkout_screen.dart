import 'package:flutter/material.dart';
import 'package:baby_store_app/theme/app_colors.dart';

class CheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double total;

  const CheckoutScreen({
    super.key,
    required this.cartItems,
    required this.total,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String selectedPayment = 'card';
  bool useBillingAddress = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Checkout",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress Bar
            // Row(
            //   children: [
            //     _stepCircle("1", true),
            //     const Expanded(child: Divider()),
            //     _stepCircle("2", false),
            //     const Expanded(child: Divider()),
            //     _stepCircle("3", false),
            //   ],
            // ),
            const SizedBox(height: 30),

            // SHIPPING
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
                const Text(
                  "Use as Billing Address",
                  style: TextStyle(fontFamily: 'Nunito'),
                ),
                Switch(
                  value: useBillingAddress,
                  onChanged: (value) {
                    setState(() {
                      useBillingAddress = value;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // PAYMENT
            _sectionTitle(Icons.credit_card, "Payment"),

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
              title: "Acleda",
              value: "acleda",
            ),

            const SizedBox(height: 30),

            // ORDER SUMMARY
            _sectionTitle(Icons.shopping_bag_outlined, "Order Summary"),

            const SizedBox(height: 15),

            ...widget.cartItems.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      item["image"],
                      width: 55,
                      height: 55,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    item["title"],
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    item["description"] ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    "\$${item["price"]}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            const Divider(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Subtotal"),
                Text("\$${widget.total.toStringAsFixed(2)}"),
              ],
            ),

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

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  "\$${widget.total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF556B7B),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Order placed successfully using $selectedPayment",
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Complete Purchase",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _stepCircle(String number, bool active) {
    return CircleAvatar(
      radius: 14,
      backgroundColor: active ? const Color(0xFF556B7B) : Colors.grey.shade300,
      child: Text(
        number,
        style: TextStyle(
          color: active ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
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
        setState(() {
          selectedPayment = value;
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
