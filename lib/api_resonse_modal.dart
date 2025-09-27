class ApiResponseModal {
  final Location location;
  final Current current;
  ApiResponseModal({required this.location, required this.current});

  factory ApiResponseModal.fromJson(Map<String, dynamic> json) {
    return ApiResponseModal(location: Location.fromJson(json['location']), current: Current.fromJson(json['current']));
  }
}

class Location {
  final String name;
  final String region;
  final String country;

  Location({required this.name, required this.region, required this.country});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(name: json['name'], region: json['region'], country: json['country']);
  }
}

class Current {
  final double tempC;
  final String conditionText;
  final String conditionIcon;
  final double windKph;
  final int humidity;
  final double feelsLikeC;

  Current({required this.tempC, required this.conditionText, required this.conditionIcon, required this.windKph, required this.humidity, required this.feelsLikeC});

  factory Current.fromJson(Map<String, dynamic> json) {
    return Current(
      tempC: (json['temp_c'] as num).toDouble(),
      conditionText: json['condition']['text'],
      conditionIcon: json['condition']['icon'],
      windKph: (json['wind_kph'] as num).toDouble(),
      humidity: json['humidity'],
      feelsLikeC: (json['feelslike_c'] as num).toDouble(),
    );
  }
}
