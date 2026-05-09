import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/user_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    _checkSession();
  }

  Future<void> _checkSession() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    final password = prefs.getString('user_password');

    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    if (email != null && password != null) {
      final userNotifier = ref.read(userProvider.notifier);
      final success = await userNotifier.login(email, password);
      
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, "/main");
        return;
      }
    }
    
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050915),
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              ShaderMask(
                shaderCallback: _shaderCallback,
                child: Text(
                  "AURORA",
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 48,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                    letterSpacing: 12,
                  ),
                ),
              ),
              const SizedBox(height: 60),
              const SizedBox(
                width: 40,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white10,
                  color: Color(0xFFC78822),
                  minHeight: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Shader _shaderCallback(Rect bounds) {
    return const LinearGradient(
      colors: [Color(0xFFFFF7D5), Color(0xFFF7C948), Color(0xFFC78822)],
    ).createShader(bounds);
  }
}
