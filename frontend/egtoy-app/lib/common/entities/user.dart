// 注册请求
class UserRegisterRequestEntity {
  String email;
  String password;

  UserRegisterRequestEntity({required this.email, required this.password});

  factory UserRegisterRequestEntity.fromJson(Map<String, dynamic> json) =>
      UserRegisterRequestEntity(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}

// 登录请求
class UserLoginRequestEntity {
  String email;
  String password;

  UserLoginRequestEntity({required this.email, required this.password});

  factory UserLoginRequestEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginRequestEntity(email: json["email"], password: json["password"]);

  Map<String, dynamic> toJson() => {"email": email, "password": password};
}

// 登录请求
class UserLoginWeb3RequestEntity {
  String address;

  UserLoginWeb3RequestEntity({required this.address});

  factory UserLoginWeb3RequestEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginWeb3RequestEntity(address: json["address"]);

  Map<String, dynamic> toJson() => {"address": address};
}

// 登录返回
class UserLoginResponseEntity {
  String? token;
  String? clientHash;
  int? expire;

  UserLoginResponseEntity({this.token, this.clientHash, this.expire});

  factory UserLoginResponseEntity.fromJson(Map<String, dynamic> json) =>
      UserLoginResponseEntity(
        token: json["token"],
        clientHash: json["clientHash"],
        expire: json["expire"],
      );

  Map<String, dynamic> toJson() => {
    "token": token,
    "clientHash": clientHash,
    "expire": expire,
  };
}
