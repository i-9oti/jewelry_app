import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_helper.dart';
import '../services/gold_price_service.dart';
import '../models/gold_price_model.dart';

class ProductState {
  final List<Map<String, dynamic>> allProducts;
  final List<Map<String, dynamic>> filteredProducts;
  final GoldPriceModel? goldPrice;
  final bool isLoading;
  final String errorMessage;

  ProductState({
    required this.allProducts,
    required this.filteredProducts,
    this.goldPrice,
    required this.isLoading,
    required this.errorMessage,
  });

  ProductState copyWith({
    List<Map<String, dynamic>>? allProducts,
    List<Map<String, dynamic>>? filteredProducts,
    GoldPriceModel? goldPrice,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProductState(
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      goldPrice: goldPrice ?? this.goldPrice,
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
          goldPrice: null,
          isLoading: true,
          errorMessage: '',
        )) {
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (!state.isLoading) state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      // 1. جلب أسعار الذهب (مع مهلة زمنية 5 ثواني)
      final priceModel = await GoldPriceService.getCurrentGoldPrices().timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return GoldPriceModel.fallback();
        },
      );
      
      // 2. جلب المنتجات من القاعدة
      final rawProducts = await DatabaseHelper.instance.getProducts();
      
      // 3. حساب السعر الديناميكي لكل منتج باستخدام الموديل
      final calculatedProducts = rawProducts.map((p) {
        final product = Map<String, dynamic>.from(p);
        final weight = (product['weight'] as num?)?.toDouble() ?? 0.0;
        final karat = product['karat'] as String? ?? '21';
        
        // استخدام الدالة الموجودة داخل الموديل للحسبة
        product['calculatedPrice'] = priceModel.calculateFinalPrice(
          weight: weight,
          karat: karat,
        );
        
        return product;
      }).toList();

      state = state.copyWith(
        allProducts: calculatedProducts,
        filteredProducts: calculatedProducts,
        goldPrice: priceModel,
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
