import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/utils.dart';

const String API_UUID = "API_UUID";
final String API_UUID_URL = "$API_BASE_URL/app-client/generate-uuid";

class DeviceInfo {
  final String model, osVersion;
  DeviceInfo(this.model, this.osVersion);
}

class DeviceInfoProvider {
  late SharedPreferences _prefs;
  late PackageInfo _packageInfo;
  late DeviceInfo _deviceInfo;
  late String _uuid;

  Future<String> getUuid() async {
    try {
      if(_uuid == null)
        _uuid = await _loadUuid();

      return _uuid;
    } catch (error) {
      throw error;
    }
  }

  Future<String> _loadUuid() async {
    if(_prefs == null)
      _prefs = await _loadSharedPreferences();

    try {
      return _prefs.getString(API_UUID) ?? await _generateUuid();
    } catch (error) {
      throw error;
    }
  }

  Future<SharedPreferences> _loadSharedPreferences() async {
    return await SharedPreferences.getInstance();
  }

  Future<String> _generateUuid() async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(API_UUID_URL);
      String uuid = json.decode(response.data)["uuid"];
      
      await _prefs.setString(API_UUID, uuid);
      return uuid;

    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<DeviceInfo> _getDeviceInfo() async {
    DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

    if(Platform.isAndroid) {
      AndroidDeviceInfo info = await _deviceInfoPlugin.androidInfo;
      return DeviceInfo(info.device, info.version.release);

    } else if (Platform.isIOS) {
      IosDeviceInfo info = await _deviceInfoPlugin.iosInfo;
      return DeviceInfo(info.utsname.machine, info.systemVersion);
    } else {
      return DeviceInfo("Undefined", "Undefined");
    }
  }

  Future<String> getDeviceDataAsParameters() async {
    if(_deviceInfo == null)
      _deviceInfo = await _getDeviceInfo();

    if(_packageInfo == null)
      _packageInfo = await PackageInfo.fromPlatform();

    var data = "platform=${Platform.isAndroid ? "Android" : "IOS"}" + "&" +
      "model=${_deviceInfo.model}" + "&" +
      "os_version=${_deviceInfo.osVersion}" + "&" +
      "app_version=${_packageInfo.version}" + "&" +
      "user_uuid=${await getUuid()}";

    print(data);

    return data;

    /*return {
      "Platform": Platform.isAndroid ? "Android" : "IOS",
      "Model": _deviceInfo.model,
      "OS Version": _deviceInfo.osVersion,
      "App-Version": "${_packageInfo.version} + ${_packageInfo.buildNumber}",
      "User-UUID": await getUuid(),
    };*/
  }
}