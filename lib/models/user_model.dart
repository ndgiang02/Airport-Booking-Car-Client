class UserModel {
  UserModel({
    this.success,
    this.error,
    this.message,
    this.data,
  });

  String? success;
  dynamic error;
  String? message;
  User? data;


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    success: json["success"],
    error: json["error"],
    message: json["message"],
    data: User.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "error": error,
    "message": message,
    "data": data!.toJson(),
  };
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.loginType,
    this.statut,
    this.statutNic,
    this.tonotify,
    this.deviceId,
    this.fcmId,
    this.creer,
    this.updatedAt,
    this.modifier,
    this.resetPasswordOtp,
    this.resetPasswordOtpModifier,
    this.age,
    this.gender,
    this.deletedAt,
    this.createdAt,
    this.userCat,
    this.online,
    this.country,
    this.accesstoken,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  String? loginType;
  String? statut;
  dynamic statutNic;
  String? tonotify;
  dynamic deviceId;
  dynamic fcmId;

  DateTime? creer;
  DateTime? updatedAt;
  DateTime? modifier;
  dynamic resetPasswordOtp;
  dynamic resetPasswordOtpModifier;
  String? age;
  String? gender;
  dynamic deletedAt;
  dynamic createdAt;
  String? userCat;
  String? online;
  String? country;
  String? accesstoken;


  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["nom"] ?? '',
    email: json["email"],
    phone: json["phone"],
    loginType: json["login_type"],
    statut: json["statut"],
    statutNic: json["statut_nic"],
    tonotify: json["tonotify"],
    deviceId: json["device_id"],
    fcmId: json["fcm_id"],
    creer: DateTime.parse(json["creer"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    modifier: DateTime.parse(json["modifier"]),
    resetPasswordOtp: json["reset_password_otp"],
    resetPasswordOtpModifier: json["reset_password_otp_modifier"],
    age: json["age"],
    gender: json["gender"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"],
    userCat: json["user_cat"],
    online: json["online"],
    country: json["country"],
    accesstoken: json["accesstoken"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "login_type": loginType,
    "statut": statut,
    "statut_nic": statutNic,
    "tonotify": tonotify,
    "device_id": deviceId,
    "fcm_id": fcmId,
    "creer": creer!.toIso8601String(),
    "updated_at": updatedAt!.toIso8601String(),
    "modifier": modifier!.toIso8601String(),
    "reset_password_otp": resetPasswordOtp,
    "reset_password_otp_modifier": resetPasswordOtpModifier,
    "age": age,
    "gender": gender,
    "deleted_at": deletedAt,
    "created_at": createdAt,
    "user_cat": userCat,
    "online": online,
    "country": country,
    "accesstoken": accesstoken,
  };
}
