import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/apps/home/job/edit_job_page.dart';
import 'package:time_tracker_flutter_course/apps/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class JobPageDetails extends StatelessWidget {
  const JobPageDetails({Key key, this.job, this.database}) : super(key: key);

  final Job job;
  final Database database;

  static void show(BuildContext context, Job job) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => JobPageDetails(job: job),
          fullscreenDialog: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(job.name),
        actions: <Widget>[
          ElevatedButton(
              child: Text(
                'Edit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              onPressed: () => EditJobPage.show(context, job))
        ],
      ),
      body: _buildContent(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () => print('add new entry')),
    );
  }

  void editJob() {}

  Widget _buildContent() {
    return Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 250,
            ),
            Text(
              'Nothing Here',
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
            Text(
              'Add a new item to get started.',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
