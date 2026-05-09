import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';


import '../providers/product_provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/user_provider.dart';
import '../providers/cart_provider.dart';
import '../utils/toast_utils.dart';
import '../providers/navigation_provider.dart';
import '../theme/app_theme.dart';
import '../utils/price_formatter.dart';
import '../widgets/gold_gradient.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final size = MediaQuery.of(context).size;
    final productState = ref.watch(productProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF070A11),
      extendBodyBehindAppBar: false,
      appBar: _buildAppBar(context, ref),
      body: _buildBody(context, ref, productState, size),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ProductState state,
    Size size,
  ) {
    if (state.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.accent),
      );
    }

    if (state.errorMessage.isNotEmpty) {
      return _buildErrorState(ref, state.errorMessage);
    }

    final allProducts = state.filteredProducts;
    final Map<String, Map<String, dynamic>> categoryProducts = {};

    for (var product in allProducts) {
      final category = product["category"] as String? ?? "غير مصنف";
      if (!categoryProducts.containsKey(category)) {
        categoryProducts[category] = product;
      }
    }

    final filteredProducts = categoryProducts.values.toList();

    return CustomScrollView(
      cacheExtent: 1000,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildFullScreenHero(context, size),
              const SizedBox(height: 24),
              _buildGoldRates(state.goldPrices),
              const SizedBox(height: 36),
              _buildSectionTitle(
                'أحدث المنتجات',
                "عرض الكل",
                onActionTap: () {
                  ref.read(navigationProvider.notifier).state = 1;
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.58,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final p = filteredProducts[index];
                return _buildProductCard(context, ref, p, index);
              },
              childCount: filteredProducts.length,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 60)),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
  ) {
    return AppBar(
      backgroundColor: const Color(0xFF070A11),
      elevation: 0,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: GoldGradientText(
        'AURORA',
        size: 24,
        weight: FontWeight.w800,
      ),
    );
  }

  Widget _buildFullScreenHero(BuildContext context, Size size) {
    return Container(
      width: size.width,
      height: size.height * 0.75,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/sets/21.webp"),
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              const Color(0xFF070A11),
              const Color(0xFF070A11).withValues(alpha: 0.2),
              Colors.black.withValues(alpha: 0.5),
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(height: 80),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppTheme.accent.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: AppTheme.accent, size: 12),
                  SizedBox(width: 6),
                  Text(
                    "تشكيلة 2026 الفاخرة",
                    style: TextStyle(
                      color: AppTheme.accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            RepaintBoundary( // عزل عملية الرسم المعقدة للنص المذهب
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Colors.white, Color(0xFFFFF7D5), Color(0xFFF7C948)],
                ).createShader(bounds),
                child: Text(
                  "فن الصياغة\nيلمس روحك",
                  style: GoogleFonts.cairo(
                    fontSize: 42,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "نجمع بين التراث والحداثة لنقدم لكِ قطعاً تليق بجمالكِ الفريد وتعبّر عن شخصيتكِ.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontWeight: FontWeight.w400,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
    String actionText, {
    VoidCallback? onActionTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText,
              style: const TextStyle(
                color: AppTheme.accent,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    WidgetRef ref,
    Map<String, dynamic> p,
    int index,
  ) {
    final favorites = ref.watch(favoritesProvider);
    final user = ref.watch(userProvider).currentUser;
    final isFavorite = favorites.contains(p['name']);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100).clamp(0, 400)),
      curve: Curves.easeOutQuint,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            "/product",
            arguments: {...p, "heroTag": "home_${p["name"]}"},
          );
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
              ),
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
                      tag: "home_${p["name"]}",
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
                      p["category"] ?? "مجوهرات",
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

  Widget _buildGoldRates(Map<String, double> rates) {
    if (rates.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF161B26),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.accent.withValues(alpha: 0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.trending_up, color: AppTheme.accent, size: 18),
                ),
                const SizedBox(width: 12),
                const Text(
                  "أسعار الذهب مباشر (USD/جرام)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                const Text(
                  "تحديث مباشر",
                  style: TextStyle(color: Colors.greenAccent, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildRateItem("عيار 24", rates['24'] ?? 0.0),
                _buildRateItem("عيار 21", rates['21'] ?? 0.0),
                _buildRateItem("عيار 18", rates['18'] ?? 0.0),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateItem(String label, double price) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        const SizedBox(height: 6),
        Text(
          PriceFormatter.format(price),
          style: GoogleFonts.montserrat(
            color: AppTheme.accent,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(WidgetRef ref, String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 60),
          const SizedBox(height: 16),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => ref.read(productProvider.notifier).fetchProducts(),
            child: const Text("حاول مرة أخرى", style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
