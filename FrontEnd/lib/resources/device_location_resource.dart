import 'package:sentinel_guard/constants/api_gateway.dart';
import 'package:sentinel_guard/models/devices/device_geolocation_model.dart';

import 'package:dio/dio.dart';


class DeviceLocationResource {
  final Dio _dio = Dio();

  Future<DeviceLocation> getDeviceLocation(int deviceId) async {
    var url = API_URL + '/device_geolocation/get/$deviceId';

    var response = await _dio.get(url);

    DeviceLocation deviceLocation = DeviceLocation.fromJson(response.data);

    return deviceLocation;
  }
}
