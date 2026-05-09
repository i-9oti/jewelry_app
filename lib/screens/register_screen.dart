import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../providers/user_provider.dart';
import '../utils/toast_utils.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  void _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _userController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final userNotifier = ref.read(userProvider.notifier);

    final success = await userNotifier.register(name, email, password);
    if (success && mounted) {
      ToastUtils.showToast(context, "تم إنشاء الحساب بنجاح، يمكنك الآن تسجيل الدخول");
      Navigator.pop(context);
    } else if (mounted) {
      ToastUtils.showToast(context, "اسم المستخدم أو البريد الإلكتروني مسجل مسبقاً", isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {

    final userState = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF050915),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // إزالة سهم العودة
      ),
      body: Stack(
        children: [
          // ... (Rest of the stack children remain the same)
          Positioned.fill(
            child: Image.asset(
              "assets/images/sets/22.webp",
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
                    Colors.black.withValues(alpha: 0.5),
                    const Color(0xFF050915).withValues(alpha: 0.1),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
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
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFF7C948).withValues(alpha: 0.1),
                        ),
                        child: const Icon(Icons.person_add_outlined, size: 50, color: Color(0xFFF7C948)),
                      ),
                      const SizedBox(height: 20),
                      const ShaderMask(
                        shaderCallback: _shaderCallback,
                        child: Text(
                          "إنشاء حساب جديد",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "انضم إلى عائلة AURORA لتجربة تسوق فريدة",
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      const SizedBox(height: 32),

                      _buildTextField(
                        controller: _userController,
                        label: "اسم المستخدم",
                        icon: Icons.person_outline, validator: (v) {
                          if (v == null || v.isEmpty) return "يرجى إدخال اسم المستخدم";
                          if (v.length < 3) return "اسم المستخدم يجب أن لا يقل عن 3 أحرف";
                          return null;
                        },
                      ),

                      _buildTextField(
                        controller: _emailController,
                        label: 'البريد الإلكتروني',
                        icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return "يرجى إدخال البريد الإلكتروني";
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return "البريد الإلكتروني غير صالح";
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
                            onPressed: _handleRegister,
                            child: const Text("إنشاء الحساب", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          ),
                        ),
                      const SizedBox(height: 24),
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            "لديك حساب بالفعل؟ ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("تسجيل الدخول", style: TextStyle(color: Color(0xFFF7C948), fontWeight: FontWeight.bold)),
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
