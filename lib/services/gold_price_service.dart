import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gold_price_model.dart';

class GoldPriceService {
  // يمكنك الحصول على مفتاح خاص بك مجاناً من https://www.goldapi.io/
  static const String _apiKey = "goldapi-1fef9704122339c8d8bbdf4a76b41c7b-io"; 

  static Future<GoldPriceModel> getCurrentGoldPrices() async {
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
        return GoldPriceModel.fromApi(data);
      } else {
        return GoldPriceModel.fallback();
      }
    } catch (e) {
      return GoldPriceModel.fallback();
    }
  }
}
