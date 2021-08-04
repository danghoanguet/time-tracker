import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

class JobListTitle extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  JobListTitle({@required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
      ),
      child: ListTile(
        title: Text(job.name,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400)),
        subtitle: Text('rate per hour: ${job.ratePerHour}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
        onTap: onTap,
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }
}
