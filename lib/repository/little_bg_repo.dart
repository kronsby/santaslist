import 'package:hive_flutter/hive_flutter.dart';
import 'package:santaslist/models/little_bg.dart';

class LittleBgRepository {
  late Box<LittleBG> _littleBGBox;

  Future<void> init() async {
    _littleBGBox = await Hive.openBox<LittleBG>('littleBGBox');
  }

  Future<void> addLittleBG(LittleBG littleBG) async {
    await _littleBGBox.add(littleBG);
  }

  LittleBG? getLittleBG(int index) {
    return _littleBGBox.getAt(index);
  }

  List<LittleBG> getAllLittleBGs() {
    return _littleBGBox.values.toList();
  }
}
