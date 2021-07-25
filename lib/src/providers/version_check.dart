import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

import '../api/api_repository.dart';

enum Version {
  Major,
  Minor,
  Patch
}

class AppVersionCheck with ChangeNotifier {
  final _apiRepository = ApiRepository();
  late PackageInfo _packageInfo;
  late Map<Version, int> _currentVersion;
  late Map<Version, int> _latestVersion;
  late bool _isLoading;

  AppVersionCheck() {
    _isLoading = false;
  }

  Future<void> checkForUpdates() async {
    if(_isLoading) return;
    _isLoading = true;

    if(_packageInfo == null)
      _packageInfo = await PackageInfo.fromPlatform();

    var ver = _packageInfo.version.split(".");

    _currentVersion = {
      Version.Major: int.parse(ver[0]),
      Version.Minor: int.parse(ver[1]),
      Version.Patch: int.parse(ver[2]),
    };

    try {
      final latest = await _apiRepository.fetchLatestVersion();

      _latestVersion = {
        Version.Major: latest["major"],
        Version.Minor: latest["minor"],
        Version.Patch: latest["patch"]
      };

    } catch (error) {
      print(error);

    }

    print("Current Version: $_currentVersion | Latest Version: $_latestVersion");

    _isLoading = false;

    notifyListeners();
  }

  bool get hasUpdate {
    if(_currentVersion == null || _latestVersion == null) return false;

    var latestMajor = _latestVersion[Version.Major];
    var latestMinor = _latestVersion[Version.Minor];
    var latestPatch = _latestVersion[Version.Patch];

    var currentMajor = _currentVersion[Version.Major];
    var currentMinor = _currentVersion[Version.Minor];
    var currentPatch = _currentVersion[Version.Patch];

    if(latestMajor! > currentMajor!) {
      return true;

    } else if(latestMajor == currentMajor) {
      if(latestMinor! > currentMinor!) {
        return true;

      } else if(latestMinor == currentMinor) {
        if(latestPatch! > currentPatch!)
          return true;

      }
    }

    return false;
  }

}