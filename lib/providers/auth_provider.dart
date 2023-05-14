import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart';

class AuthProvider extends ChangeNotifier {

  late File? image;
  bool isPicAvailable = false;
  final picker = ImagePicker();
  String? pickererror;
  double? userLatitude;
  double? userLongitude;
  String? userAddress;
  String? userStreet;
  String? userSubLocality;
  String? userLocality;
  String? error;
  String? email;

  getEmail(email){
    this.email = email;
    notifyListeners();
  }

  Future<File?> getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      pickererror = "No image selected";
      notifyListeners();
    }

    return image;
  }

  Future getCurrentAddress() async {
    loc.Location location = loc.Location();

    bool serviceEnabled;
    LocationPermission permissionGranted;


    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionGranted = await Geolocator.checkPermission();
    if (permissionGranted == LocationPermission.denied) {
      permissionGranted = await Geolocator.requestPermission();
      if (permissionGranted == LocationPermission.denied) {
        return Future.error("Location Permissions are denied");
      }
    }

    Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high
      );

    userLatitude = position.latitude;
    userLongitude = position.longitude;
    notifyListeners();

    var addresses = await placemarkFromCoordinates(
        userLatitude!, userLongitude!);
    var first = addresses.first;
    userAddress = first.name;
    userStreet = first.street;
    userSubLocality = first.subLocality;
    userLocality = first.locality;

    User? user = FirebaseAuth.instance.currentUser;


    if (user != null) {
      DocumentReference deliverypersons = FirebaseFirestore.instance.collection("deliverypersons").doc(user.email);
      deliverypersons.update({
        'location': GeoPoint(userLatitude!, userLongitude!),
      });
    } else{
    }

    notifyListeners();



    return userAddress;
    }

  Future<UserCredential?> registerDeliveryPerson(email, password) async {
      this.email = email;
      notifyListeners();

      UserCredential? userCredential;
      try {
        userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak_password") {
          error = e.code;
          notifyListeners();
        } else if (e.code == "email-already-in-use") {
          error = e.code;
          notifyListeners();
        }
      } catch (e) {
        error = e.toString();
        notifyListeners();
      }

      return userCredential;
  }


  Future<UserCredential?> loginDeliveryPerson(email, password) async {
    this.email = email;
    notifyListeners();

    UserCredential? userCredential;
    try {
      userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
    } on FirebaseAuthException catch (e) {
      error = e.code;
      notifyListeners();
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }

    return userCredential;
  }

  Future<void> resetPassword(email) async {
      this.email = email;
      notifyListeners();
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      } on FirebaseAuthException catch (e) {
        error = e.code;
        notifyListeners();
      } catch (e) {
        error = e.toString();
        notifyListeners();
      }
  }

  Future<void> saveDeliveryPersonDataToDb({
    String? url,
    String? name,
    String? phoneNumber,
    String? email,
  }) async {

    User? user = FirebaseAuth.instance.currentUser;

    DocumentReference deliverypersons = FirebaseFirestore.instance.collection("deliverypersons").doc(email);

    deliverypersons.set({
      'uid': user!.uid,
      'url': url,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'location': GeoPoint(userLatitude!, userLongitude!),
      "accVerified": false
    });

    return;
  }
}