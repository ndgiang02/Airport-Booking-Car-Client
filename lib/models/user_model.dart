// user_model.dart

class UserModel {
  UserModel({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  UserData? data;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'] as bool?,
      message: json['message']?.toString(),
      data: json['data'] != null ? UserData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': data?.toJson(),
  };
}

class UserData {
  UserData({
    this.user,
    this.token,
  });

  User? user;
  String? token;

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'user': user?.toJson(),
    'token': token,
  };
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.mobile,
    this.userType,
    this.status,
    this.token,
  });

  int? id;
  String? name;
  String? email;
  String? mobile;
  String? userType;
  String? status;
  String? token;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      mobile: json['mobile']?.toString(),
      userType: json['user_type']?.toString(),
      status: json['status']?.toString(),
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'mobile': mobile,
    'user_type': userType,
    'status': status,
    'token': token,
  };
}
