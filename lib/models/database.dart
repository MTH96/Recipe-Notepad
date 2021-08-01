import 'package:firebase_database/firebase_database.dart';

class MyDatabase {
  final _databaseRef = FirebaseDatabase.instance.reference();

  Future<String> addItem(String path, dynamic item) async {
    try {
      final databaseSnapshot = await readitems(path);
      if ((databaseSnapshot.value as Map<String, dynamic>).containsValue(item))
        return null;
      final itemId = _databaseRef.child('$path/').push();
      await itemId.set(item);
      return itemId.toString();
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> readitems(String path) async {
    try {
      final databaseSnapshot = await _databaseRef.child('$path/').once();
      return databaseSnapshot.value;
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateItem(DatabaseReference itemId, dynamic newItem) async {
    try {
      await itemId.update(newItem);
      return itemId.toString();
    } catch (e) {
      throw e;
    }
  }
}
