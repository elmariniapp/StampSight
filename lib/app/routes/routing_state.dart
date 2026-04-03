import 'package:flutter/foundation.dart';

/// État de routage (ex. onboarding) pilotant les [redirect] de [GoRouter].
final class AppRoutingState extends ChangeNotifier {
  AppRoutingState._();
  static final AppRoutingState instance = AppRoutingState._();

  bool _onboardingComplete = false;
  bool get onboardingComplete => _onboardingComplete;

  set onboardingComplete(bool value) {
    if (_onboardingComplete == value) return;
    _onboardingComplete = value;
    notifyListeners();
  }
}
