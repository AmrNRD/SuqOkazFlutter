class UserModel {
  String name;
  String email;
  String token;
  String emailVerifiedAt;
  String image;

  UserModel({
    this.name,
    this.email,
    this.token,
    this.emailVerifiedAt,
    this.image,

  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      //This will be used to convert JSON objects that
      //are coming from querying the database and converting
      //it into a User object
      name: data['name'],
      email: data['email'],
      image: data['image'].toString(),
      emailVerifiedAt: data['email_verified_at']
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'token': token,
        'image': image,
        'email_verified_at': emailVerifiedAt
      };

}
