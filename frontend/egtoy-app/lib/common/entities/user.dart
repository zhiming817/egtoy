// 注册请求
class UserRegisterRequestEntity {
  String username;
  String password;
  String captcha;
  String captchaId;

  UserRegisterRequestEntity({
    required this.username,
    required this.password,
    required this.captcha,
    required this.captchaId,
  });

  factory UserRegisterRequestEntity.fromJson(Map<String, dynamic> json) {
    // 添加检查以确保关键字段存在且不为null
    if (json["username"] == null ||
        json["password"] == null ||
        json["captcha"] == null ||
        json["captchaId"] == null) {
      throw FormatException(
        "One or more required fields (username, password, captcha, captchaId) are missing or null in the JSON data for UserRegisterRequestEntity.",
      );
    }
    return UserRegisterRequestEntity(
      username: json["username"] as String,
      password: json["password"] as String,
      captcha: json["captcha"] as String,
      captchaId: json["captchaId"] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "captcha": captcha,
    "captchaId": captchaId,
  };
}

// 登录请求
class UserLoginRequestEntity {
  String username;
  String password;
  String captcha;
  String captchaId;

  UserLoginRequestEntity({
    required this.username,
    required this.password,
    required this.captcha,
    required this.captchaId,
  });

  factory UserLoginRequestEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginRequestEntity(
        username: json["username"],
        password: json["password"],
        captcha: json["captcha"],
        captchaId: json["captchaId"],
      );

  Map<String, dynamic> toJson() => {
    "username": username,
    "password": password,
    "captcha": captcha,
    "captchaId": captchaId,
  };
}

// 登录请求
class UserLoginWeb3RequestEntity {
  String address;

  UserLoginWeb3RequestEntity({required this.address});

  factory UserLoginWeb3RequestEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginWeb3RequestEntity(address: json["address"]);

  Map<String, dynamic> toJson() => {"address": address};
}

//  {code: 500, msg: 验证码错误，请重新获取, data: null}
class UserLoginResponseEntity {
  int? code;
  String? msg;
  UserLoginResponseDataEntity? data;

  UserLoginResponseEntity({this.code, this.msg, this.data});

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseEntity(
        code: json["code"],
        msg: json["msg"],
        data:
            json["data"] != null
                ? UserLoginResponseDataEntity.fromJson(json["data"])
                : null,
      );

  Map<String, dynamic> toJson() => {
    "code": code,
    "msg": msg,
    "data": data?.toJson(),
  };
}

// 登录返回
class UserLoginResponseDataEntity {
  String? token;
  String? clientHash;
  int? expire;
  String? avatar;

  UserLoginResponseDataEntity({
    this.token,
    this.clientHash,
    this.expire,
    this.avatar,
  });

  factory UserLoginResponseDataEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseDataEntity(
        token: json["token"],
        clientHash: json["clientHash"],
        expire: json["expire"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
    "token": token,
    "clientHash": clientHash,
    "expire": expire,
    "avatar": avatar,
  };
}
