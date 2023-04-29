import 'package:mongo_dart/mongo_dart.dart';

import 'constent.dart';

class readData {
  static Future<List<Map<String, dynamic>>> readAllDataFromCollection() async {
    var db = await Db.create(mongoUrl);
    await db.open();

    final collection = db.collection(collectionName);
    final cursor = await collection.find().toList();

    await db.close();

    return cursor;
  }
}
