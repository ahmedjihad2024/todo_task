
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';

abstract class AbstractAppPreferences{
  Future<bool> setSkippedOnBoarding();
  Future<void> setAccessToken(String token);
  Future<void> setRefreshToken(String token);
  bool get isSkippedOnBoarding;
}

class AppPreferences implements AbstractAppPreferences{
  final SharedPreferences _sharedPreferences;
  const AppPreferences(this._sharedPreferences);

  @override
  Future<bool> setSkippedOnBoarding() async => await _sharedPreferences.setBool(Constants.skippedOnBoarding, true);

  @override
  bool get isSkippedOnBoarding => _sharedPreferences.getBool(Constants.skippedOnBoarding) ?? false;

  @override
  Future<void> setAccessToken(String token) async => await _sharedPreferences.setString(Constants.accessToken, token);

  @override
  Future<void> setRefreshToken(String token) async => await _sharedPreferences.setString(Constants.refreshToken, token);

}

