import 'package:http/http.dart' show Client;
import 'package:weather_app/ui/weather_data.dart';

class WeatherApi {
  static const _apiKey = ''; // ADD YOUR API KEY HERE
  static const _baseUrl = 'https://api.openweathermap.org/data/2.5';
  final Client client;

  WeatherApi({Client? client}) : client = client ?? Client();

  String _buildUrl(double lat, double lon) {
    return '$_baseUrl/weather?'
        'lat=$lat&'
        'lon=$lon&'
        'appid=$_apiKey&'
        'units=metric';
  }

  Future<WeatherData> getWeather({required double lat, required double lon}) async {
    final url = _buildUrl(lat, lon);

    try {
      final response = await client.get(
        Uri.parse(url),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        return WeatherData.deserialize(response.body);
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
