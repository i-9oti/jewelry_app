import 'dart:convert';
import 'package:http/http.dart' as http;

class GoldPriceService {
  // يمكنك الحصول على مفتاح خاص بك مجاناً من https://www.goldapi.io/
  static const String _apiKey = "goldapi-1fef9704122339c8d8bbdf4a76b41c7b-io"; 

  static Future<Map<String, double>> getCurrentGoldPrices() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.goldapi.io/api/XAU/USD'),
        headers: {
          'x-access-token': _apiKey,
          'Content-Type': 'application/json'
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // جلب سعر الأونصة وتحويله لجرام 24
        double priceOunce = (data['price'] as num).toDouble();
        double price24 = priceOunce / 31.1035;
        
        // حساب العيارات الأخرى
        double price21 = price24 * (21 / 24);
        double price18 = price24 * (18 / 24);


        return {
          '24': price24,
          '21': price21,
          '18': price18,
        };
      } else {
        return _getFallbackPrices();
      }
    } catch (e) {
      return _getFallbackPrices();
    }
  }

  static Map<String, double> _getFallbackPrices() {
    return {
      '24': 76.5,
      '21': 66.9,
      '18': 57.3,
    };
  }
}
