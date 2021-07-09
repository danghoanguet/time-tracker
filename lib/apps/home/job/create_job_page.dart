import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/apps/home/models/job.dart';
import 'package:time_tracker_flutter_course/common_wigdet/custom_rasied_button.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_exception_alert_diaglog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class CreateJobPage extends StatefulWidget {
  const CreateJobPage({Key key, @required this.database}) : super(key: key);
  final Database database;

  static void show(BuildContext context) {
    // this context is from JobPage so it has Provider Database
    final database = Provider.of<Database>(context, listen: false);
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => CreateJobPage(database: database),
          fullscreenDialog: true),
    );
  }

  @override
  _CreateJobPageState createState() => _CreateJobPageState();
}

class _CreateJobPageState extends State<CreateJobPage> {
  // final TextEditingController _jobNameController = TextEditingController();
  // final TextEditingController _jobDetailsController = TextEditingController();
  // String get _jobName => _jobNameController.text;
  // String get _ratePerHour => _jobDetailsController.text;

  String _name;
  int _ratePerHour;

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

      await widget.database.creatJob(job);
      await showAlertDialog(context,
          title: 'Done',
          content: 'Create new job successful',
          defaultActionText: 'Ok');
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(context,
          title: 'Operation failed', exception: e);
    }
  }

  void _submit() {
    if (_validateAndSaveForm()) {
      final job = Job(name: _name, ratePerHour: _ratePerHour);
      _createJobs(job);
      // Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        title: Text("Create new job"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Enter job name'),
        validator: (value) => value.isEmpty ? 'Job name can\'t be empty' : null,
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        decoration: InputDecoration(labelText: 'Enter rate per hour'),
      )
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
