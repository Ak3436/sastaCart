class UserProfileModel {

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String image;
  final String username;
  final int age;
  final String gender;
  final String university;
  final String bloodGroup;
  final String eyeColor;

  UserProfileModel({

    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.image,
    required this.username,
    required this.age,
    required this.gender,
    required this.university,
    required this.bloodGroup,
    required this.eyeColor,
  });

  factory UserProfileModel.fromJson(
      Map<String, dynamic> json) {

    return UserProfileModel(

      id: json['id'],

      firstName: json['firstName'],

      lastName: json['lastName'],

      email: json['email'],

      phone: json['phone'],

      image: json['image'],

      username: json['username'],

      age: json['age'],

      gender: json['gender'],

      university: json['university'],

      bloodGroup: json['bloodGroup'],

      eyeColor: json['eyeColor'],
    );
  }
}