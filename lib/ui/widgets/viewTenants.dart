import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rent_lo_app/model/tentantDetailsModel.dart';
import 'package:rent_lo_app/res/detailsFirebase.dart';
import 'package:rent_lo_app/ui/widgets/validators.dart';
import 'package:share/share.dart';

class ViewTenants extends StatefulWidget {
  final String userId;

  const ViewTenants({this.userId});
  @override
  _ViewTenantsState createState() => _ViewTenantsState();
}

class _ViewTenantsState extends State<ViewTenants> {
  TextEditingController _tname = new TextEditingController();
  TextEditingController _tmail = new TextEditingController();
  TextEditingController _tnum = new TextEditingController();
  TextEditingController _tamount = new TextEditingController();
  TextEditingController _tadhar = new TextEditingController();
  TextEditingController _due = new TextEditingController();
  TextEditingController _joined = new TextEditingController();
  TextEditingController _tjob = new TextEditingController();
  TextEditingController _taddress = new TextEditingController();

  @override
  void dispose() {
    _tname.dispose();
    _due.dispose();
    _joined.dispose();
    _taddress.dispose();
    _tadhar.dispose();
    _tamount.dispose();
    _tmail.dispose();
    _tnum.dispose();
    _tjob.dispose();
    super.dispose();
  }

  String dropdownValue = "Remind";

  String tenantName = "";
  String dueDate = "";
  String amount = "";
  Map<String, String> messageMap = {};

  void setReminderData(Map tenantDetailsMap) {
    setState(
      () {
        tenantName = tenantDetailsMap["name"];
        dueDate = tenantDetailsMap["due"];
        amount = "\u20b9 " + tenantDetailsMap["amount"];
        messageMap = {
          "Gentle Reminder":
              "Dear $tenantName, Your amount of $amount is due for this month. Kindly pay it before $dueDate. \nThank you",
          "Reminder - 1":
              "Dear $tenantName, Reminding you again, Your amount of $amount  is due for this month. Kindly pay it before $dueDate. \nThank you",
          "Reminder - 2":
              "Dear $tenantName, Reminding you once more, $amount is due for this month. Kindly pay it before $dueDate. \nThank you",
          "Final Reminder":
              "Dear $tenantName, This is the final reminder. Your amount of $amount is due for this month. Kindly pay it before $dueDate. \nThank you",
          "Please pay by Today":
              "Dear $tenantName, This is the final reminder. Your amount of $amount is due for this month. Kindly pay it today as $dueDate. \nThank you",
          "Please pay by Tomorrow":
              "Dear $tenantName, This is the final reminder. Your amount of $amount is due for this month. Kindly pay it tomorrow as $dueDate.\nThank you",
          "Rent is paid":
              "Dear $tenantName, Your amount of $amount is paid. \nThank you",
        };
      },
    );
  }

  onShare(BuildContext context, String message) async {
    final RenderBox box = context.findRenderObject();
    await Share.share(message,
        subject: "Reminder",
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    Navigator.pop(context);
  }

  void handleDeleteRecord(int index) {
    DetailsFirebase().deleteRecord(index: index, userId: widget.userId);
  }

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

  void updateTenantList(int index) {
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
    DetailsFirebase().updateRecord(
        index: index,
        userId: widget.userId,
        tenantDetailsModel: _tenantDetailModel);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data["tenants"].length != 0
                ? buildTenantsDetails(snapshot.data["tenants"])
                : Center(
                    child: Text("No Tenants Found, Add Tenants to send Reminders"),
                  );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<Widget> buildReminderOptions() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15.0),
          topRight: Radius.circular(15.0),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: SingleChildScrollView(
            child: ListView(
              shrinkWrap: true,
              children: [
                "Gentle Reminder",
                'Reminder - 1',
                'Reminder - 2',
                'Final Reminder',
                'Please pay by Today',
                'Please pay by Tomorrow',
                'Rent is paid'
              ].map((String value) {
                return ListTile(
                  onTap: () => onShare(context, messageMap[value]),
                  trailing: Icon(Icons.arrow_right_rounded),
                  title: Text(
                    value,
                    style: TextStyle(fontFamily: "Josefin", fontSize: 20),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget buildTenantsDetails(List data) {
    TextStyle _subTitlestyle =
        TextStyle(fontFamily: "Josefin", color: Colors.black, fontSize: 17);
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) => ExpansionTile(
        title: Text(
          "Name: " + data[index]["name"],
          style: TextStyle(
              fontFamily: "Josefin", color: Colors.black, fontSize: 20),
        ),
        subtitle: Text("Contact: " + data[index]["mobile"],
            style: TextStyle(
                fontFamily: "Josefin", color: Colors.grey, fontSize: 17)),
        children: [
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text("Email : " + data[index]["email"],
                  style: _subTitlestyle),
              alignment: Alignment.centerLeft),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text("Amount : \u20B9" + data[index]["amount"],
                  style: _subTitlestyle),
              alignment: Alignment.centerLeft),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text("Due Date : " + data[index]["due"],
                  style: _subTitlestyle),
              alignment: Alignment.centerLeft),
          Container(
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                "Address : " + data[index]["address"],
                style: _subTitlestyle,
                overflow: TextOverflow.clip,
              ),
              alignment: Alignment.centerLeft),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerRight,
                child: FlatButton(
                  color: Color(0xFF5a20c7),
                  onPressed: () =>
                      handleUpdateRecord(data: data[index], index: index),
                  child: Text(
                    "Update",
                    style: TextStyle(
                        fontFamily: "Josefin",
                        color: Colors.white,
                        fontSize: 17),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerRight,
                child: FlatButton(
                  color: Color(0xFF5a20c7),
                  onPressed: () => handleDeleteRecord(index),
                  child: Text(
                    "Delete",
                    style: TextStyle(
                        fontFamily: "Josefin",
                        color: Colors.white,
                        fontSize: 17),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerRight,
                child: FlatButton(
                  color: Color(0xFF5a20c7),
                  onPressed: () {
                    setReminderData(data[index]);
                    return buildReminderOptions();
                  },
                  child: Text(
                    "Reminder",
                    style: TextStyle(
                        fontFamily: "Josefin",
                        color: Colors.white,
                        fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<Widget> handleUpdateRecord({Map data, int index}) {
    _tname.text = data["name"];
    _tadhar.text = data["aadhar"];
    _taddress.text = data["address"];
    _tamount.text = data["amount"];
    _due.text = data["due"];
    _tmail.text = data["email"];
    _tjob.text = data["job"];
    _joined.text = data["djoined"];
    _tnum.text = data["mobile"];
    return updateForm(context, index);
  }

  final _formKey = GlobalKey<FormState>();

  Future<Widget> updateForm(BuildContext context, int index) {
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
                      child: Text("Update Tenants",
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
                          validators: Validators.phoneNumberValidator),
                      buildTextFormField(
                          controller: _tamount,
                          label: "Rent *",
                          textInputType: TextInputType.number,
                          validators: Validators.rentValidator),
                      buildTextFormField(
                        controller: _joined,
                        label: "Joined date(DD/MM/YY) *",
                        textInputType: TextInputType.datetime,
                        validators: Validators.joinedDateValidator,
                      ),
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
                        updateTenantList(index);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text("Updated Sucessfuly"),
                          duration: Duration(seconds: 1),
                        ));
                        Navigator.pop(context);
                      } else
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text("Add Properly"),
                          duration: Duration(seconds: 1),
                        ));
                    },
                    child: Text("Update",
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
