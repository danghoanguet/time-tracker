import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

import 'package:time_tracker_flutter_course/common_wigdet/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_exception_alert_diaglog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({
    Key key,
    @required this.database,
    this.job,
  }) : super(key: key);
  final Database database;
  final Job job;

  static void show(BuildContext context, Database database, Job job) {
    // this context is from JobPage so it has Provider Database
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditJobPage(database: database, job: job),
          fullscreenDialog: true),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  // final TextEditingController _jobNameController = TextEditingController();
  // final TextEditingController _jobDetailsController = TextEditingController();
  // String get _jobName => _jobNameController.text;
  // String get _ratePerHour => _jobDetailsController.text;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  String _name;
  int _ratePerHour;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      return true;
    }
    return false;
  }

  Future<void> _createJobs(Job job) async {
    try {
      // final database = Provider.of<Database>(context, listen: false);
      // this line is wrong since the context is from the CreateJobPage which is
      // child of Material widget and doesn't have Database provider above it

      await widget.database.setJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation failed', exception: e);
    }
  }

  void _submit() async {
    if (_validateAndSaveForm()) {
      setState(() {
        isLoading = true;
      });
      try {
        final jobs = await widget.database.jobsStream().first;
        final allJobNames = jobs.map((job) => job.name).toList();
        if (allJobNames.contains(_name) && widget.job == null) {
          await showAlertDialog(context,
              title: 'Name already used',
              content: 'Please choose a different name',
              defaultActionText: 'Ok');
          setState(() {
            isLoading = false;
          });
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(name: _name, ratePerHour: _ratePerHour, id: id);
          await _createJobs(job);
          await showAlertDialog(context,
              title: 'Done',
              content: widget.job == null
                  ? 'Create new job successful'
                  : 'Edit job successful',
              defaultActionText: 'Ok');

          Navigator.of(context)
              .pop(); // exit the edit_job_page back to job_entries_page
          // Navigator.of(context).pop(); // exit the job_entries_page back to job_page
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'Operation failed', exception: e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.job != null ? 'Edit Job' : "Create new job"),
        toolbarTextStyle: TextStyle(
            fontSize: 10,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
        elevation: 2.0,
        actions: [
          TextButton(
              onPressed: () => _submit(),
              child: Text(
                'Save',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ))
        ],
      ),
      body: !isLoading
          ? SingleChildScrollView(
              child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                  child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildForm(),
              )),
            ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildChildren(),
        ));
  }

  List<Widget> _buildChildren() {
    return [
      TextFormField(
        initialValue: _name,
        decoration: InputDecoration(
            labelText: 'Enter job name', labelStyle: TextStyle(fontSize: 30)),
        validator: (value) => value.isEmpty ? 'Job name can\'t be empty' : null,
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        initialValue: widget.job != null ? '$_ratePerHour' : '',
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        decoration: InputDecoration(
            labelText: 'Enter rate per hour',
            labelStyle: TextStyle(fontSize: 30)),
      ),
    ];
  }

  // Widget _buildContent() {
  //   return Card(
  //     child: Container(
  //     padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //     child: Column(
  //       children: [
  //         TextField(
  //           onChanged: (value) => setState(() {}),
  //           controller: _jobNameController,
  //           decoration: InputDecoration(
  //               enabledBorder: OutlineInputBorder(
  //                 borderSide: BorderSide(
  //                   color: Colors.blueAccent,
  //                 ),
  //               ),
  //               labelText: 'Enter job name',
  //               labelStyle: TextStyle(
  //                 fontSize: 25,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //               errorText: _jobName.isEmpty ? 'Job name can not be empty' : ""),
  //         ),
  //         TextField(
  //           onChanged: (value) => setState(() {}),

  //           controller: _jobDetailsController,
  //           keyboardType: TextInputType.number,
  //           inputFormatters: <TextInputFormatter>[
  //             FilteringTextInputFormatter.digitsOnly
  //           ], // Only numbers can be entered
  //           decoration: InputDecoration(
  //               hintText: '0',
  //               labelText: 'Enter rate per hour',
  //               labelStyle: TextStyle(
  //                 fontSize: 25,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //               errorText: _ratePerHour.isEmpty ? 'Can not be empty' : ""),
  //         ),
  //         SizedBox(
  //           height: 20,
  //         ),
  //         CustomRasiedButton(
  //           child: Icon(Icons.add),
  //           color: Colors.indigo,
  //           onPressed: () => _createJobs(context),
  //         )
  //       ],
  //     ),
  //   ));
  // }
}
