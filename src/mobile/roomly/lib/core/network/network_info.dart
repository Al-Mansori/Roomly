import 'package:internet_connection_checker/internet_connection_checker.dart';

// Network Info Interface
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

// Network Info Implementation

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnectionChecker connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected => connectionChecker.hasConnection;
}

