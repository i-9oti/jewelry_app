import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/database_helper.dart';
import '../providers/product_provider.dart';

class CartState {
  final List<Map<String, dynamic>> items;
  final bool isLoading;

  CartState({required this.items, this.isLoading = false});

  CartState copyWith({List<Map<String, dynamic>>? items, bool? isLoading}) {
    return CartState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  int get itemCount => items.fold<int>(0, (sum, item) => sum + ((item["qty"] as num?)?.toInt() ?? 0));
  double get subtotal => items.fold<double>(0.0, (sum, item) => sum + (((item["price"] as num?)?.toDouble() ?? 0.0) * ((item["qty"] as num?)?.toInt() ?? 0)));
  double get tax => subtotal * 0.15;
  double get shipping => items.isEmpty ? 0 : 25.0;
  double get total => subtotal + tax + shipping;
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState(items: []));

  Future<void> loadCart(String userEmail) async {
    state = state.copyWith(isLoading: true);
    final dbItems = await DatabaseHelper.instance.getCartItems(userEmail);
    state = state.copyWith(
      items: dbItems.map((item) => Map<String, dynamic>.from(item)).toList(),
      isLoading: false,
    );
  }

  Future<void> addItem(String userEmail, Map<String, dynamic> product) async {
    final name = product["name"];
    final priceRaw = product["calculatedPrice"] ?? product["price"];
    final double price = (priceRaw as num?)?.toDouble() ?? 0.0;
    final image = product["image"];

    int index = state.items.indexWhere((p) => p["name"] == name);

    if (index != -1) {
      await increaseQty(userEmail, index);
    } else {
      final newItem = {
        "name": name,
        "qty": 1,
        "price": price,
        "image": image,
      };
      
      final updatedItems = [...state.items, newItem];
      state = state.copyWith(items: updatedItems);
      await DatabaseHelper.instance.addToCart(userEmail, name as String, price, 1, image as String?);
    }
  }

  Future<void> increaseQty(String userEmail, int index) async {
    final updatedItems = state.items.map((item) => Map<String, dynamic>.from(item)).toList();
    final currentQty = (updatedItems[index]["qty"] as num?)?.toInt() ?? 0;
    updatedItems[index]["qty"] = currentQty + 1;
    state = state.copyWith(items: updatedItems);
    await DatabaseHelper.instance.updateCartQty(userEmail, updatedItems[index]["name"], updatedItems[index]["qty"]);
  }

  Future<void> decreaseQty(String userEmail, int index) async {
    final updatedItems = state.items.map((item) => Map<String, dynamic>.from(item)).toList();
    final currentQty = (updatedItems[index]["qty"] as num?)?.toInt() ?? 0;
    if (currentQty > 1) {
      updatedItems[index]["qty"] = currentQty - 1;
      state = state.copyWith(items: updatedItems);
      await DatabaseHelper.instance.updateCartQty(userEmail, updatedItems[index]["name"], updatedItems[index]["qty"]);
    } else {
      await removeItem(userEmail, updatedItems[index]["name"]);
    }
  }

  Future<void> removeItem(String userEmail, String productName) async {
    await DatabaseHelper.instance.removeFromCart(userEmail, productName);
    state = state.copyWith(
      items: state.items.where((p) => p["name"] != productName).toList(),
    );
  }

  Future<void> clear(String userEmail) async {
    await DatabaseHelper.instance.clearCart(userEmail);
    state = state.copyWith(items: []);
  }

  void clearData() {
    state = state.copyWith(items: []);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

final liveCartProvider = Provider<CartState>((ref) {
  final cart = ref.watch(cartProvider);
  final products = ref.watch(productProvider).allProducts;

  if (products.isEmpty || cart.items.isEmpty) return cart;

  final updatedItems = cart.items.map((item) {
    final liveProduct = products.firstWhere(
      (p) => p["name"] == item["name"],
      orElse: () => <String, dynamic>{},
    );
    
    final double currentPrice = (liveProduct["calculatedPrice"] as num?)?.toDouble() ?? (item["price"] as num).toDouble();
    
    return {
      ...item,
      "price": currentPrice,
    };
  }).toList();

  return CartState(items: updatedItems, isLoading: cart.isLoading);
});
