import 'package:flutter/material.dart';
import 'package:rent_lo_app/model/userDetailsModel.dart';
import 'package:rent_lo_app/ui/pages/myTenants.dart';
import 'package:rent_lo_app/res/detailsFirebase.dart';
import 'package:rent_lo_app/res/saveSharedPreference.dart';
import 'package:rent_lo_app/ui/widgets/validators.dart';

class EnterDetailsPage extends StatefulWidget {
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final String mail;

  EnterDetailsPage({
    this.phoneNumber,
    this.mail,
    this.firstName,
    this.lastName,
  });

  @override
  _EnterDetailsPageState createState() => _EnterDetailsPageState();
}

class _EnterDetailsPageState extends State<EnterDetailsPage> {
  TextEditingController _fullNameController = new TextEditingController();
  TextEditingController _phoneNumberController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _dobController = new TextEditingController();

  @override
  void initState() {
    setInitialValues();
    super.initState();
  }

  void setInitialValues() {
    _phoneNumberController.text = widget.phoneNumber;
    if (widget.firstName != null)
      _fullNameController.text = widget.firstName + " " + widget.lastName;
    if (widget.mail != null) _emailController.text = widget.mail;
  }

  double _screenHeight, _screenWidth;
  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: _screenWidth,
        height: _screenHeight,
        child: Stack(
          children: <Widget>[
            welcomeText(),
            Align(
              child: buildForm(),
              alignment: Alignment.bottomCenter,
            ),
          ],
        ),
      ),
    );
  }

  Widget welcomeText() {
    return Container(
      height: _screenHeight,
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 60),
      color: Color(0xFF5a20c7),
      child: Text(
        "Add Your Details",
        style: TextStyle(
          fontSize: 50.0,
          color: Colors.white,
          fontFamily: "LobsterTwo",
        ),
      ),
    );
  }

  void handleLogin() async {
    UserDetailsModel _detailsModel = UserDetailsModel(
        dob: _dobController.text,
        email: _emailController.text,
        name: _fullNameController.text,
        phoneNumber: _phoneNumberController.text);
    String docId =
        await DetailsFirebase().sendUserDetails(detailsModel: _detailsModel);
    if (docId != null) {
      SaveSharedPreference.saveUserId(docId);
      SaveSharedPreference.savePhoneNumber(_phoneNumberController.text);
      SaveSharedPreference.saveUserName(_fullNameController.text);
      SaveSharedPreference.saveUserEmail(_emailController.text);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyTenants(
            email: _emailController.text,
            name: _fullNameController.text,
            userId: docId,
          ),
        ),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();

  Widget buildForm() {
    return Container(
      height: _screenHeight * 0.7,
      width: _screenWidth,
      padding: EdgeInsets.only(left: 20.0, right: 20.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
          color: Colors.white),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            buildTextField(
                hint: "Full Name",
                controller: _fullNameController,
                type: TextInputType.text,
                enabled: true,
                validators: Validators.nameValidator),
            SizedBox(
              height: 30.0,
            ),
            buildTextField(
                hint: "Email Address",
                controller: _emailController,
                type: TextInputType.emailAddress,
                enabled: true,
                validators: Validators.emailValidator),
            SizedBox(
              height: 30.0,
            ),
            buildTextField(
                hint: "DD/MM/YYYY",
                controller: _dobController,
                type: TextInputType.datetime,
                enabled: true,
                validators: Validators.dateDateValidator),
            SizedBox(
              height: 30.0,
            ),
            buildTextField(
                hint: "Phone Number",
                controller: _phoneNumberController,
                type: TextInputType.number,
                enabled: false),
            SizedBox(
              height: 30.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              alignment: Alignment.centerRight,
              child: FloatingActionButton(
                backgroundColor: Color(0xFF5a20c7),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 30.0,
                ),
                onPressed: () {
                  if (_formKey.currentState.validate()) return handleLogin();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
      {String hint,
      TextEditingController controller,
      TextInputType type,
      bool enabled,
      validators}) {
    return Container(
      width: MediaQuery.of(context).size.width - 80,
      decoration: BoxDecoration(),
      child: TextFormField(
        validator: validators,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(
          fontSize: 20.0,
          fontFamily: "Josefin",
        ),
        enabled: enabled,
        keyboardType: type,
        controller: controller,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF1165C1), width: 2.0),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2.0),
          ),
          labelStyle: TextStyle(
            fontSize: 20.0,
            fontFamily: "Josefin",
          ),
          labelText: hint,
        ),
      ),
    );
  }
}
