import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditNamePage extends StatefulWidget {
  final User user;

  const EditNamePage({Key key, @required this.user}) : super(key: key);

  static void show(BuildContext context, User user) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
          builder: (context) => EditNamePage(user: user),
          fullscreenDialog: false),
    );
  }

  @override
  _EditNamePageState createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {
  final _formKey = GlobalKey<FormState>();
  String name;

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();

      return true;
    }
    return false;
  }

  void _onSave() {
    _validateAndSaveForm();
    print(name);
    widget.user.updateDisplayName(name);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: widget.user == null
            ? Text(widget.user.displayName)
            : Text("Edit name"),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      height: 200,
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20, 80, 20, 20),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 10.0,
              offset: Offset(2.0, 3.0),
            )
          ]),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildTextFormField(),
        SizedBox(
          height: 50,
        ),
        Container(
          height: 50,
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              color: Colors.indigo),
          child: TextButton(
            onPressed: () => _onSave(),
            child: Text(
              "Save name",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildTextFormField() {
    return Form(
      key: _formKey,
      child: TextFormField(
        initialValue: widget.user.displayName,
        decoration: InputDecoration(
            labelText: "Enter your new name",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.indigo, width: 3.0),
              borderRadius: BorderRadius.circular(25),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueGrey, width: 3.0),
            ),
            contentPadding: EdgeInsets.all(20)),
        onSaved: (value) => name = value,
      ),
    );
  }
}
