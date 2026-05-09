import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';


import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../utils/toast_utils.dart';
import '../widgets/credit_card_widget.dart';
import '../services/database_helper.dart';
import '../utils/price_formatter.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String cardNumber = "XXXX XXXX XXXX XXXX";
  String cardHolder = "FULL NAME";
  String expiryDate = "MM/YY";
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {

    final cart = ref.watch(liveCartProvider);

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('متابعة لإتمام الدفع', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              cardHolder: cardHolder,
              expiryDate: expiryDate),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                   _buildField(
                    label: "رقم البطاقة (16 رقم)", onChanged: (v) => setState(() => cardNumber = v.isEmpty ? "XXXX XXXX XXXX XXXX" : v),
                    keyboardType: TextInputType.number,
                    maxLength: 16,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  _buildField(
                    label: "اسم حامل البطاقة", onChanged: (v) => setState(() => cardHolder = v.isEmpty ? "FULL NAME" : v),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildField(
                          label: "تاريخ الانتهاء MM/YY", onChanged: (v) => setState(() => expiryDate = v.isEmpty ? "MM/YY" : v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildField(
                          label: "CVV", 
                          onChanged: (v) {},
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _summaryCard(cart),
          ],
        ),
      ),
    );
  }

  void _processPayment(CartState cart) {
    // Check if card number is exactly 16 digits and not the placeholder
    bool isInvalidCard = cardNumber.length != 16 || cardNumber.contains('X');
    
    if (isInvalidCard || cardHolder == "FULL NAME") {
      ToastUtils.showToast(context, "يرجى تعبئة كافة البيانات بشكل صحيح (16 رقم للبطاقة)", isError: true);
      return;
    }

    setState(() => isProcessing = true);
    final navigator = Navigator.of(context);
    final userEmail = ref.read(userProvider).currentUser?['email'] ?? "";

    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      
      final productNames = cart.items.map((i) => i["name"]).join(', ');
      await DatabaseHelper.instance.saveOrder(userEmail, cart.total, productNames);

      await ref.read(cartProvider.notifier).clear(userEmail);
      navigator.pushNamedAndRemoveUntil("/payment_result", (route) => route.settings.name == "/main", arguments: true);
    });
  }

  Widget _summaryCard(CartState cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الإجمالي النهائي', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              Text("${PriceFormatter.format(cart.total)} ر.س", style: const TextStyle(color: AppTheme.accent, fontWeight: FontWeight.bold, fontSize: 18)),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent, foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: isProcessing ? null : () => _processPayment(cart),
              child: isProcessing 
                ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                : const Text("تأكيد وإتمام الدفع", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String label,
    required void Function(String)? onChanged,
    TextInputType? keyboardType,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        maxLength: maxLength,
        inputFormatters: inputFormatters,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white54, fontSize: 13),
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.1),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
          counterText: "", // Hide character counter
        ),
      ),
    );
  }
}
