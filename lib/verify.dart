// THIS IS FILE FOR IMPLEMENTING TRUE CALLER SIGN IN IN MOBILES WHICH DOESNT HAVE TRUE CALLER
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_truecaller/flutter_truecaller.dart';

// class VerifyMobileNumber extends StatefulWidget {
//   @override
//   _VerifyMobileNumberState createState() => _VerifyMobileNumberState();
// }

// class _VerifyMobileNumberState extends State<VerifyMobileNumber> {
//   final TextEditingController _mobile = TextEditingController();

//   final TextEditingController _firstName = TextEditingController();

//   final TextEditingController _lastName = TextEditingController();

//   final TextEditingController _otp = TextEditingController();

//   final FlutterTruecaller caller = FlutterTruecaller();

//   bool otpRequired = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Verify non truecaller'),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: _mobile,
//                 keyboardType: TextInputType.phone,
//                 decoration: InputDecoration(labelText: "Mobile"),
//               ),
//             ),
//             OutlineButton(
//               onPressed: () async {
//                 otpRequired = await caller.requestVerification(_mobile.text);
//                 print(otpRequired);
//                 setState(() {});
//               },
//               child: Text("Verify"),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: _firstName,
//                 decoration: InputDecoration(labelText: "First Name"),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextField(
//                 controller: _lastName,
//                 decoration: InputDecoration(labelText: "Last Name"),
//               ),
//             ),
//             if (otpRequired)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextField(
//                   controller: _otp,
//                   keyboardType: TextInputType.number,
//                   decoration: InputDecoration(labelText: "OTP"),
//                 ),
//               ),
//             OutlineButton(
//               onPressed: () async {
//                 // if (otpRequired)
//                 //   await caller.verifyOtp(
//                 //       _firstName.text, _lastName.text, _otp.text);
//                 // else {
//                 //   print('hey');
//                 //   await caller.verifyMissedCall(
//                 //       _firstName.text, _lastName.text);
//                 //   Navigator.of(context).pushReplacement(
//                 //       MaterialPageRoute(builder: (_) => Bottom()));
//                 // }
//                 // print('shivam');
//               },
//               child: Text("Submit"),
//             ),

// //Developer Point of View
//             StreamBuilder<String>(
//               stream: FlutterTruecaller.callback,
//               builder: (context, snapshot) => Text(snapshot.data ?? ''),
//             ),
//             StreamBuilder<FlutterTruecallerException>(
//               stream: FlutterTruecaller.errors,
//               builder: (context, snapshot) =>
//                   Text(snapshot.hasData ? snapshot.data.errorMessage : ''),
//             ),
//             StreamBuilder<TruecallerProfile>(
//               stream: FlutterTruecaller.trueProfile,
//               builder: (context, snapshot) => Text(snapshot.hasData
//                   ? snapshot.data.firstName + " " + snapshot.data.lastName
//                   : ''),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
