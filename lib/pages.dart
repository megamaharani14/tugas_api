import 'package:flutter/material.dart';
import 'api_service.dart';

class SearchWeatherPage extends StatefulWidget {
  @override
  _SearchWeatherPageState createState() => _SearchWeatherPageState();
}

class _SearchWeatherPageState extends State<SearchWeatherPage> {
  final ApiService apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  String errorMessage = '';

  void searchWeather() async {
    final city = _searchController.text.trim();
    if (city.isEmpty) {
      setState(() {
        errorMessage = 'Please enter a city name';
        weatherData = null;
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
      weatherData = null;
    });

    try {
      final data = await apiService.fetchWeatherByCity(city);
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to fetch data for "$city"';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 115, 140),
        title: Center(child: Text('Search Weather',
        style: TextStyle(
          color: Colors.white
        ),)
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter city or Country name',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => searchWeather(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: searchWeather,
              child: Text('Search'),
            ),
            SizedBox(height: 16),
            if (isLoading) Center(child: CircularProgressIndicator()),
            if (errorMessage.isNotEmpty)
              Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            if (weatherData != null)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'City or Country: ${weatherData!['name']}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Weather: ${weatherData!['weather'][0]['description']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Temperature: ${(weatherData!['main']['temp'] - 273.15).toStringAsFixed(2)}°C',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Humidity: ${weatherData!['main']['humidity']}%',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Wind Speed: ${weatherData!['wind']['speed']} m/s',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
