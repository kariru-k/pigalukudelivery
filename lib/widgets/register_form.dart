import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/home_screen.dart';
import '../screens/register_screen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmpasswordTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final _phoneNumberTextController = TextEditingController();
  bool _isLoading = false;



  Future<String?>uploadFile(filePath) async {
    File file = File(filePath);


    FirebaseStorage storage = FirebaseStorage.instance;

    try {
      await storage
          .ref("deliverypersonpic/${_nameTextController.text}").putFile(file);
    } on FirebaseException {
      //Error
    }

    String downloadUrl = await storage
        .ref("deliverypersonpic/${_nameTextController.text}")
        .getDownloadURL();

    return downloadUrl;
  }



  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context);

    scaffoldMessage(message){
      return ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(message)
          )
      );
    }

    return _isLoading ? Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
      ),
    ) : Form(
      key: _formKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _nameTextController,
              validator: (value){
                if(value!.isEmpty){
                  return "Enter Your Name";
                }
                setState(() {
                  _nameTextController.text = value;
                });
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person),
                labelText: "Full Name",
                focusColor: Theme.of(context).primaryColor,
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                ),
                enabledBorder: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    style: BorderStyle.solid,
                    width: 2,
                    color: Theme.of(context).primaryColor
                  )
                )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _phoneNumberTextController,
              keyboardType: TextInputType.phone,
              validator: (value){
                if(value!.isEmpty){
                  return "Enter Your Phone Number";
                }
                return null;
              },
              maxLength: 9,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone),
                  prefixText: "+254",
                  labelText: "Your Phone Number",
                  contentPadding: EdgeInsets.zero,
                  focusColor: Theme.of(context).primaryColor,
                  enabledBorder: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor
                      )
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              validator: (value){
                if(value!.isEmpty){
                  return "Enter Email Address";
                }
                final bool isValid = EmailValidator.validate(_emailTextController.text);
                if(!isValid){
                  return "This Email is invalid";
                }
                setState(() {
                  _emailTextController.text = value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_sharp),
                  labelText: "Email Address",
                  contentPadding: EdgeInsets.zero,
                  focusColor: Theme.of(context).primaryColor,
                  enabledBorder: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor
                      )
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _passwordTextController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value){
                if(value!.isEmpty){
                  return "Enter a password";
                }
                if(value.length < 6){
                  return "Minimum number of characters is 6";
                }
                setState(() {
                  _passwordTextController.text = value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_sharp),
                  labelText: "Choose a Password",
                  contentPadding: EdgeInsets.zero,
                  focusColor: Theme.of(context).primaryColor,
                  enabledBorder: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor
                      )
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _confirmpasswordTextController,
              obscureText: true,
              enableSuggestions: false,
              autocorrect: false,
              validator: (value){
                if(value!.isEmpty){
                  return "Please retype your password";
                }
                if(_passwordTextController.text != _confirmpasswordTextController.text){
                  return "Your passwords do not match";
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password_sharp),
                  labelText: "Confirm your Password",
                  contentPadding: EdgeInsets.zero,
                  focusColor: Theme.of(context).primaryColor,
                  enabledBorder: const OutlineInputBorder(),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        style: BorderStyle.solid,
                        width: 2,
                        color: Colors.redAccent
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor
                      )
                  )
              ),
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton(
              onPressed: () {
                if(authData.isPicAvailable == true){
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    authData.registerDeliveryPerson(_emailTextController.text, _passwordTextController.text).then((credential){
                      if(credential?.user?.uid != null){
                        uploadFile(authData.image?.path).then((url) {
                          if(url != null){
                            authData.saveDeliveryPersonDataToDb(
                              url: url,
                              name: _nameTextController.text,
                              phoneNumber: _phoneNumberTextController.text,
                              email: _emailTextController.text
                            ).then((value){
                              setState(() {
                                _formKey.currentState?.reset();
                                _isLoading = false;
                              });
                              Navigator.pushReplacementNamed(context, HomeScreen.id);
                            });
                          } else {
                            scaffoldMessage("Failed to upload Shop Profile Picture");
                          }
                        });

                      } else {
                        scaffoldMessage(authData.error);
                        Navigator.pushReplacementNamed(context, RegisterScreen.id);
                      }
                    });
                  } else {
                  }
                } else {
                  scaffoldMessage("Please add your shop's profile picture");
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor
              ),
              child: const Text("REGISTER")
          )
        ],
      ),
    );
  }
}
