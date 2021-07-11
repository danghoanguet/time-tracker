import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/apps/home/models/job.dart';

class JobListTitle extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;

  JobListTitle({@required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      onTap: onTap,
      trailing: Icon(Icons.chevron_right),
    );
  }
}
