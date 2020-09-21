class UserModel {
  int id;
  String name;
  String email;
  String image;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      //This will be used to convert JSON objects that
      //are coming from querying the database and converting
      //it into a User object
      id: data['id']!=null?int.tryParse(data['id'].toString()):int.tryParse(data['ID'].toString()),
      name: data['user_nicename']!=null?data['user_nicename']:data['nicename'],
      email: data['user_email']!=null?data['user_email']:data['email'],
      image: data['image'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id':id,
        'nicename': name,
        'email': email,
        'image': image,
      };



  // from WooCommerce Json
  UserModel.fromJsonFB(Map<String, dynamic> json) {
    try {
      var user;
      if(json.containsKey("user"))
        user = json['user'];
      else
        user = json;


      id = json['wp_user_id'];
      name = user['name']??user['nicename'];
      name = user['user_login'];
      email = user["email"];
      image = user["picture"] != null &&
          user["picture"]["data"] != null &&
          user["picture"]['data']['url'] != null
          ? user["picture"]['data']['url']
          : '';

    } catch (e) {
      print(e.toString());
    }
  }
}
