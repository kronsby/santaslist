enum Gender {
  male,
  female,
  nonBinary,
  unspecified
}

class LittleBG {
  String name;
  String profilePhoto;
  int age;
  Gender? gender;

  LittleBG(this.name, this.profilePhoto, this.age, this.gender);

  String getName() {
    return name;
  }

  String getProfilePhoto() {
    return profilePhoto;
  }

  int getAge() {
    return age;
  }

  Gender? getGender() {
    return gender;
  }
}