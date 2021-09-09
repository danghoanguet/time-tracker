import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/home/entries/entry_job.dart';

/// Temporary model class to store the time tracked and pay for a job
class JobDetails {
  JobDetails({
    @required this.name,
    @required this.durationInHours,
    @required this.pay,
  });
  final String name;
  double durationInHours;
  double pay;
}

/// Groups together all jobs/entries on a given day
/// Trong 1 list các entry của 1 Date, ta lọc ra tất cả các entry của cùng 1 job,
/// sau đó tạo ra 1 list các jobdetails, mà trong đó
/// mỗi jobdetails sẽ có payment và duration của các entry của job đó
class DailyJobsDetails {
  DailyJobsDetails({@required this.date, @required this.jobsDetails});
  final DateTime date;
  final List<JobDetails> jobsDetails;

  // get sum of all job's payment
  double get pay => jobsDetails
      .map((jobDuration) => jobDuration
          .pay) // after this line we will have a list of double which is job.payment
      .reduce((value, element) =>
          value + element); // Sum all the payment of the job

  // get sum of all job's duration
  double get duration => jobsDetails
      .map((jobDuration) => jobDuration.durationInHours)
      .reduce((value, element) => value + element);

  /// splits all entries into separate groups by date
  /// we will have a map which each EntryJob is grouped by a DateTime of the Entry
  static Map<DateTime, List<EntryJob>> _entriesByDate(List<EntryJob> entries) {
    Map<DateTime, List<EntryJob>> map = {};
    for (var entryJob in entries) {
      final entryDayStart = DateTime(entryJob.entry.start.year,
          entryJob.entry.start.month, entryJob.entry.start.day);
      if (map[entryDayStart] == null) {
        map[entryDayStart] = [entryJob];
      } else {
        map[entryDayStart].add(entryJob);
      }
    }
    return map;
  }

  /// maps an unordered list of EntryJob into a list of DailyJobsDetails with date information
  static List<DailyJobsDetails> all(List<EntryJob> entries) {
    final byDate = _entriesByDate(
        entries); // a map which each EntryJob is grouped by a Date of the Entry
    List<DailyJobsDetails> list = [];
    for (var date in byDate.keys) {
      // a list of EntryJob has same Date // t có 1 list các entry có cùng date
      final entriesByDate = byDate[date];
      // ta thu được 1 list các job trong đó các job được tổng hợp tất cả pay và duration của các entry của nó
      final byJob = _jobsDetails(
          entriesByDate); // a list of JobDetails which contain Jobs with total payment and duration
      // ta sẽ thu được danh sách các DailyJobsDetails, mỗi DailyJobsDetails có date
      // và danh sách các job trong date đó, trong đó các job
      // đã được tổng hợp payment và duration của các entry của nó.
      list.add(DailyJobsDetails(date: date, jobsDetails: byJob));
    }
    return list.toList();
  }

  /// groups entries by job
  /// Gộp tất cả các entry có cùng job.id thành 1 Job có tổng pay và duration của tất cả các entry đó
  /// Ta sẽ thu được 1 danh sách các job trong đó mỗi job đã tổng hợp tổng payment và duration của các entry
  /// We will have a List of JobDetails has total pay and duration of the job
  static List<JobDetails> _jobsDetails(List<EntryJob> entries) {
    Map<String, JobDetails> jobDuration = {};
    for (var entryJob in entries) {
      final entry = entryJob.entry;
      final pay = entry.durationInHours * entryJob.job.ratePerHour;
      // with each job.id in EntryJob, we create a JobDetails
      if (jobDuration[entry.jobId] == null) {
        jobDuration[entry.jobId] = JobDetails(
          name: entryJob.job.name,
          durationInHours: entry.durationInHours,
          pay: pay,
        );
        //then we sum the total pay and duration of EntryJob has same job.id
      } else {
        jobDuration[entry.jobId].pay += pay;
        jobDuration[entry.jobId].durationInHours += entry.durationInHours;
      }
    }
    return jobDuration.values.toList();
  }
}
