import 'dart:ui'; // Required for ImageFilter.blur

import 'package:flutter/material.dart';
import 'package:flutter_weather_app/weather_app_modal.dart';
import 'package:flutter_weather_app/weather_app_services.dart';

// --- UI Constants for a professional look ---
const Color _primaryColor = Color(0xFF2E72E2);
const Color _secondaryColor = Color(0xFF62A0FF);
const TextStyle _whiteTextStyle = TextStyle(color: Colors.white);

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key}) : super(key: key);

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  final TextEditingController _searchController = TextEditingController();
  WeatherAppModal? _weather;
  bool _isLoading = false;
  String _currentCity = "Vijayawada"; // To keep track of the current city

  Future<void> _fetchWeather(String city) async {
    // Prevent unnecessary API calls for the same city
    if (_isLoading) return;

    setState(() => _isLoading = true);
    try {
      var data = await WeatherAppServices.makeApiCall(city);
      setState(() {
        _weather = data;
        if (data != null) {
          _currentCity = data.locationName;
        }
      });
    } catch (e) {
      // Handle potential errors from the API call gracefully
      setState(() {
        _weather = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather(_currentCity); // Fetch weather for the default city
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image and Gradient Overlay
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'), // Ensure you have this asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [_primaryColor.withOpacity(0.8), _secondaryColor.withOpacity(0.6)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            ),
          ),
          // 2. Main Content
          SafeArea(
            child: Center(
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : _weather == null
                  ? _buildErrorUI()
                  : _buildWeatherUI(),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the main weather information UI.
  Widget _buildWeatherUI() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildSearchBar(),
          const SizedBox(height: 40),
          Text(_weather!.locationName, style: _whiteTextStyle.copyWith(fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          Text(_weather!.presentCondition, style: _whiteTextStyle.copyWith(fontSize: 18, color: Colors.white.withOpacity(0.8))),
          const SizedBox(height: 20),
          if (_weather!.iconLink != null) Image.network(_weather!.iconLink!, height: 120, fit: BoxFit.contain),
          const SizedBox(height: 10),
          Text(
            "${_weather!.temperature.toStringAsFixed(0)}°C",
            style: _whiteTextStyle.copyWith(
              fontSize: 80,
              fontWeight: FontWeight.w200, // A lighter font weight looks more modern
            ),
          ),
          const Spacer(),
          _buildInfoCards(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Builds the search bar widget.
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      style: _whiteTextStyle,
      cursorColor: _secondaryColor,
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        if (value.trim().isNotEmpty) {
          _fetchWeather(value.trim());
          _searchController.clear();
        }
      },
      decoration: InputDecoration(
        hintText: "Search for a city...",
        hintStyle: _whiteTextStyle.copyWith(color: Colors.white.withOpacity(0.7)),
        prefixIcon: const Icon(Icons.search, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }

  /// Builds the row of info cards at the bottom.
  Widget _buildInfoCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoCard(icon: Icons.air, label: "Wind", value: "${_weather!.windSpeed} km/h"),
        _infoCard(icon: Icons.water_drop_outlined, label: "Humidity", value: "${_weather!.humidity}%"),
        _infoCard(icon: Icons.thermostat_outlined, label: "Feels Like", value: "${_weather!.feelsLike.toStringAsFixed(0)}°C"),
      ],
    );
  }

  /// Builds the UI for when weather data is not available.
  Widget _buildErrorUI() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off_outlined, color: Colors.white.withOpacity(0.8), size: 80),
          const SizedBox(height: 20),
          Text(
            "City Not Found",
            style: _whiteTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            "Please check the spelling or try searching for another city.",
            style: _whiteTextStyle.copyWith(fontSize: 16, color: Colors.white.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: Colors.white,
              foregroundColor: _primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () => _fetchWeather(_currentCity), // Retry with the last successful city
            icon: const Icon(Icons.refresh),
            label: const Text("Try Again", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  /// A styled card for displaying individual weather metrics.
  /// Features a modern "glassmorphism" effect.
  Widget _infoCard({required IconData icon, required String label, required String value}) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
            ),
            child: Column(
              children: [
                Icon(icon, color: Colors.white, size: 28),
                const SizedBox(height: 10),
                Text(value, style: _whiteTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(label, style: _whiteTextStyle.copyWith(fontSize: 14, color: Colors.white.withOpacity(0.8))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
