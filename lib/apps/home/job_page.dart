import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_wigdet/custom_rasied_button.dart';
import 'package:time_tracker_flutter_course/common_wigdet/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class JobsPage extends StatefulWidget {
  @override
  _JobsPageState createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  bool isCreating = false;

  final TextEditingController _jobNameController = TextEditingController();
  final TextEditingController _jobDetailsController = TextEditingController();
  String get _jobName => _jobNameController.text;
  String get _jobDetails => _jobDetailsController.text;

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

  Future<void> _createJobs(BuildContext context) async {
    String jobName = _jobName;
    String jobDetail = _jobDetails;
    print('job name: $jobName \n job detials: $jobDetail');
    final database = Provider.of<Database>(context, listen: false);
    await database.creatJob({'name': jobName, 'time': jobDetail});
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
      body: isCreating ? buildContent() : Container(),
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
        onPressed: () => setState(() {
          isCreating = true;
        }),
      ),
    );
  }

  Widget buildContent() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          TextField(
            onChanged: (value) => setState(() {}),
            controller: _jobNameController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blueAccent,
                  ),
                ),
                labelText: 'Enter job name',
                labelStyle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                errorText: _jobName.isEmpty ? 'Job name can not be empty' : ""),
          ),
          TextField(
            onChanged: (value) => setState(() {}),
            controller: _jobDetailsController,
            decoration: InputDecoration(
                labelText: 'Enter details',
                labelStyle: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w600,
                ),
                errorText: _jobDetails.isEmpty ? 'Can not be empty' : ""),
          ),
          SizedBox(
            height: 20,
          ),
          CustomRasiedButton(
            child: Icon(Icons.add),
            color: Colors.indigo,
            onPressed: () => _createJobs(context),
          )
        ],
      ),
    );
  }
}

//  class buildAddContent extends StatelessWidget {
//   const buildAddContent({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Card(
//             child: Container(
//           padding: EdgeInsets.all(15),
//           height: 300,
//           width: double.infinity,
//           margin: EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(15),
//             border: Border.all(color: Colors.black),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextField(
//                 decoration: InputDecoration(
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.blueAccent,
//                       ),
//                     ),
//                     labelText: 'Enter job name',
//                     labelStyle: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     errorText: 'Job name can not be empty'),
//               ),
//               TextField(
//                 decoration: InputDecoration(
//                     labelText: 'Enter details',
//                     labelStyle: TextStyle(
//                       fontSize: 25,
//                       fontWeight: FontWeight.w600,
//                     ),
//                     errorText: 'Can not be empty'),
//               ),
//               CustomRasiedButton(
//                 child: Icon(Icons.add),
//                 color: Colors.indigo,
//                 onPressed: () async {
//                   final database =
//                       Provider.of<Database>(context, listen: false);
//                   await database
//                       .creatJob({'name': 'LearingFlutter', 'time': 'Evening'});
//                 },
//               )
//             ],
//           ),
//         )),
//       ),
//     );
//   }
// }
