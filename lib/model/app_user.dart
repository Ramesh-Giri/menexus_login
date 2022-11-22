
class AppUser {
  late String fullName;
  late String emailAddress;
  late String uId;
  late String createdDate;

  AppUser({
    required this.fullName,
    required this.emailAddress,
    required this.uId,
    required this.createdDate,
  });

  static AppUser fromJson(Map<String, dynamic> data) {
    return AppUser(
      fullName: data['fullName'],
      emailAddress: data['emailAddress'],
      uId: data['uId'],
      createdDate: data['createdDate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fullName'] = fullName;
    data['emailAddress'] = emailAddress;
    data['uId'] = uId;
    data['createdDate'] = createdDate;
    return data;
  }
}
