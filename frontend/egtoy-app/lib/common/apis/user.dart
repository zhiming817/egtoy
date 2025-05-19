import 'package:egtoy/common/entities/entities.dart';
import 'package:egtoy/common/utils/utils.dart';

/// 用户
class UserAPI {
  /// 登录
  static Future<UserLoginResponseEntity> login({
    UserLoginRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      '/user/login/v2',
      data: params?.toJson(),
    );
    print(response);
    return UserLoginResponseEntity.fromJson(response);
  }

  /// 注册
  static Future<UserLoginResponseEntity> register({
    UserRegisterRequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      '/user/register',
      data: params?.toJson(),
    );
    return UserLoginResponseEntity.fromJson(response);
  }

  static Future<UserLoginResponseEntity> web3Login({
    UserLoginWeb3RequestEntity? params,
  }) async {
    var response = await HttpUtil().post(
      '/user/loginWeb3',
      data: params?.toJson(),
    );
    print(response);
    return UserLoginResponseEntity.fromJson(response["data"]);
  }

  /// Profile
  static Future<UserLoginResponseEntity> profile() async {
    var response = await HttpUtil().post('/user/profile');
    return UserLoginResponseEntity.fromJson(response);
  }

  /// Logout
  static Future logout() async {
    return await HttpUtil().post('/user/logout');
  }
}
