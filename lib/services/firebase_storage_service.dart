import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:time_tracker_flutter_course/services/api_path.dart';

class FirebaseStorageService {
  FirebaseStorageService({@required this.uid}) : assert(uid != null);
  final String uid;

  /// Upload an avatar from file
  Future<String> uploadAvatar({
    @required File file,
  }) async =>
      await upload(
        file: file,
        path: APIPath.avatar(uid) + '/avatar.png',
        contentType: 'image/png',
      );

  /// Generic file upload for any [path] and [contentType]
  Future<String> upload({
    @required File file,
    @required String path,
    @required String contentType,
  }) async {
    print('uploading to: $path');
    final storageReference = FirebaseStorage.instance.ref().child(path);
    final uploadTask = storageReference.putFile(
        file, SettableMetadata(contentType: contentType));

    final snapshot = await uploadTask.then((value) => value,
        onError: (err) => {
              print('upload error code: $err'),
              throw err,
            });
    //  final snapshot = await uploadTask.whenComplete(() => {});

    // if (snapshot.error != null) {
    //   print('upload error code: ${snapshot.error}');
    //   throw snapshot.error;
    // }

    // Url used to download file/image
    final downloadUrl = await snapshot.ref.getDownloadURL();
    print('downloadUrl: $downloadUrl');
    return downloadUrl;
  }
}
