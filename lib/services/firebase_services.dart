import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices{
  CollectionReference deliverypeople = FirebaseFirestore.instance.collection("deliverypersons");

  Future<DocumentSnapshot>validateUser(id) async {
    DocumentSnapshot result = await deliverypeople.doc(id).get();
    return result;
  }
}