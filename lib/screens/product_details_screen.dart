import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';


import '../providers/favorites_provider.dart';
import '../providers/user_provider.dart';
import '../utils/toast_utils.dart';
import '../utils/price_formatter.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  String selectedSize = "18";
  int quantity = 1;
  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {

    final userEmail = ref.watch(userProvider).currentUser?['email'] ?? "";
    final size = MediaQuery.of(context).size;
    
    final product = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;

    if (product == null) {
      return const Scaffold(body: Center(child: Text("Error: Product data missing")));
    }

    final String name = product["name"] ?? "منتج";
    final String heroTag = product["heroTag"] ?? "hero_$name";
    final String category = product["category"] ?? "منتج";
    final double weight = (product["weight"] is num) ? (product["weight"] as num).toDouble() : 0.0;
    final double stoneWeight = (product["stoneWeight"] is num) ? (product["stoneWeight"] as num).toDouble() : 0.0;
    final double totalPrice = (product["calculatedPrice"] ?? product["price"] ?? 0.0) as double;
    final double rating = (product["rating"] is num) ? (product["rating"] as num).toDouble() : 4.5;
    final String image = product["image"] ?? "";
    final String karat = product["karat"]?.toString() ?? "21";

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          // 1. صورة المنتج الغامرة
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.55,
            child: Hero(
              tag: heroTag,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppTheme.bg,
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.4],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. المحتوى القابل للتمرير
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: SizedBox(height: size.height * 0.45)),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.bg,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // الاسم والفئة
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: GoogleFonts.playfairDisplay(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  category,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: AppTheme.accent,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.accent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star, color: AppTheme.accent, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  rating.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accent),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // معلومات المنتج التقنية
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDetailIcon(Icons.monitor_weight_outlined, "الوزن", "$weight g"),
                          _buildDetailIcon(Icons.diamond_outlined, "الأحجار", stoneWeight > 0 ? "$stoneWeight ct" : "بدون"),
                          _buildDetailIcon(Icons.verified_outlined, "العيار", "$karat K"),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // الوصف
                      Text(
                        "عن هذه القطعة",
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "مجوهرات أوروم تعكس فن الصياغة الراقية. هذه القطعة مصممة بعناية فائقة لتبرز جمالكِ في كل مناسبة، حيث تم استخدام أجود أنواع الذهب عيار $karat.",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // اختيار المقاس والكمية
                      Row(
                        children: [
                          Expanded(
                            child: _buildSelector(
                              "المقاس",
                              selectedSize,
                              ["16", "18", "20", "22"],
                              (val) => setState(() => selectedSize = val),
                            ),
                          ),
                          const SizedBox(width: 20),
                          _buildQuantityStepper(),
                        ],
                      ),
                      const SizedBox(height: 120), // مساحة للأزرار الثابتة
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. شريط الأزرار العلوي (خلفية شفافة)
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCircularButton(
                  Icons.arrow_back_ios_new,
                  () => Navigator.pop(context),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final favorites = ref.watch(favoritesProvider);
                    final isFav = favorites.contains(name);
                    return _buildCircularButton(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      () => ref.read(favoritesProvider.notifier).toggleFavorite(userEmail, product),
                      iconColor: isFav ? Colors.redAccent : null,
                    );
                  },
                ),
              ],
            ),
          ),

          // 4. شريط الإجراءات السفلي الثابت
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(context, totalPrice),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, VoidCallback onTap, {Color? iconColor}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white24),
            ),
            child: Icon(icon, color: iconColor ?? Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailIcon(IconData icon, String label, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: Icon(icon, color: AppTheme.accent, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }

  Widget _buildSelector(String label, String current, List<String> options, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: options.map((opt) {
              final isSelected = opt == current;
              return GestureDetector(
                onTap: () => onSelect(opt),
                child: Container(
                  margin: const EdgeInsets.only(left: 8), // استخدام left للمسافات في RTL
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppTheme.accent : Colors.white10,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isSelected ? AppTheme.accent : Colors.white10),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      color: isSelected ? Colors.black : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildQuantityStepper() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("الكمية", style: TextStyle(fontSize: 12, color: AppTheme.muted)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Row(
            children: [
              _stepperBtn(Icons.remove, () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(quantity.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              _stepperBtn(Icons.add, () => setState(() => quantity++)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepperBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.accent.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 18, color: AppTheme.accent),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, double price) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, -5)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("السعر الكلي", style: TextStyle(color: AppTheme.muted, fontSize: 12)),
                Text(
                  "${PriceFormatter.format(price * quantity)} ر.س",
                  style: GoogleFonts.montserrat(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  elevation: 10,
                  shadowColor: AppTheme.accent.withValues(alpha: 0.4),
                ),
                onPressed: _isAdding ? null : () async {
                  setState(() => _isAdding = true);
                  final userEmail = ref.read(userProvider).currentUser?['email'] ?? "";
                  final cartNotifier = ref.read(cartProvider.notifier);
                  final product = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
                  
                  await cartNotifier.addItem(userEmail, {
                    "name": product["name"],
                    "price": price,
                    "qty": quantity,
                    "image": product["image"],
                  });
                  
                  if (mounted) {
                    setState(() => _isAdding = false);
                    if (context.mounted) {
                      ToastUtils.showToast(context, 'تمت إضافة المنتج إلى السلة ✔');
                    }
                  }
                },
                child: _isAdding 
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                  : const Text("أضف إلى السلة", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
