import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/job/edit_job_page.dart';
import 'package:time_tracker_flutter_course/app/home/job/empty_content.dart';

import 'package:time_tracker_flutter_course/app/home/job/job_list_title.dart';
import 'package:time_tracker_flutter_course/app/home/job/list_items_builder.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

import 'package:time_tracker_flutter_course/common_wigdet/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_exception_alert_diaglog.dart';

import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class JobsPage extends StatefulWidget {
  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
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

  Future<void> deleteData(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation failed', exception: e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobs',
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
      ),
      body: _buildContent(context),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Jobs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Entries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Profile',
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => EditJobPage.show(
            context, Provider.of<Database>(context, listen: false), null),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          return ListItemBuilder<Job>(
              snapshot: snapshot,
              itemBuilder: (context, job) => Dismissible(
                    key: Key('job-${job.id}'), // this key must be unique
                    background: Container(
                      color: Colors.redAccent,
                    ),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) => deleteData(context, job),
                    child: JobListTitle(
                      job: job,
                      onTap: () => JobEntriesPage.show(context, job),
                    ),
                  ));

          // return ListView.builder(
          //   itemCount: children.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return GestureDetector(
          //       onTap: () =>
          //           JobPageDetails.show(context, children[index].data),
          //       child: Container(
          //         padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          //         decoration: BoxDecoration(
          //           border: Border(
          //               bottom: BorderSide(color: Colors.black87, width: 1)),
          //         ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text(
          //               '${children[index].data}',
          //               style: TextStyle(
          //                   fontWeight: FontWeight.w600, fontSize: 20),
          //             ),
          //             Icon(
          //               Icons.arrow_right_alt,
          //               size: 25,
          //             ),
          //           ],
          //         ),
          //       ),
          //     );
          //   },
          // );
        });
  }
}
