class GoldPriceModel {
  final double price24;
  final double price21;
  final double price18;
  final DateTime updatedAt;

  GoldPriceModel({
    required this.price24,
    required this.price21,
    required this.price18,
    required this.updatedAt,
  });

  // يحول البيانات القادمة من الـ API إلى هذا الموديل
  factory GoldPriceModel.fromApi(Map<String, dynamic> data) {
    // السعر من الـ API يكون للأونصة، نحوله لجرام 24
    double priceOunce = (data['price'] as num).toDouble();
    double p24 = priceOunce / 31.1035;

    return GoldPriceModel(
      price24: p24,
      price21: p24 * (21 / 24),
      price18: p24 * (18 / 24),
      updatedAt: DateTime.now(),
    );
  }

  // قيم افتراضية في حال فشل الـ API
  factory GoldPriceModel.fallback() {
    return GoldPriceModel(
      price24: 310.5,
      price21: 271.7,
      price18: 232.9,
      updatedAt: DateTime.now(),
    );
  }

  // أهم دالة: تحسب سعر المنتج النهائي (ذهب + مصنعية + ضريبة)
  double calculateFinalPrice({
    required double weight,
    required String karat,
    double laborFee = 150.0, // أجرة المصنعية الافتراضية
    double vat = 0.15,      // الضريبة 15%
  }) {
    // 1. تحديد سعر الجرام بالدولار بناءً على العيار
    double usdPricePerGram;
    if (karat == '24') {
      usdPricePerGram = price24;
    } else if (karat == '18') {
      usdPricePerGram = price18;
    } else {
      usdPricePerGram = price21; // الافتراضي عيار 21
    }

    // 2. تحويل السعر للريال السعودي (3.75)
    double sarPricePerGram = usdPricePerGram * 3.75;

    // 3. حسبة قيمة الذهب
    double goldValue = weight * sarPricePerGram;

    // 4. السعر قبل الضريبة (ذهب + مصنعية)
    double totalBeforeVat = goldValue + laborFee;

    // 5. السعر النهائي بعد الضريبة
    return (totalBeforeVat * (1 + vat)).roundToDouble();
  }
}
