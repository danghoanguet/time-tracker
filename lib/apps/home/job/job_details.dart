import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class JobPageDetails extends StatelessWidget {
  final String jobName;

  static void show(BuildContext context, String jobName) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => JobPageDetails(jobName: jobName),
          fullscreenDialog: true),
    );
  }

  const JobPageDetails({Key key, this.jobName}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(jobName),
        actions: <Widget>[
          ElevatedButton(
            child: Text(
              'Edit',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () => print('editing'),
          )
        ],
      ),
      body: _buildContent(),
      floatingActionButton:
          FloatingActionButton(child: Icon(Icons.add), onPressed: () => {}),
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
