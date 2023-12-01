import 'package:sentinel_guard/constants/api_gateway.dart';
import 'package:sentinel_guard/models/users/user_infos_model.dart';

import 'package:dio/dio.dart';

class UserInfoResource {
  final Dio _dio = Dio();

  Future<String> createUser(String userEmail, String senha) async {
    var url = API_URL + '/users/create';

    var response = await _dio.post(url,
        data: UserInfos(userEmail: userEmail, senha: senha, userPhoto: '')
            .toJson());

    return response.data.toString();
  }

  Future<UserInfos> getUser(String userEmail) async {
    var url = API_URL + '/users/infos/$userEmail';

    var response = await _dio.get(url);

    UserInfos userInfos = UserInfos.fromJson(response.data);

    return userInfos;
  }

  Future<String> loginUser(String userEmail, String senha) async {
    var url = API_URL + '/users/login';

    var response = await _dio.post(url, data: {
      'user_email': userEmail,
      'senha': senha,
    });

    return response.data.toString();
  }

  Future<String> updateUser(String userEmail, payload) async {
    var url = API_URL + '/users/update/$userEmail';

    final transformPayload = {};
    payload.forEach((key, value) {
      transformPayload[key] = value.toString();
    });

    var response = await _dio.put(url, data: transformPayload);

    return response.data.toString();
  }
}
