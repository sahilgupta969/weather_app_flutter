import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/ui/weather_data.dart';

class Weather extends StatelessWidget {
  final WeatherData weatherData;

  const Weather({super.key, required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDateSection(),
          const SizedBox(height: 20),
          _buildTemperatureSection(),
          const SizedBox(height: 30),
          _buildDescriptionSection(),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Text(
      DateFormat('MMMM d, H:mm').format(DateTime.now()),
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildTemperatureSection() {
    // Safely handle temperature value
    final temp = weatherData.temp is num
        ? (weatherData.temp as num).toDouble()
        : double.tryParse(weatherData.temp.toString()) ?? 0.0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Temperature value
        Text(
          temp.toStringAsFixed(0),
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.w300,
            color: Colors.white,
            height: 0.9,
          ),
        ),

        // Temperature unit
        const Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            '℃',
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(width: 20),

        // Weather icon
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          child: Image.network(
            'https://openweathermap.org/img/w/${weatherData.icon}.png',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.wb_sunny,
              size: 60,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Location name - with overflow protection
        Expanded(
          child: Text(
            weatherData.name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),

        const SizedBox(width: 16),

        // Weather condition
        Text(
          weatherData.main.toUpperCase(),
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white70,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}