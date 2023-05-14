import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pigalukudelivery/screens/login_screen.dart';
import 'package:pigalukudelivery/services/firebase_services.dart';
import 'package:pigalukudelivery/widgets/order_summary_card.dart';

class HomeScreen extends StatefulWidget {
  static const String id = "home-screen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  User? user = FirebaseAuth.instance.currentUser;


  FirebaseServices firebaseServices = FirebaseServices();
  int tag = 0;
  List<String> options = [
    'All Orders', "Ordered", 'Accepted', "Assigned A Delivery Person" ,'Picked Up',
    'On the Way', 'Delivered'
  ];
  String? status;

  @override
  Widget build(BuildContext context) {



    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Delivery Orders"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: (){
            FirebaseAuth.instance.signOut().then((value){
              Navigator.pushReplacementNamed(context, LoginScreen.id);
            });
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              choiceStyle: const C2ChipStyle(
                  borderRadius: BorderRadius.all(Radius.circular(3))
              ),
              value: tag,
              onChanged: (val){
                if (val ==0) {
                  setState(() {
                    status = null;
                  });
                }
                  setState((){
                    tag = val;
                    status = null;
                  });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: firebaseServices.orders
                .where("deliveryBoy.email", isEqualTo: user!.email)
                .where("orderStatus", isEqualTo: tag == 0 ? null : options[tag].toString())
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }


              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.size == 0) {
                return Center(
                  child: Text("No ${options[tag]} orders here"),
                );
              }

              return Expanded(
                child: ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OrderSummaryCard(data: data, document: document),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ],
      )
    );
  }
}
