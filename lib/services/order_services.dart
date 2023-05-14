import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class OrderServices {

  CollectionReference orders = FirebaseFirestore.instance.collection("orders");


  Future<void>updateOrderStatus(documentId, status){
    var result = orders.doc(documentId).update({
      "orderStatus": status
    });
    return result;
  }

  Widget statusContainer(data, document, context){
    if (data["orderStatus"] == "Accepted") {
      return Container(
        color: Colors.grey.shade300,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: (){},
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blueGrey
                  ),
                  child: const Text(
                    "Select Delivery Person",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: (){
                    showMyDialog(
                        title: "Cancel Order",
                        content: "Are you sure you want to cancel the order?",
                        status: "Cancelled",
                        documentId: document.id,
                        context: context
                    );
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (data["orderStatus"] == "Assigned A Delivery Person") {
      return Container(
        color: Colors.grey.shade300,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: (){
                    showMyDialog(
                        title: "Pick Up",
                        content: "Is the order ready for pickup?",
                        status: "Picked Up",
                        documentId: document.id,
                        context: context
                    );
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blueGrey
                  ),
                  child: const Text(
                    "Pick Up",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (data["orderStatus"] == "Picked Up") {
      return Container(
        color: Colors.grey.shade300,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: (){
                    showMyDialog(
                        title: "Ready to Start the Delivery?",
                        content: "The customer will be aware that you are on your way",
                        status: "On the Way",
                        documentId: document.id,
                        context: context
                    );
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blueGrey
                  ),
                  child: const Text(
                    "Start Journey to Delivery",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (data["orderStatus"] == "On the Way") {
      return Container(
        color: Colors.grey.shade300,
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: (){
                    if (data["cod"] == true) {
                      showMyDialog(
                          title: "Please Receive Payment From the Customer First. They owe Kshs.${data["total"]}",
                          content: "Ensure that the customer pays you first before handing the item over as this delivery is Cash on Delivery",
                          status: "Delivered",
                          documentId: document.id,
                          context: context
                      );
                    } else {
                      showMyDialog(
                          title: "Please Hand Over the Item",
                          content: "The Customer has already paid. Hand over the item and thank them",
                          status: "Delivered",
                          documentId: document.id,
                          context: context
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.blueGrey
                  ),
                  child: const Text(
                    "Confirm Delivery",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (data["orderStatus"] == "Delivered") {
      return Row(
        children: [
          Expanded(
            child: TextButton(
              onPressed: (){},
              style: TextButton.styleFrom(
                  backgroundColor: Colors.green
              ),
              child: const Text(
                "Order Completed",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
          ),
        ],
      );
    }
    if(data["orderStatus"] == "Ordered"){
      return Container(
        color: Colors.grey[300],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: (){
                      showMyDialog(
                          title: "Accept Order",
                          content: "Accept the Order?",
                          status: "Accepted",
                          documentId: document.id,
                          context: context
                      );
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blueGrey
                    ),
                    child: const Text(
                      "Accept",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: (){
                      showMyDialog(
                          title: "Reject Order",
                          status: "Rejected",
                          content: "Reject the Order?",
                          documentId: document.id,
                          context: context
                      );
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.red
                    ),
                    child: const Text(
                      "Reject",
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Color statusColor(DocumentSnapshot document){
    if (document["orderStatus"] == "Accepted") {
      return Colors.blueGrey.shade400;
    }
    if (document["orderStatus"] == "Rejected" || document["orderStatus"] == "Cancelled") {
      return Colors.red;
    }
    if (document["orderStatus"] == "Picked Up") {
      return Colors.pink.shade900;
    }
    if (document["orderStatus"] == "On the way") {
      return Colors.purple.shade900;
    }
    if (document["orderStatus"] == "Delivered") {
      return Colors.green.shade900;
    }
    return Colors.orange;
  }

  Icon statusIcon(DocumentSnapshot document){
    if (document["orderStatus"] == "Accepted") {
      return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),);
    }
    if (document["orderStatus"] == "Rejected" || document["orderStatus"] == "Cancelled") {
      return Icon(Icons.cancel_outlined, color: statusColor(document),);
    }
    if (document["orderStatus"] == "Picked Up") {
      return Icon(Icons.cases, color: statusColor(document),);
    }
    if (document["orderStatus"] == "On the way") {
      return Icon(Icons.delivery_dining_outlined, color: statusColor(document),);
    }
    if (document["orderStatus"] == "Delivered") {
      return Icon(Icons.shopping_bag_rounded, color: statusColor(document),);
    }
    return Icon(Icons.assignment_turned_in_outlined, color: statusColor(document),);

  }

  showMyDialog({required title, required content, required status,required documentId,required context}){
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context){
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: (){
                    EasyLoading.show(status: "Updating order...");
                    updateOrderStatus(documentId, status).then((value){
                      EasyLoading.showSuccess("Successfully updated order");
                    });
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Go Back",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )
              )
            ],
          );
        }
    );
  }

}