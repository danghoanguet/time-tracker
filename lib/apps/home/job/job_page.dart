import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/apps/home/job/create_job_page.dart';
import 'package:time_tracker_flutter_course/apps/home/models/job.dart';

import 'package:time_tracker_flutter_course/common_wigdet/show_alert_dialog.dart';

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
        onPressed: () => CreateJobPage.show(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
        stream: database.jobStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Some error occurs'),
            );
          }
          if (snapshot.hasData) {
            final jobs = snapshot.data;
            final children = jobs.map((job) => Text(job.name)).toList();
            return ListView.builder(
              itemCount: children.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => print(children[index].data),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.black87, width: 1)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${children[index].data}',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20),
                        ),
                        Icon(
                          Icons.arrow_right_alt,
                          size: 25,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
