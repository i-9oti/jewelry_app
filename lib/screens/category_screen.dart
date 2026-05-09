import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';


import '../providers/favorites_provider.dart';
import '../providers/user_provider.dart';
import '../providers/product_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/toast_utils.dart';
import '../data/product_data.dart';
import '../utils/price_formatter.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  const CategoryScreen({super.key});

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  String selectedCategory = "خواتم";
  String selectedKarat = "الكل";
  String searchQuery = "";

  final List<Map<String, String>> categories = ProductData.categories;

  @override
  Widget build(BuildContext context) {

    final productState = ref.watch(productProvider);

    // تصفية المنتجات
    final List<Map<String, dynamic>> filteredProducts = productState.allProducts.where((p) {
      bool catMatch = p["category"] == selectedCategory;
      bool karatMatch = selectedKarat == "الكل" || p["karat"] == selectedKarat;
      bool searchMatch = searchQuery.isEmpty || 
          p["name"].toString().toLowerCase().contains(searchQuery.toLowerCase());
      return catMatch && karatMatch && searchMatch;
    }).toList();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: Text(
          'التصنيفات',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildCategoryTabs(),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildKaratFilters(),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: productState.isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.accent))
                : filteredProducts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 60, color: AppTheme.muted.withValues(alpha: 0.5)),
                            const SizedBox(height: 16),
                            const Text(
                              "لا توجد منتجات مطابقة", 
                              style: TextStyle(color: AppTheme.muted, fontSize: 16)
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredProducts.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 300,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {
                          final p = filteredProducts[index];
                          return _buildProductCard(context, ref, p, index);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: const Color(0xFF161B26),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
          ],
        ),
        child: TextField(
          onChanged: (val) => setState(() => searchQuery = val),
          style: TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search, color: Colors.white54, size: 22),
            hintText: 'ابحث عن منتج...',
            hintStyle: TextStyle(color: Colors.white38, fontSize: 13),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        separatorBuilder: (_, __ ) => const SizedBox(width: 20),
        itemBuilder: (context, i) {
          final cat = categories[i];
          final bool isActive = selectedCategory == cat["name"];
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = cat["name"]!),
            child: Column(
              children: [
                Container(
                  width: 85,
                  height: 85,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive ? AppTheme.accent : Colors.white10,
                      width: isActive ? 2.5 : 1.5,
                    ),
                    boxShadow: isActive ? [
                      BoxShadow(color: AppTheme.accent.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                    ] : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.bg,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          cat["image"]!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  cat["name"]!,
                  style: TextStyle(
                    color: isActive ? AppTheme.accent : Colors.white70,
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildKaratFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: ["الكل", "18", "21", "24"].map((k) {
          final bool isActive = selectedKarat == k;
          return GestureDetector(
            onTap: () => setState(() => selectedKarat = k),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? AppTheme.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isActive ? AppTheme.accent : Colors.white24,
                  width: 1,
                ),
              ),
              child: Text(
                k == "الكل" ? "الكل" : "$k قيراط",
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.white70,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, WidgetRef ref, Map<String, dynamic> p, int index) {
    final favorites = ref.watch(favoritesProvider);
    final user = ref.watch(userProvider).currentUser;
    final isFavorite = favorites.contains(p['name']);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 80).clamp(0, 400)),
      curve: Curves.easeOutQuint,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/product", arguments: {
            ...p,
            "heroTag": "cat_${p["name"]}"
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF161B26),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 12,
                child: Stack(
                  children: [
                    Hero(
                      tag: "cat_${p["name"]}",
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          image: DecorationImage(
                            image: AssetImage(p["image"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: GestureDetector(
                        onTap: () {
                          if (user != null) {
                            ref.read(favoritesProvider.notifier).toggleFavorite(user['email'], p);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF101423),
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            size: 20,
                            color: isFavorite ? Colors.redAccent : Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p["category"] ?? "خواتم",
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p["name"],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // السعر بين الوصف والنجمة
                    Text(
                      "${PriceFormatter.format((p["calculatedPrice"] ?? p["price"] as num).toDouble())} ر.س",
                      style: GoogleFonts.montserrat(
                        color: AppTheme.accent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (user != null) {
                              final price = (p["calculatedPrice"] ?? p["price"] as num).toDouble();
                              ref.read(cartProvider.notifier).addItem(user['email'], {
                                "name": p["name"],
                                "price": price,
                                "qty": 1,
                                "image": p["image"],
                              });
                              ToastUtils.showToast(context, "تمت الإضافة للسلة");
                            } else {
                              ToastUtils.showToast(context, "يرجى تسجيل الدخول أولاً", isError: true);
                            }
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.accent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.add, color: Colors.black, size: 20),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "${p["rating"] ?? 4.9}",
                              style: const TextStyle(color: Colors.white70, fontSize: 14),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.star, color: AppTheme.accent, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
