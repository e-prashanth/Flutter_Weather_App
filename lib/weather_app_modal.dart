import 'package:flutter_weather_app/api_resonse_modal.dart';

class WeatherAppModal {
  String locationName;
  String region;
  String country;
  double temperature;
  String presentCondition;
  double windSpeed;
  double humidity;
  double feelsLike;
  String? iconLink;
  WeatherAppModal({
    required this.locationName,
    required this.region,
    required this.country,
    required this.temperature,
    required this.presentCondition,
    required this.windSpeed,
    required this.humidity,
    required this.feelsLike,
    this.iconLink,
  });
  factory WeatherAppModal.fromApiResponse(ApiResponseModal api) {
    return WeatherAppModal(
      locationName: api.location.name,
      region: api.location.region,
      country: api.location.country,
      temperature: api.current.tempC,
      presentCondition: api.current.conditionText,
      windSpeed: api.current.windKph,
      humidity: api.current.humidity.toDouble(),
      feelsLike: api.current.feelsLikeC,
      iconLink: "https:${api.current.conditionIcon}", // API gives //... so prefix with https:
    );
  }
}
