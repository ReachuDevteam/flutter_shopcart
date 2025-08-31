import 'package:reachu_flutter_sdk/reachu_flutter_sdk.dart';

class SdkService {
  static final SdkService _instance = SdkService._internal();
  late final SdkClient sdk;

  factory SdkService() => _instance;

  SdkService._internal();

  void init({required String baseUrl, required String apiKey}) {
    sdk = SdkClient(baseUrl: baseUrl, apiKey: apiKey);
  }
}
