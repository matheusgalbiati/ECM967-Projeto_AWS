import 'package:sentinel_guard/constants/api_gateway.dart';

import 'package:dio/dio.dart';

class HomeContactPreferenceResource {
  final Dio _dio = Dio();

  Future<String> _updateHomeContactPreference(String userEmail, int deviceId, payload) async {
    var url = API_URL + '/user_contacts/home_contact/$userEmail/$deviceId';

    var response = await _dio.post(url, data: payload);

    return response.data;
  }

  Future<String> setHomeContactPreferenceToPrimary(String userEmail, int deviceId) async {
    final payload = {'preference': 1};

    return await _updateHomeContactPreference(userEmail, deviceId, payload);
  }

  Future<String> setHomeContactPreferenceToSecondary(String userEmail, int deviceId) async {
    final payload = {'preference': 2};

    return await _updateHomeContactPreference(userEmail, deviceId, payload);
  }
}
