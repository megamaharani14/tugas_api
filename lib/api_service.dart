import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String apiKey = 'beb9e531eaec28ddd4841599a2b44f23';

  Future<Map<String, dynamic>> fetchWeatherByCity(String city) async {
    final String baseUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey';

    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data for $city');
    }
  }
}
