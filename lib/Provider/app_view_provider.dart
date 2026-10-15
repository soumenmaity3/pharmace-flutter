import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppView {
  splash,
  login,
  signup,
  dashboard,
  addScreen,
}

final appViewProvider = StateProvider<AppView>((ref) => AppView.splash);
