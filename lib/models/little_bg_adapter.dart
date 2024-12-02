import 'package:hive/hive.dart';
import 'package:santaslist/models/little_bg.dart';

@HiveType(typeId: 0) // Assign a unique type ID
class LittleBGAdapter extends TypeAdapter<LittleBG> {
  @override
  final int typeId = 0; // Must match the typeId in @HiveType

  @override
  LittleBG read(BinaryReader reader) {
    final name = reader.read();
    final profilePhoto = reader.read();
    final age = reader.read();
    final genderIndex = reader.read(); // Read the enum value as its index

    Gender gender;
    switch (genderIndex) {
      case 0:
        gender = Gender.male;
        break;
      case 1:
        gender = Gender.female;
        break;
      case 2:
        gender = Gender.nonBinary;
        break;
      case 3:
        gender = Gender.unspecified;
        break;
      default:
        gender = Gender.unspecified; // Default to unspecified
    }

    return LittleBG(name, profilePhoto, age, gender);
  }

  @override
  void write(BinaryWriter writer, LittleBG obj) {
    writer.write(obj.name);
    writer.write(obj.profilePhoto);
    writer.write(obj.age);

    // Write the enum index
    switch (obj.gender) {
      case Gender.male:
        writer.write(0);
        break;
      case Gender.female:
        writer.write(1);
        break;
      case Gender.nonBinary:
        writer.write(2);
        break;
      case Gender.unspecified:
        writer.write(3);
        break;
      default:
        writer.write(3); // Default to unspecified
    }
  }
}
