import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../providers/user_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final userState = ref.watch(userProvider);
    final user = userState.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF050915),
      appBar: AppBar(
        title: const Text('حسابي'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // بطاقة المستخدم
            GestureDetector(
              onTap: () {
                if (user != null) {
                  Navigator.pushNamed(context, "/edit_profile");
                }
              },
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1527),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: Colors.white12),
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: const Color(0xFFF7C948).withValues(alpha: 0.2),
                          backgroundImage: user != null && user['profile_image'] != null && user['profile_image'].toString().isNotEmpty
                              ? FileImage(File(user['profile_image']))
                              : null,
                          child: user == null || user['profile_image'] == null || user['profile_image'].toString().isEmpty
                              ? const Icon(Icons.person, size: 50, color: Color(0xFFF7C948))
                              : null,
                        ),
                        if (user != null)
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF7C948),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.edit, size: 14, color: Colors.black),
                          )
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user != null ? user['username'] : "ضيف",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text(
                      user != null ? user['email'] : "تسجيل الدخول مطلوب",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            _buildActionItem(
              context,
              icon: Icons.shopping_bag_outlined,
              title: "مشترياتي",
              onTap: () => Navigator.pushNamed(context, "/orders"),
            ),
            _buildActionItem(
              context,
              icon: Icons.favorite_border,
              title: "المفضلات",
              onTap: () => Navigator.pushNamed(context, "/favorites"),
            ),

            const SizedBox(height: 20),
            
            _buildActionItem(
              context,
              icon: Icons.logout,
              title: "تسجيل الخروج",
              color: Colors.redAccent,
              onTap: () {
                ref.read(cartProvider.notifier).clearData();
                ref.read(favoritesProvider.notifier).clearData();
                Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1527),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? const Color(0xFFF7C948)),
        title: Text(title, style: TextStyle(color: color ?? Colors.white, fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
