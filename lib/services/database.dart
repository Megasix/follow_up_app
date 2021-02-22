import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:follow_up_app/models/setting.dart';
import 'package:follow_up_app/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  //collections references
  final CollectionReference usersSettigsCollection = Firestore.instance.collection('usersSettings');

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
      return Setting(name: doc.data['name'] ?? 'new User', age: doc.data['age'] ?? 16, hobby: doc.data['hobby'] ?? 'nothing');
    }).toList();
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
        uid: uid,
        name: snapshot.data['name'],
        hobby: snapshot.data['hobby'],
        age: snapshot.data['age']
    );
  }

  //get usersSettings stream
  Stream<List<Setting>> get usersSettings {
    return usersSettigsCollection.snapshots().map(_settingListFromSnapshot);
  }

  // get user doc stream
  Stream<UserData> get userData {
    return usersSettigsCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }
}
