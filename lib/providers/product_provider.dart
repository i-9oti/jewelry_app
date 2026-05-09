import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_helper.dart';
import '../services/gold_price_service.dart';

class ProductState {
  final List<Map<String, dynamic>> allProducts;
  final List<Map<String, dynamic>> filteredProducts;
  final Map<String, double> goldPrices;
  final bool isLoading;
  final String errorMessage;

  ProductState({
    required this.allProducts,
    required this.filteredProducts,
    required this.goldPrices,
    required this.isLoading,
    required this.errorMessage,
  });

  ProductState copyWith({
    List<Map<String, dynamic>>? allProducts,
    List<Map<String, dynamic>>? filteredProducts,
    Map<String, double>? goldPrices,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProductState(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      goldPrices: goldPrices ?? this.goldPrices,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProductNotifier extends StateNotifier<ProductState> {
  ProductNotifier()
      : super(ProductState(
          allProducts: [],
          filteredProducts: [],
          goldPrices: {},
          isLoading: true,
          errorMessage: '',
        )) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (!state.isLoading) state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      // 1. جلب أسعار الذهب (مع مهلة زمنية 5 ثواني)
      final prices = await GoldPriceService.getCurrentGoldPrices().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return {'24': 310.5, '21': 271.7, '18': 232.9};
        },
      );
      
      // 2. جلب المنتجات من القاعدة
      final rawProducts = await DatabaseHelper.instance.getProducts();
      
      // 3. حساب السعر الديناميكي لكل منتج
      final calculatedProducts = rawProducts.map((p) {
        final product = Map<String, dynamic>.from(p);
        final weight = (product['weight'] as num?)?.toDouble() ?? 0.0;
        final karat = product['karat'] as String? ?? '21';
        
        // 1. جلب سعر الجرام بالدولار (من الـ API أو قيمة افتراضية آمنة)
        double usdPrice = prices[karat] ?? prices['21'] ?? 66.0;
        
        // 2. تحويل السعر للريال السعودي (3.75)
        double sarPricePerGram = usdPrice * 3.75;
        
        // 3. الحسبة النهائية
        final double goldValue = weight * sarPricePerGram;
        const double laborFee = 150.0; // أجرة المصنعية
        
        final double totalBeforeVat = goldValue + laborFee;
        final double finalPrice = totalBeforeVat * 1.15; // إضافة الضريبة
        
        product['calculatedPrice'] = finalPrice.roundToDouble();
        return product;
      }).toList();

      state = state.copyWith(
        allProducts: calculatedProducts,
        filteredProducts: calculatedProducts,
        goldPrices: prices,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'حدث خطأ أثناء تحميل البيانات: $e',
      );
    }
  }

  void filterByCategory(String categoryName, String allLabel) {
    if (categoryName == allLabel) {
      state = state.copyWith(filteredProducts: state.allProducts);
    } else {
      state = state.copyWith(
        filteredProducts: state.allProducts
            .where((p) => p["category"] == categoryName)
            .toList(),
      );
    }
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      state = state.copyWith(filteredProducts: state.allProducts);
    } else {
      state = state.copyWith(
        filteredProducts: state.allProducts
            .where((p) => p["name"]
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList(),
      );
    }
  }
}

final productProvider = StateNotifierProvider<ProductNotifier, ProductState>((ref) {
  return ProductNotifier();
});
