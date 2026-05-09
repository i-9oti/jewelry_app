import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../providers/user_provider.dart';
import '../utils/toast_utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    final userNotifier = ref.read(userProvider.notifier);

    
    final success = await userNotifier.login(username, password);
    if (success && mounted) {
      ToastUtils.showToast(context, 'تم تسجيل الدخول بنجاح 👋');
      Navigator.pushNamedAndRemoveUntil(context, "/main", (route) => false);
    } else if (mounted) {
      ToastUtils.showToast(context, "اسم المستخدم أو كلمة المرور غير صحيحة", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {

    final userState = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF050915),
      body: Stack(
        children: [
          // خلفية جذابة
          Positioned.fill(
            child: Image.asset(
              "assets/images/sets/21.webp",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    const Color(0xFF050915).withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F1527).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      const SizedBox(height: 20),
                      ShaderMask(
                        shaderCallback: _shaderCallback,
                        child: Text(
                          'دخول',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "مرحباً بك في عالم AURORA",
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      const SizedBox(height: 32),
                      
                      _buildTextField(
                        controller: _usernameController,
                        label: "اسم المستخدم",
                        icon: Icons.person_outline, validator: (v) {
                          if (v == null || v.isEmpty) return "يرجى إدخال اسم المستخدم";
                          return null;
                        },
                      ),

                      _buildTextField(
                        controller: _passwordController,
                        label: 'كلمة المرور',
                        icon: Icons.lock_outline, isPassword: true,
                        obscure: !_isPasswordVisible,
                        onToggleVisibility: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                        validator: (v) {
                          if (v == null || v.isEmpty) return "يرجى إدخال كلمة المرور";
                          if (v.length < 6) return "كلمة المرور يجب أن لا تقل عن 6 أحرف";
                          return null;
                        },
                      ),

                      const SizedBox(height: 10),
                      
                      if (userState.isLoading)
                        const CircularProgressIndicator(color: Color(0xFFF7C948))
                      else
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF7C948),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              elevation: 8,
                              shadowColor: const Color(0xFFF7C948).withValues(alpha: 0.4),
                            ),
                            onPressed: _handleLogin,
                            child: const Text('دخول', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "ليس لديك حساب؟ ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, "/register"),
                            child: const Text("إنشاء حساب جديد", style: TextStyle(color: Color(0xFFF7C948), fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Shader _shaderCallback(Rect bounds) {
    return const LinearGradient(colors: [Color(0xFFFFF7D5), Color(0xFFF7C948), Color(0xFFC78822)]).createShader(bounds);
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onToggleVisibility,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white54),
          prefixIcon: Icon(icon, color: const Color(0xFFF7C948)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFFF7C948),
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFFF7C948))),
          errorStyle: const TextStyle(color: Colors.redAccent),
        ),
      ),
    );
  }
}
