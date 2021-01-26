import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rent_lo_app/model/userDetailsModel.dart';
import 'package:rent_lo_app/model/tentantDetailsModel.dart';
import 'package:rent_lo_app/res/saveSharedPreference.dart';

class DetailsFirebase {
  Future<String> sendUserDetails({UserDetailsModel detailsModel}) async {
    Map<String, dynamic> detailsMap = {
      "phoneNumber": detailsModel.phoneNumber,
      "name": detailsModel.name,
      "dob": detailsModel.dob,
      "email": detailsModel.email,
      "tenants": [],
    };
    String id;
    DocumentReference documentReference =
        await FirebaseFirestore.instance.collection("users").add(detailsMap);
    id = documentReference.id;
    return id;
  }

  void sendTenantsDetails(
      {TenantDetailsModel tenantDetailsModel, String userId}) async {
    List<Map<String, dynamic>> tenantDetailsMap = [
      {
        "name": tenantDetailsModel.name,
        "mobile": tenantDetailsModel.mobileNumber,
        "email": tenantDetailsModel.email,
        "aadhar": tenantDetailsModel.aadharNumber,
        "amount": tenantDetailsModel.amount,
        "due": tenantDetailsModel.dueDate,
        "djoined": tenantDetailsModel.joined,
        "address": tenantDetailsModel.address,
        "job": tenantDetailsModel.job,
      }
    ];
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .update({"tenants": FieldValue.arrayUnion(tenantDetailsMap)});
  }

  Future<UserDetailsModel> checkAlreadyAMemeber({String phoneNumber}) async {
    UserDetailsModel _userdetailsModel;
    await FirebaseFirestore.instance
        .collection("users")
        .where("phoneNumber", isEqualTo: phoneNumber)
        .get()
        .then((QuerySnapshot querySnapshot) {
      try {
        SaveSharedPreference.saveUserId(querySnapshot.docs[0].id);
        var data = querySnapshot.docs[0].data();
        SaveSharedPreference.saveUserName(data["name"]);
        SaveSharedPreference.savePhoneNumber(data["phoneNumber"]);
        SaveSharedPreference.saveUserEmail(data["email"]);
        _userdetailsModel = UserDetailsModel(
            email: data["email"],
            phoneNumber: data["phoneNumber"],
            name: data["name"],
            userId: querySnapshot.docs[0].id);
      } catch (error) {
        print(error);
      }
    });
    return _userdetailsModel;
  }

  void deleteRecord({int index, String userId}) async {
    List _temp;
    int flag = 0;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((DocumentSnapshot value) {
      _temp = value.data()["tenants"] as List;
      _temp.removeAt(index);
      flag = 1;
    });

    if (flag == 1) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .update({"tenants": _temp});
    }
  }

  void updateRecord(
      {int index, String userId, TenantDetailsModel tenantDetailsModel}) async {
    Map<String, dynamic> tenantDetailsMap = {
      "name": tenantDetailsModel.name,
      "mobile": tenantDetailsModel.mobileNumber,
      "email": tenantDetailsModel.email,
      "aadhar": tenantDetailsModel.aadharNumber,
      "amount": tenantDetailsModel.amount,
      "due": tenantDetailsModel.dueDate,
      "djoined": tenantDetailsModel.joined,
      "address": tenantDetailsModel.address,
      "job": tenantDetailsModel.job,
    };

    List _temp;
    int flag = 0;
    print(index);
    print(userId);
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((DocumentSnapshot value) {
      _temp = value.data()["tenants"] as List;
      print("Old map : " + _temp[index].toString());
      print("new Map : " + tenantDetailsMap.toString());
      _temp[index] = tenantDetailsMap;
      flag = 1;
    });

    if (flag == 1) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .update({"tenants": _temp});
    }
  }
}
