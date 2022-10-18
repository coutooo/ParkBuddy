import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  // collection reference

  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference mainDB =
      FirebaseFirestore.instance.collection('mainDB');
  final CollectionReference userPlans =
      FirebaseFirestore.instance.collection('userPlans');
  final CollectionReference ptPlans =
      FirebaseFirestore.instance.collection('ptplans');

  Future updateUserData(String name, String ptUid, String nutUid,
      String ptplanUid, String nutplanUid, String wilksCoeff) async {
    return await mainDB.doc(uid).set({
      'name': name,
      'ptId': ptUid,
      'nutId': nutUid,
      'planId': ptplanUid,
      'nutplanUid': nutplanUid,
      'wilks_coeff': wilksCoeff,
    });
  }

  Future updateUserPT(String ptUid) async {
    return await mainDB.doc(uid).update({
      'ptId': ptUid,
    });
  }

  Future updateUserNUT(String nutUid) async {
    return await mainDB.doc(uid).update({
      'nutId': nutUid,
    });
  }

  Future updateUserPTplan(String planUid) async {
    return await mainDB.doc(uid).update({
      'planId': planUid,
    });
  }

  Future updateUserNUTplan(String nutplanUid) async {
    return await mainDB.doc(uid).update({
      'nutplanUid': nutplanUid,
    });
  }

  Future updateUserCoeff(String wilksCoeff) async {
    return await mainDB.doc(uid).update({
      'wilks_coeff': wilksCoeff,
    });
  }

  Future addUserPlan(
    String monday,
    String tuesday,
    String wednesday,
    String thursday,
    String friday,
    String saturday,
    String sunday,
  ) async {
    return await userPlans.doc(uid).set({
      'monday': monday,
      'tuesday': tuesday,
      'wednesday': wednesday,
      'thursday': thursday,
      'friday': friday,
      'saturday': friday,
      'sunday': sunday,
    });
  }

  Future<void> getPTplans() async {
    Map<Object, Object> plan = {};

    ptPlans.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        var thurd = doc["daysofweek"]["Thursday"];
        var fri = doc["daysofweek"]["friday"];
        var mon = doc["daysofweek"]["monday"];
        var tues = doc["daysofweek"]["tuesday"];

        print(doc["daysofweek"]["Thursday"]);
        print(doc["daysofweek"]["friday"]);
        print(doc["daysofweek"]["monday"]);
        print(doc["daysofweek"]["tuesday"]);

        plan['Thursday'] = thurd;
        plan['friday'] = fri;
        plan['monday'] = mon;
        plan['tuesday'] = tues;

        print(plan);
      });
    });
  }

  Future<String> getUserName() async {
    DocumentReference documentReference = mainDB.doc(uid);
    String name = '';
    await documentReference.get().then((snapshot) {
      name = snapshot['name'];
    });
    return name;
  }

  Future updateUserName(String name) async {
    return await mainDB.doc(uid).update({
      'name': name,
    });
  }

  Future<String> getUserPT() async {
    DocumentReference documentReference = mainDB.doc(uid);
    String pt = '';
    await documentReference.get().then((snapshot) {
      pt = snapshot['ptId'];
    });
    return pt;
  }
}
