import 'package:mongo_dart/mongo_dart.dart';

class MongoDbService {
  final String connectionString = "your-mongodb-connection-string";
  final String collectionName = "moments";

  late Db db;
  late DbCollection collection;

  // Connect to MongoDB
  Future<void> connect() async {
    db = await Db.create(connectionString);
    await db.open();
    collection = db.collection(collectionName);
    print("Connected to MongoDB");
  }

  // Fetch data from the moments collection
  Future<List<Map<String, dynamic>>> fetchMoments() async {
    final moments = await collection.find().toList();
    return moments;
  }

  // Close the MongoDB connection
  Future<void> close() async {
    await db.close();
  }
}
