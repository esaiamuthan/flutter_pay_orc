// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'flutter_pay_orc_platform_interface.dart';
import 'flutter_pay_orc_webview.dart';
import 'helper/config_memory_holder.dart';
import 'helper/preference_helper.dart';
import 'helper/flutter_pay_orc_environment.dart';

class FlutterPayOrc {
  final PreferencesHelper preferenceHelper;
  final ConfigMemoryHolder configMemoryHolder = ConfigMemoryHolder();

  Future<String?> getPlatformVersion() {
    return FlutterPayOrcPlatform.instance.getPlatformVersion();
  }

  FlutterPayOrc._({required this.preferenceHelper, required Environment envType}) {
    configMemoryHolder.envType = envType;
    // Define a map for environment types and their corresponding URLs
    final envUrls = {
      Environment.development: "https://sandbox.example.com",
      Environment.staging: "https://sandbox-stage.example.com",
      Environment.production: "https://api.example.com",
    };
    // Assign the URL or fallback to an empty string
    configMemoryHolder.paymentUrl = envUrls[envType] ?? "";
  }

  static FlutterPayOrc? _instance;

  /// Factory constructor for asynchronous initialization
  static Future<FlutterPayOrc> initialize({
    required String clientId,
    required String merchantId,
    required Environment environment,
  }) async {
    final preferences = await SharedPreferences.getInstance();
    final preferenceHelper = PreferencesHelper(preferences);
    preferenceHelper.clientId = clientId;
    preferenceHelper.merchantId = merchantId;
    _instance = FlutterPayOrc._(
      preferenceHelper: preferenceHelper,
      envType: environment,
    );
    return _instance!;
  }

  /// Retrieve the singleton instance
  static FlutterPayOrc get instance {
    if (_instance == null) {
      throw Exception('FlutterPayOrc is not initialized. Call initialize() first.');
    }
    return _instance!;
  }

  /// Sets the logged-in user identifier
  String? get userId => configMemoryHolder.userId;

  set userId(String? value) {
    configMemoryHolder.userId = value;
  }

  /// Sets the order id
  String? get orderId => configMemoryHolder.orderId;

  set orderId(String? value) {
    configMemoryHolder.orderId = value;
  }

  /// Sets the order id
  String? get checkOutId => configMemoryHolder.checkOutId;

  set checkOutId(String? value) {
    configMemoryHolder.checkOutId = value;
  }

  /// Returns the current merchant identifier (a random GUID assigned to the app running on the device)
  String getMerchantId() {
    return preferenceHelper.merchantId;
  }

  /// Sets the merchant Id
  void setMerchantId(String merchantId) {
    preferenceHelper.merchantId = merchantId;
  }

  /// Returns the current client identifier (a random GUID assigned to the app running on the device)
  String getClientId() {
    return preferenceHelper.clientId;
  }

  /// Sets the clientId
  void setClientId(String clientId) {
    preferenceHelper.clientId = clientId;
  }

  /// Clear preference data
  void clearData() {
    preferenceHelper.clear();
  }

  Widget startPayment({
    required BuildContext context,
    required double amount,
    required String currency,
    required Function(bool success, String? transactionId) onPaymentResult,
  }) {
    final paymentUrl = instance.configMemoryHolder.paymentUrl;
    return PayOrcWebView(
      paymentUrl: paymentUrl!,
      onPaymentResult: onPaymentResult,
    );
  }
}
