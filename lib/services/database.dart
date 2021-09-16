import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/app/home/models/avatar_reference.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/app/home/models/user_profile.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Future<void> deleteJob(Job job);
  Stream<List<Job>> jobsStream();
  Stream<Job> jobStream({@required Job job});
  Future<void> setEntry(Entry entry);
  Future<void> deleteEntry(Entry entry);
  Stream<List<Entry>> entriesStream({Job job});
  Future<void> setUserProfile(UserProfile userProfile);
  Stream<UserProfile> userProfileStream({@required User user});
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> setUserProfile(UserProfile userProfile) => _service.setData(
      data: userProfile.toMap(),
      path: APIPath.userProfile(
        uid,
      ));
  @override
  Stream<UserProfile> userProfileStream({@required User user}) =>
      _service.documentStream(
          path: APIPath.userProfile(user.uid),
          builder: (data, documentId) => UserProfile.fromMap(data, documentId));

  @override
  Future<void> setJob(Job job) => _service.setData(
        path: APIPath.job(uid, job.id),
        data: job.toMap(),
      );

  @override
  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: APIPath.job(uid, job.id));
  }

  @override
  Stream<Job> jobStream({@required Job job}) => _service.documentStream(
      path: APIPath.job(uid, job.id),
      builder: (data, documentId) => Job.fromMap(data, documentId));

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Future<void> setEntry(Entry entry) => _service.setData(
        path: APIPath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> deleteEntry(Entry entry) => _service.deleteData(
        path: APIPath.entry(uid, entry.id),
      );

  @override
  Stream<List<Entry>> entriesStream({Job job}) =>
      _service.collectionStream<Entry>(
        path: APIPath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  // Reads the current avatar download url
  // Stream<AvatarReference> avatarReferenceStream() {
  //   final path = APIPath.avatar(uid);
  //   final reference = Firestore.instance.document(path);
  //   final snapshots = reference.snapshots();
  //   return snapshots.map((snapshot) => AvatarReference.fromMap(snapshot.data));
  // }
}
