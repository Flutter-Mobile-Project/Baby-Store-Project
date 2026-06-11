import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:baby_store_app/services/order_service.dart';
import 'package:baby_store_app/theme/app_colors.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cream,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Page title ────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
            child: Text(
              'My Orders',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // ── Order list ────────────────────────────────────────
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: OrderService.getUserOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.mint),
                  );
                }

                if (snapshot.hasError) {
                  final error = snapshot.error.toString();
                  if (error.contains('failed-precondition') ||
                      error.contains('index')) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.lan_outlined,
                              size: 60,
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Database Index Required',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'This query requires a composite index in Firebase Console.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 16),
                            SelectableText(
                              error,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Center(child: Text('Error: $error'));
                }

                final orders = snapshot.data?.docs ?? [];
                final sortedOrders = [...orders];

                sortedOrders.sort((a, b) {
                  final aData = a.data() as Map<String, dynamic>;
                  final bData = b.data() as Map<String, dynamic>;
                  final aTs = aData['createdAt'] is Timestamp
                      ? aData['createdAt'] as Timestamp
                      : null;
                  final bTs = bData['createdAt'] is Timestamp
                      ? bData['createdAt'] as Timestamp
                      : null;
                  if (aTs == null && bTs == null) return 0;
                  if (aTs == null) return 1;
                  if (bTs == null) return -1;
                  return bTs.compareTo(aTs);
                });

                if (sortedOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_bag_outlined,
                          size: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No orders yet',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your purchase history will appear here.',
                          style: TextStyle(
                            fontFamily: 'Nunito',
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  itemCount: sortedOrders.length,
                  itemBuilder: (context, index) {
                    final order =
                        sortedOrders[index].data() as Map<String, dynamic>;
                    final createdAt = order['createdAt'] as Timestamp?;
                    final dateStr = createdAt != null
                        ? DateFormat(
                            'MMM dd, yyyy • hh:mm a',
                          ).format(createdAt.toDate())
                        : 'Recent Order';

                    final items = order['items'] as List<dynamic>? ?? [];
                    final total = (order['total'] ?? 0).toDouble();
                    final status = order['status'] ?? 'Pending';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 10),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // ── Order header ──────────────────
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order #${order['orderId']?.toString().substring(0, 8).toUpperCase() ?? '-------'}',
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      dateStr,
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                                _buildStatusBadge(status),
                              ],
                            ),
                          ),
                          Divider(height: 1, color: Colors.grey.shade100),

                          // ── Items ─────────────────────────
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                ...items
                                    .take(2)
                                    .map(
                                      (item) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: _buildItemImage(
                                                item['image'],
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item['title'] ?? 'Product',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Qty: ${item['qty']}',
                                                    style: TextStyle(
                                                      fontFamily: 'Nunito',
                                                      fontSize: 12,
                                                      color:
                                                          Colors.grey.shade500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Text(
                                              '\$${(item['price'] * item['qty']).toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontFamily: 'Nunito',
                                                fontWeight: FontWeight.w600,
                                                color: AppColors.textPrimary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                if (items.length > 2)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      '+ ${items.length - 2} more items',
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontSize: 12,
                                        color: Colors.grey.shade400,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          Divider(height: 1, color: Colors.grey.shade100),

                          // ── Total ─────────────────────────
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Total Amount',
                                  style: TextStyle(
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '\$${total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 33, 100, 201),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = const Color.fromARGB(133, 242, 178, 75);
        break;
      case 'confirmed':
        color = const Color.fromARGB(255, 119, 187, 243);
        break;
      case 'shipped':
        color = const Color.fromARGB(255, 220, 101, 240);
        break;
      case 'delivered':
        color = const Color.fromARGB(255, 110, 242, 115);
        break;
      default:
        color = const Color.fromARGB(255, 226, 224, 224);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 26),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontFamily: 'Nunito',
          color: const Color.fromARGB(255, 249, 248, 248),
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildItemImage(String? imagePath) {
    if (imagePath == null) {
      return Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 20,
        ),
      );
    }
    if (imagePath.startsWith('assets/')) {
      return Image.asset(imagePath, width: 45, height: 45, fit: BoxFit.cover);
    }
    return Image.network(
      imagePath,
      width: 45,
      height: 45,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 45,
        height: 45,
        color: Colors.grey.shade100,
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.grey,
          size: 20,
        ),
      ),
    );
  }
}
