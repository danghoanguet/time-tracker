import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/account/edit_name_page.dart';
import 'package:time_tracker_flutter_course/app/home/models/avatar_reference.dart';
import 'package:time_tracker_flutter_course/app/home/models/user_profile.dart';
import 'package:time_tracker_flutter_course/common_wigdet/avatar.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_exception_alert_diaglog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';
import 'package:time_tracker_flutter_course/services/firebase_storage_service.dart';
import 'package:time_tracker_flutter_course/services/firestore_service.dart';
import 'package:time_tracker_flutter_course/common_wigdet/image_picker_service.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key key, this.database}) : super(key: key);

  final Database database;

  Future<void> _signOut(BuildContext context) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    try {
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Logout',
        content: 'You are about to sign out. Are you sure?',
        defaultActionText: 'Sign out',
        cancelActionText: 'Cancel');
    if (didRequestSignOut == true) {
      _signOut(context);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return StreamBuilder<User>(
        stream: auth.onUserChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return _buildContent(context, auth);
          } else {
            return Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          }
        });
  }

  Future<void> _chooseAvatar(BuildContext context, User user) async {
    try {
      bool imageType = await showAlertDialog(context,
          title: "Update profile image",
          content: "Please choose where you want to pick image",
          defaultActionText: "From libary",
          cancelActionText: "From camera");
      // 1. Get image from picker
      final imagePicker =
          Provider.of<ImagePickerService>(context, listen: false);
      final file = imageType
          ? await imagePicker.pickImage(source: ImageSource.gallery)
          : await imagePicker.pickImage(source: ImageSource.camera);
      if (file != null) {
        // 2. Upload to storage
        final storage =
            Provider.of<FirebaseStorageService>(context, listen: false);
        final downloadUrl = await storage.uploadAvatar(file: file);
        // 3. Save url to Firestore
        final database = Provider.of<Database>(context, listen: false);
        await database.setUserProfile(UserProfile(
            id: documentIdFromCurrentDate(),
            name: user.displayName == null
                ? user.uid.substring(0, 10)
                : user.displayName,
            photoUrl: downloadUrl));
        await user.updateProfile(photoURL: downloadUrl);
        // 4. (optional) delete local file as no longer needed
        await file.delete();
      } else
        return;
    } catch (e) {
      await showExceptionAlertDialog(context,
          title: "Somethings went wrong", exception: e);
    }
  }

  Widget _buildContent(BuildContext context, AuthBase auth) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Account',
        ),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () => _confirmSignOut(context),
          )
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: _buildUserInfo(context, auth.currentUser),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, User currentUser) {
    return Column(
      children: [
        Avatar(
          onTap: () => _chooseAvatar(context, currentUser),
          radius: 50,
          photoUrl: currentUser.photoURL,
        ),
        SizedBox(
          height: 8,
        ),
        _buildNameBox(context, currentUser),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget _buildNameBox(BuildContext context, User user) {
    // String _name =
    //     user.displayName == null ? user.uid.substring(0, 10) : user.displayName;
    // bool type = false;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
          ),
          Text(
            (user.displayName == null)
                ? user.uid.substring(0, 10)
                : user.displayName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          IconButton(
              onPressed: () => EditNamePage.show(context, user),
              icon: Icon(
                Icons.edit,
                size: 20,
                color: Colors.white,
              )),
        ],
      ),
    );
  }
}
