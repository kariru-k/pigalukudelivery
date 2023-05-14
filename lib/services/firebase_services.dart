import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices{
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference deliverypeople = FirebaseFirestore.instance.collection("deliverypersons");
  CollectionReference orders = FirebaseFirestore.instance.collection("orders");
  CollectionReference customers = FirebaseFirestore.instance.collection("users");

  Future<DocumentSnapshot>validateUser(id) async {
    DocumentSnapshot result = await deliverypeople.doc(id).get();
    return result;
  }

  Future<DocumentSnapshot>getCustomerDetails(id) async{
    DocumentSnapshot doc = await customers.doc(id).get();
    return doc;
  }


}