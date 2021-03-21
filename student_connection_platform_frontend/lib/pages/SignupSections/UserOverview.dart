import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/*

Defines the layout for the sign up page for the app

Various states:
  - AccountDetails: Holds fields for the email, password, and password confirmation
  - UserOverview: Pick a username, add a profile picture, short bio
  - UserDetails: Add interests, hobbies, major, etc (check 3/4 doc for full list)

One option:
- Make each section its own stateful widget (in own file) and simply pick which one 
  to include in this widget (keep a counter that decides which to show, show that)
- Will need to be able to pass information back to signup (input information)
- Need forward and backward buttons to move to next or previous signup page (if possible)
    - Validate current page form data before moving, then send back to hold on
    - Need to pass in defaults from this signup widget to whatever section is shown
- If we back while on first section, simply pop this signup widget off and quit

*/

// Once finished on signup:
// Navigator.pop(context) - pop the current page off the Navigator stack
// Navigator.pushNamed(context, '/ContentFrame');

String _appName;

class UserOverview extends StatefulWidget {
  UserOverview(String appName) {
    _appName = appName;
  }

  @override
  _UserOverviewState createState() => _UserOverviewState();
}

class _UserOverviewState extends State<UserOverview> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _username = "";
  bool _takenUsername = false;

  String _bio = "";
  File _profilePicturePath;
  AssetImage _profilePicture = AssetImage('assets/images/choosePicture.png');
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _profilePicturePath = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Username, profile picture, short bio

      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image(
                        image: _profilePicture,
                        fit: BoxFit.fill,
                        width: 100,
                        height: 100,
                      ),
                    )),
                SizedBox(width: 15),
                ConstrainedBox(
                  constraints: BoxConstraints.tightFor(width: 200, height: 50),
                  child: ElevatedButton(
                    child: Text('Choose Profile Picture'),
                    style: ElevatedButton.styleFrom(
                        primary: Color.fromRGBO(0, 194, 155, 1),
                        textStyle:
                            TextStyle(fontSize: 12, color: Colors.white)),
                    onPressed: getImage,
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Container(
              width: 400,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('  Create Your Username!  ',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15)),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty || value.length < 3)
                        return 'Usernames must be at least 3 characters';

                      //Validate against existing usernames, return failure if username already exists
                      //_takenUsername

                      //TODO: Check against database for existing usernames
                      return null;
                    },
                    textAlign: TextAlign.start,
                    maxLength: 20,
                    decoration: InputDecoration(
                        filled: true,
                        hintText: 'This doesn\'t have to be your real name.'),
                    onChanged: (value) {
                      _username = value;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 400,
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('  Tell everyone a bit about yourself!  ',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15)),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty || value.length < 40)
                        return 'Please include at least 40 characters in your bio.';

                      //TODO: Check against database for existing usernames
                      return null;
                    },
                    textAlign: TextAlign.start,
                    maxLength: 200,
                    minLines: 5,
                    maxLines: 5,
                    decoration: InputDecoration(
                        filled: true,
                        hintText:
                            'Write anything you want! What makes you who you are?'),
                    onChanged: (value) {
                      _bio = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
