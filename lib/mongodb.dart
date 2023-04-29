import 'package:mongo_dart/mongo_dart.dart';
import 'package:weather/constent.dart';
import 'package:weather/model.dart';

class MongoDatabase {
  static connect(List<WeatherList> data) async {
    var db = await Db.create(mongoUrl);
    await db.open();

    var collection = db.collection(collectionName);

    var result = await collection.find().toList();
    if (result.isEmpty) {
      await collection
          .insertAll(data.map((weather) => weather.toJson()).toList());
    }
  }
}
