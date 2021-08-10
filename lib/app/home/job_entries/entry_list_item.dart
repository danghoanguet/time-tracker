import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/entry_list_item_model.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/format.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

class EntryListItem extends StatelessWidget {
  const EntryListItem({
    @required this.entry,
    @required this.job,
    @required this.onTap,
  });

  final Entry entry;
  final Job job;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: _buildContents(context),
            ),
            Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final format = Provider.of<Format>(context, listen: false);
    final entryListItemModel = new EntryListItemModel(
        context: context, entry: entry, job: job, format: format);
    // final format = Provider.of<Format>(context, listen: false);
    // final dayOfWeek = format.dayOfWeek(entry.start);
    // final startDate = format.date(entry.start);
    // final startTime = TimeOfDay.fromDateTime(entry.start).format(context);
    // final endTime = TimeOfDay.fromDateTime(entry.end).format(context);
    // final durationFormatted = format.hours(entry.durationInHours);
    // final pay = job.ratePerHour * entry.durationInHours;
    // final payFormatted = format.currency(pay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[
          Text(entryListItemModel.dayOfWeek,
              style: TextStyle(fontSize: 18.0, color: Colors.grey)),
          SizedBox(width: 15.0),
          Text(entryListItemModel.startDate, style: TextStyle(fontSize: 18.0)),
          if (job.ratePerHour > 0.0) ...<Widget>[
            Expanded(child: Container()),
            Text(
              entryListItemModel.payFormatted,
              style: TextStyle(fontSize: 16.0, color: Colors.green[700]),
            ),
          ],
        ]),
        Row(children: <Widget>[
          Text(
              '${entryListItemModel.startTime} - ${entryListItemModel.endTime}',
              style: TextStyle(fontSize: 16.0)),
          Expanded(child: Container()),
          Text(entryListItemModel.durationFormatted,
              style: TextStyle(fontSize: 16.0)),
        ]),
        if (entry.comment.isNotEmpty) ...<Widget>[
          Text(
            entry.comment,
            style: TextStyle(fontSize: 12.0),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ]
      ],
    );
  }
}

class DismissibleEntryListItem extends StatelessWidget {
  const DismissibleEntryListItem({
    this.key,
    this.entry,
    this.job,
    this.onDismissed,
    this.onTap,
  });

  final Key key;
  final Entry entry;
  final Job job;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: (direction) => onDismissed(),
      child: EntryListItem(
        entry: entry,
        job: job,
        onTap: onTap,
      ),
    );
  }
}
