import 'package:flutter/material.dart';

/// Represents the type of device based on the available screen width.
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

class ResponsiveUtils {
  ResponsiveUtils._();

  /// Mobile breakpoint.
  static const double mobileBreakpoint = 600;

  /// Desktop breakpoint.
  static const double desktopBreakpoint = 1024;

  /// Returns the current device type based on screen width.
  static DeviceType deviceType(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    }

    if (width < desktopBreakpoint) {
      return DeviceType.tablet;
    }

    return DeviceType.desktop;
  }

  /// Returns true if the current device is mobile.
  static bool isMobile(BuildContext context) {
    return deviceType(context) == DeviceType.mobile;
  }

  /// Returns true if the current device is tablet.
  static bool isTablet(BuildContext context) {
    return deviceType(context) == DeviceType.tablet;
  }

  /// Returns true if the current device is desktop.
  static bool isDesktop(BuildContext context) {
    return deviceType(context) == DeviceType.desktop;
  }

  /// Returns true if the current device is tablet or desktop.
  static bool isTabletOrDesktop(BuildContext context) {
    return !isMobile(context);
  }

  /// Returns the available screen width.
  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  /// Returns the available screen height.
  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }
}