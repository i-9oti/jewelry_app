import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme/app_theme.dart';

import 'providers/cart_provider.dart';

import 'package:flutter_localizations/flutter_localizations.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/category_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/payment_result_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'providers/favorites_provider.dart';
import 'providers/user_provider.dart';
import 'providers/navigation_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // تحسين أداء تحميل الخطوط
  GoogleFonts.config.allowRuntimeFetching = true;
  
  runApp(
    const ProviderScope(
      child: JewelryApp(),
    ),
  );
}

class JewelryApp extends ConsumerWidget {
  const JewelryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    

    return MaterialApp(
      title: 'AURORA',
      debugShowCheckedModeBanner: false,

      // اللغات والاتجاهات
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ثيم التطبيق
      theme: AppTheme.darkTheme, // Use dark theme as default
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,

      // الصفحة الأولى
      initialRoute: "/splash",

      routes: {
        "/splash": (_) => const SplashScreen(),
        "/main": (_) => const MainNavigation(),
        "/home": (_) => const HomeScreen(),
        "/login": (_) => const LoginScreen(),
        "/register": (_) => const RegisterScreen(),
        "/category": (_) => const CategoryScreen(),
        "/product": (_) => const ProductDetailsScreen(),
        "/cart": (_) => const CartScreen(),
        "/checkout": (_) => const CheckoutScreen(),
        "/profile": (_) => const ProfileScreen(),
        "/payment_result": (_) => const PaymentResultScreen(),
        "/favorites": (_) => const FavoritesScreen(),
        "/orders": (_) => const OrdersScreen(),
        "/edit_profile": (_) => const EditProfileScreen(),
      },
    );
  }
}

//
// ==========================================================
//          BOTTOM NAVIGATION BAR + PAGE SWITCHING
// ==========================================================
//

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  bool _initialized = false;

  final List<Widget> pages = const [
    HomeScreen(),
    CategoryScreen(),
    FavoritesScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final user = ref.read(userProvider).currentUser;
      if (user != null) {
        final email = user['email'];
        Future.microtask(() {
          if (mounted) {
            ref.read(cartProvider.notifier).loadCart(email);
            ref.read(favoritesProvider.notifier).loadFavorites(email);
          }
        });
      }
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {

    final currentIndex = ref.watch(navigationProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: AppTheme.accent,
        unselectedItemColor: Colors.grey,
        backgroundColor: const Color(0xFF0F1527),
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          ref.read(navigationProvider.notifier).state = index;
        },

        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.category_outlined),
            label: 'التصنيفات',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_outline),
            label: 'المفضلة',
          ),
          BottomNavigationBarItem(
            icon: Consumer(
              builder: (context, ref, child) {
                final cartItemsCount = ref.watch(cartProvider.select((s) => s.itemCount));
                return Badge(
                  label: Text(cartItemsCount.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)),
                  isLabelVisible: cartItemsCount > 0,
                  backgroundColor: AppTheme.accent,
                  textColor: Colors.black,
                  child: const Icon(Icons.shopping_cart_outlined),
                );
              },
            ),
            label: 'السلة',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }
}
