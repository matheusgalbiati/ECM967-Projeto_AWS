import 'package:sentinel_guard/constants/api_gateway.dart';
import 'package:sentinel_guard/models/devices/device_infos_model.dart';

import 'package:dio/dio.dart';

class DeviceInfoResource {
  final Dio _dio = Dio();

  Future<String> registerDevice(int deviceId, String userEmail, String deviceNickname, int devicePhotoId) async {
    var url = API_URL + '/devices/create';

    var response = await _dio.post(url,
        data: DeviceInfos(deviceId: deviceId, userEmail: userEmail, deviceNickname: deviceNickname, devicePhotoId: devicePhotoId)
            .toJson());

    return response.data.toString();
  }

  Future<List<DeviceInfos>> getDevices(String userEmail) async {
    var url = API_URL + '/devices/list/$userEmail';

    var response = await _dio.get(url);

    List devicesInfos = response.data;

    return devicesInfos.map((device) => DeviceInfos.fromJson(device)).toList();
    
    //return response.data;
  }

  Future<String> removeDevice(int deviceId) async {
    var url = API_URL + '/devices/remove/$deviceId';

    var response = await _dio.delete(url);

    return response.data.toString();
  }

  Future<String> updateDevice(int deviceId, payload) async {
    var url = API_URL + '/devices/update/$deviceId';

    final transformPayload = {};
    payload.forEach((key, value) {
      transformPayload[key] = value.toString();
    });

    var response = await _dio.put(url, data: transformPayload);

    return response.data.toString();
  }
}
