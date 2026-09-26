import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:pharmace/Frontend/theme/app_colors.dart';

/// Holds parsed geographic coordinates and reverse-geocoded address fields.
class LocationResult {
  final String latitude;
  final String longitude;
  final String address;
  final String city;
  final String state;
  final String pincode;
  final String country;

  const LocationResult({
    required this.latitude,
    required this.longitude,
    this.address = '',
    this.city = '',
    this.state = '',
    this.pincode = '',
    this.country = '',
  });

  String get formattedCoordinates => '$latitude° N, $longitude° E';

  String get displayAddress {
    final parts = [address, city, state, pincode]
        .where((s) => s.trim().isNotEmpty)
        .toList();
    return parts.join(', ');
  }
}

/// Centralized service to handle in-app location permissions, native GPS fetching,
/// network IP geolocation fallbacks (for Windows/Desktop), and address reverse geocoding.
class LocationService {
  LocationService._();
  static final LocationService instance = LocationService._();

  /// Prompts the user with an in-app dialog for permission directly inside the app,
  /// without forcing them out to system/OS settings.
  Future<bool> requestInAppPermission(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: AppColors.primary,
              size: 32,
            ),
          ),
          title: const Text(
            'Allow Location Access?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Pharmace needs your location permission to automatically pin your shop’s coordinates and detect your address.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.8),
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Don’t Allow'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              child: const Text('While using app'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  /// Obtains the device's current location and reverse-geocoded address.
  /// Seamlessly falls back to IP geolocation and OpenStreetMap reverse geocoding
  /// on Windows desktop or devices without GPS.
  Future<LocationResult?> getCurrentLocationAddress() async {
    try {
      bool serviceEnabled = false;
      try {
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
      } catch (_) {}

      LocationPermission permission = LocationPermission.denied;
      if (serviceEnabled) {
        try {
          permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
          }
        } catch (_) {}
      }

      Position? position;
      if (serviceEnabled &&
          permission != LocationPermission.denied &&
          permission != LocationPermission.deniedForever) {
        try {
          position = await Geolocator.getCurrentPosition(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.medium,
              timeLimit: Duration(seconds: 5),
            ),
          );
        } catch (_) {
          position = null;
        }
      }

      // If native GPS is not available (e.g. Windows desktop without hardware GPS or restricted access),
      // seamlessly fall back to network IP geolocation in-app
      if (position == null) {
        return await _getFallbackNetworkLocation();
      }

      String address = '';
      String city = '';
      String state = '';
      String pincode = '';
      String country = '';

      // Reverse geocode on Android / iOS via platform geocoding
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        try {
          final List<Placemark> placemarks =
              await Geocoding().placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );

          if (placemarks.isNotEmpty) {
            final place = placemarks.first;
            address = [place.name, place.street, place.subLocality]
                .where((e) => e != null && e.isNotEmpty)
                .join(', ');
            city = place.locality ?? '';
            state = place.administrativeArea ?? '';
            pincode = place.postalCode ?? '';
            country = place.country ?? '';
          }
        } catch (_) {}
      }

      // OpenStreetMap Nominatim reverse geocode for Windows or fallback
      if (address.isEmpty && city.isEmpty) {
        try {
          final url = Uri.parse(
            'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}&zoom=18&addressdetails=1',
          );
          final res = await http.get(
            url,
            headers: {'User-Agent': 'PharmaceApp/1.0'},
          ).timeout(const Duration(seconds: 5));

          if (res.statusCode == 200) {
            final decoded = jsonDecode(res.body) as Map<String, dynamic>;
            final addr = decoded['address'] as Map<String, dynamic>?;
            if (addr != null) {
              final road = addr['road'] ?? addr['suburb'] ?? addr['neighbourhood'] ?? '';
              address = road.toString();
              city = (addr['city'] ?? addr['town'] ?? addr['village'] ?? addr['county'] ?? '').toString();
              state = (addr['state'] ?? '').toString();
              pincode = (addr['postcode'] ?? '').toString();
              country = (addr['country'] ?? '').toString();
            }
          }
        } catch (_) {}
      }

      return LocationResult(
        latitude: position.latitude.toStringAsFixed(6),
        longitude: position.longitude.toStringAsFixed(6),
        address: address,
        city: city,
        state: state,
        pincode: pincode,
        country: country,
      );
    } catch (_) {
      return await _getFallbackNetworkLocation();
    }
  }

  /// IP-based geolocation fallback with OSM reverse geocoding
  Future<LocationResult?> _getFallbackNetworkLocation() async {
    try {
      final response = await http
          .get(Uri.parse('http://ip-api.com/json'))
          .timeout(const Duration(seconds: 6));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'success') {
          final double lat = (data['lat'] as num).toDouble();
          final double lon = (data['lon'] as num).toDouble();
          final String city = (data['city'] ?? '').toString();
          final String state = (data['regionName'] ?? '').toString();
          final String zip = (data['zip'] ?? '').toString();
          final String country = (data['country'] ?? '').toString();

          String address = '';
          try {
            final osmUrl = Uri.parse(
              'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=18&addressdetails=1',
            );
            final osmRes = await http.get(
              osmUrl,
              headers: {'User-Agent': 'PharmaceApp/1.0'},
            ).timeout(const Duration(seconds: 4));

            if (osmRes.statusCode == 200) {
              final osmData = jsonDecode(osmRes.body) as Map<String, dynamic>;
              final addr = osmData['address'] as Map<String, dynamic>?;
              if (addr != null) {
                final road = addr['road'] ?? addr['suburb'] ?? addr['neighbourhood'] ?? '';
                address = road.toString();
              }
            }
          } catch (_) {}

          return LocationResult(
            latitude: lat.toStringAsFixed(6),
            longitude: lon.toStringAsFixed(6),
            address: address,
            city: city,
            state: state,
            pincode: zip,
            country: country,
          );
        }
      }
    } catch (_) {}
    return null;
  }
}
