class UserModel {
  UserModel({
    this.status,
    this.error,
    this.message,
    this.data,
  });

  bool? status;
  String? error;
  String? message;
  User? data;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json['status'] as bool?,
      error: json['error']?.toString(),
      message: json['message']?.toString(),
      data: json['data'] != null ? User.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'error': error,
    'message': message,
    'data': data?.toJson(),
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
