import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';


import '../providers/user_provider.dart';
import '../utils/toast_utils.dart';
import '../utils/price_formatter.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(liveCartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    final userEmail = ref.watch(userProvider).currentUser?['email'] ?? "";

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('السلة'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                ),
                child: cart.items.isEmpty
                    ? Center(
                        child: Text(
                          'السلة فارغة حالياً',
                          style: const TextStyle(color: AppTheme.muted),
                        ),
                      )
                    : ListView.separated(
                        itemCount: cart.items.length,
                        separatorBuilder: (_, __ ) =>
                            const Divider(color: Colors.white12, height: 1),
                        itemBuilder: (context, index) {
                          final item = cart.items[index];

                          final String name = (item["name"] ?? "").toString();
                          final int qty = (item["qty"] as num).toInt();
                          final double price = (item["price"] as num).toDouble();
                          final String? imagePath = item["image"] as String?;

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            leading: _buildItemImage(imagePath),
                            title: Text(
                              name,
                              style: TextStyle(fontSize: 13, color: Colors.white),
                            ),
                            subtitle: Row(
                              children: [
                                IconButton(
                                  onPressed: () => cartNotifier.decreaseQty(userEmail, index),
                                  icon: Icon(Icons.remove, color: Colors.white),
                                  iconSize: 18,
                                ),
                                Text("$qty", style: TextStyle(color: Colors.white, fontSize: 14)),
                                IconButton(
                                  onPressed: () => cartNotifier.increaseQty(userEmail, index),
                                  icon: Icon(Icons.add, color: Colors.white),
                                  iconSize: 18,
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "${PriceFormatter.format(price * qty)} ر.س",
                                  style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                                const SizedBox(height: 4),
                                GestureDetector(
                                  onTap: () {
                                    cartNotifier.removeItem(userEmail, name);
                                    ToastUtils.showToast(context, 'تم حذف المنتج من السلة 🗑', isError: true);
                                  },
                                  child: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 22),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                children: [
                  _summaryRow('إجمالي المنتجات', cart.subtotal),
                  _summaryRow('الضريبة', cart.tax),
                  _summaryRow('تكلفة الشحن', cart.shipping),
                  const Divider(color: Colors.white24),
                  _summaryRow('الإجمالي النهائي', cart.total, highlight: true),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      onPressed: cart.items.isEmpty
                          ? null
                          : () {
                              Navigator.pushNamed(context, "/checkout");
                            },
                      child: Text(
                        'متابعة لإتمام الدفع',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, double value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: highlight ? (Colors.white) : AppTheme.muted,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          Text(
            "${PriceFormatter.format(value)} ر.س",
            style: TextStyle(
              color: highlight ? AppTheme.accent : Colors.white,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              fontSize: highlight ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildItemImage(String? imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Builder(
          builder: (context) {
            if (imagePath == null || imagePath.isEmpty) {
              return Container(color: Colors.grey.shade800);
            }
            return Image.asset(
              imagePath,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade800),
            );
          },
        ),
      ),
    );
  }
}
