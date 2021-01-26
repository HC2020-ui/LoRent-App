import 'package:flutter/material.dart';
import 'package:rent_lo_app/model/tentantDetailsModel.dart';
import 'package:rent_lo_app/res/detailsFirebase.dart';
import 'package:rent_lo_app/ui/widgets/validators.dart';

class AddTenant extends StatefulWidget {
  final String userId;

  const AddTenant({this.userId});
  @override
  _AddTenantState createState() => _AddTenantState();
}

class _AddTenantState extends State<AddTenant> {
  TextEditingController _tname = new TextEditingController();
  TextEditingController _tmail = new TextEditingController();
  TextEditingController _tnum = new TextEditingController();
  TextEditingController _tamount = new TextEditingController();
  TextEditingController _tadhar = new TextEditingController();
  TextEditingController _due = new TextEditingController();
  TextEditingController _joined = new TextEditingController();
  TextEditingController _tjob = new TextEditingController();
  TextEditingController _taddress = new TextEditingController();

  void handleSendingData() {
    TenantDetailsModel _tenantDetailModel = TenantDetailsModel(
      name: _tname.text,
      aadharNumber: _tadhar.text,
      address: _taddress.text,
      amount: _tamount.text,
      dueDate: _due.text,
      email: _tmail.text,
      job: _tjob.text,
      joined: _joined.text,
      mobileNumber: _tnum.text,
    );
    DetailsFirebase().sendTenantsDetails(
        tenantDetailsModel: _tenantDetailModel, userId: widget.userId);
    handleClearForms();
  }

  void handleClearForms() {
    _tname.clear();
    _tmail.clear();
    _tnum.clear();
    _tamount.clear();
    _tadhar.clear();
    _due.clear();
    _joined.clear();
    _taddress.clear();
    _tjob.clear();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      alignment: Alignment.bottomRight,
      child: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF5a20c7),
        onPressed: () => buildForm(context),
      ),
    );
  }

  Future<Widget> buildForm(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0))),
      context: context,
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 35, bottom: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 75),
                      child: Text("Add Tenants",
                          style: TextStyle(
                              fontFamily: "LobsterTwo", fontSize: 31)),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                        handleClearForms();
                      },
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 31,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextFormField(
                          controller: _tname,
                          label: "Name *",
                          textInputType: TextInputType.name,
                          validators: Validators.nameValidator),
                      buildTextFormField(
                          controller: _tmail,
                          label: "Email *",
                          textInputType: TextInputType.emailAddress,
                          validators: Validators.emailValidator),
                      buildTextFormField(
                        controller: _tnum,
                        label: "Mobile number *",
                        textInputType: TextInputType.phone,
                        validators: Validators.phoneNumberValidator,
                      ),
                      buildTextFormField(
                          controller: _tamount,
                          label: "Amount *",
                          textInputType: TextInputType.number,
                          validators: Validators.rentValidator),
                      buildTextFormField(
                          controller: _joined,
                          label: "Joined date(DD/MM/YY) *",
                          textInputType: TextInputType.datetime,
                          validators: Validators.joinedDateValidator),
                      buildTextFormField(
                          controller: _tadhar,
                          label: "Aadhar number",
                          textInputType: TextInputType.number),
                      buildTextFormField(
                          controller: _due,
                          label: "Due date(DD/MM/YY) *",
                          textInputType: TextInputType.datetime),
                          
                      buildTextFormField(
                          controller: _taddress,
                          label: "Address",
                          textInputType: TextInputType.streetAddress),
                      buildTextFormField(
                          controller: _tjob,
                          label: "Occupation",
                          textInputType: TextInputType.streetAddress),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        handleSendingData();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text("Uploaded Sucessfuly"),
                          duration: Duration(seconds: 1),
                        ));
                        Navigator.pop(context);
                      } else
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text("Add Properly"),
                          duration: Duration(seconds: 1),
                        ));
                    },
                    child: Text("Add",
                        style: TextStyle(fontFamily: "Josefin", fontSize: 21)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField(
      {String label,
      TextInputType textInputType,
      TextEditingController controller,
      validators}) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: validators,
      autocorrect: true,
      enableSuggestions: true,
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: "Josefin",
        ),
      ),
    );
  }
}
