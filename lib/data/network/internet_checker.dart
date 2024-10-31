import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkConnectivityAbs {
  Future<bool> get isConnected;
}

class NetworkConnectivity implements NetworkConnectivityAbs {
  final InternetConnectionChecker _internetChecker = InternetConnectionChecker();
  @override
  Future<bool> get isConnected => _internetChecker.hasConnection;
}
