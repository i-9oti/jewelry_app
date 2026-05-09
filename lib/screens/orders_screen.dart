import 'package:flutter/material.dart';
import '../services/database_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_provider.dart';

import '../utils/price_formatter.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userEmail = ref.watch(userProvider).currentUser?['email'] ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFF050915),
      appBar: AppBar(
        title: const Text("مشترياتي"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: userEmail.isEmpty 
        ? const Center(child: Text("يرجى تسجيل الدخول لعرض الطلبات"))
        : FutureBuilder<List<Map<String, dynamic>>>(
            future: DatabaseHelper.instance.getOrders(userEmail),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFFC78822)));
              }
              
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.white24),
                      const SizedBox(height: 16),
                      const Text("لا توجد مشتريات سابقة", style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ],
                  ),
                );
              }

              final orders = snapshot.data!;
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                separatorBuilder: (_, __ ) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("طلب #${order['id']}", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC78822))),
                            Text(order['status'], style: const TextStyle(color: Colors.green, fontSize: 12)),
                          ],
                        ),
                        const Divider(height: 24),
                        Text(order['productNames'], style: TextStyle(color: Colors.white70)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(order['orderDate'].toString().substring(0, 10), style: const TextStyle(color: Colors.grey, fontSize: 12)),
                            Text("${PriceFormatter.format((order['totalAmount'] as num).toDouble())} ر.س", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
    );
  }
}
