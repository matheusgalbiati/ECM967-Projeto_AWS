import 'package:sentinel_guard/constants/api_gateway.dart';
//import 'package:sentinel_guard/models/users/user_shared_devices_model.dart';

import 'package:dio/dio.dart';
import 'package:sentinel_guard/models/users/user_shared_devices_model.dart';

class UserSharedDeviceResource {
  final Dio _dio = Dio();

  Future<List<UserSharedDevices>> getUserSharedDevices(String userEmail) async {
    var url = API_URL + '/user_contacts/list/$userEmail';

    var response = await _dio.get(url);

    List userSharedDevices = response.data;

    return userSharedDevices
        .map((userSharedDevice) => UserSharedDevices.fromJson(userSharedDevice))
        .toList();

    // return response.data;
  }

  Future<String> updateUserSharedDevice(
      String userEmail, int deviceId, payload) async {
    var url = API_URL + '/user_contacts/update/$userEmail/$deviceId';

    final transformPayload = {};
    payload.forEach((key, value) {
      transformPayload[key] = value.toString();
    });

    var response = await _dio.put(url, data: transformPayload);

    return response.data;
  }
}
