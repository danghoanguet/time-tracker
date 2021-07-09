import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/apps/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

abstract class Database {
  Future<void> creatJob(Job job);
  Stream<List<Job>> jobStream();
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;
  final _service = FireStoreService.instance;

  @override
  Future<void> creatJob(Job job) async => _service.setData(
        path: APIPath.job(uid, documentIdFromCurrentDate()),
        data: job.toMap(),
      );

  @override
  Stream<List<Job>> jobStream() => _service.collectionStream(
      path: APIPath.jobs(uid), builder: (data) => Job.fromMap(data));
}
