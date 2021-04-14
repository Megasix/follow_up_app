import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:follow_up_app/models/geoData.dart';
import 'package:follow_up_app/models/setting.dart';
import 'package:follow_up_app/models/user.dart';
import 'package:geolocator/geolocator.dart';

class DatabaseService {
  final String uid;
  UserData _userData = new UserData();

  DatabaseService({this.uid});

  //collections references
  final CollectionReference usersSettigsCollection =
      Firestore.instance.collection('usersSettings');
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name, int age, String hobby) async {
    return await usersSettigsCollection.document(uid).setData({
      'name': name,
      'age': age,
      'hobby': hobby,
    });
  }

  //setting list from snapshot
  List<Setting> _settingListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Setting(
          name: doc.get('name') ?? 'new User',
          age: doc.get('age') ?? 16,
          hobby: doc.get('hobby') ?? 'nothing');
    }).toList();
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) => UserData(
      uid: uid,
      name: snapshot.get('name'),
      hobby: snapshot.get('hobby'),
      age: snapshot.get('age'));

  //get usersSettings stream
  Stream<List<Setting>> get usersSettings {
    return usersSettigsCollection.snapshots().map(_settingListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return usersSettigsCollection
        .doc(uid)
        .snapshots()
        .map(_userDataFromSnapshot);
  }

  Future dataInitialisation(
    DateTime dateTime,
    String country,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
  ) async {
    Timestamp timestamp = Timestamp.fromDate(dateTime);
    usersCollection.doc(email).collection("usersData").doc("display").set({
      'theme': true,
    });
    usersCollection
        .doc(email)
        .collection("usersData")
        .doc("notifications")
        .set({
      'notification': true,
    });
    usersCollection.doc(email).collection("usersData").doc("profile").set({
      'birthDate': timestamp,
      'country': country,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber': phoneNumber,
      'uid': uid,
    });
  }

  storePosition(List<GeoPoint> position) {
    usersCollection
        .doc("olivier_dery-prevost@hotmail.com")
        .collection("usersData")
        .doc("Data")
        .set({'Localisation': position});
  }
}
