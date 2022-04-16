import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/format.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

class EntryListItemModel {
  final Entry entry;
  final Job job;
  final Format format;
  final BuildContext context;

  EntryListItemModel({
    @required this.entry,
    @required this.job,
    @required this.format,
    @required this.context,
  });

  String get dayOfWeek => format.dayOfWeek(entry.start);
  String get startDate => format.date(entry.start);
  String get startTime => TimeOfDay.fromDateTime(entry.start).format(context);
  String get endTime => TimeOfDay.fromDateTime(entry.end).format(context);
  String get durationFormatted => format.hours(entry.durationInHours);

  double get pay => job.ratePerHour * entry.durationInHours;
  String get payFormatted => format.currency(pay);
}
