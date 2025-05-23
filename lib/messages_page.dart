import 'package:flutter/material.dart';
import 'reusable_widgets.dart';
import 'global_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class MessagesPage extends StatefulWidget {
  MessagesPage({Key key}) : super(key: key);

  @override
  _MessagesPageState createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  var _messageList = List<ListTile>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ReusableWidgets.getAppBar("Messages"),
        drawer: ReusableWidgets.getDrawer(context),
        body: Center(child: _getMessageListWidget()));
  }

  Widget _getMessageListWidget() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          print('project snapshot data is: ${snapshot.data}');
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              ListTile tile = snapshot.data[index];
              return Column(
                children: <Widget>[tile],
              );
            },
          );
        } else {
          return new CircularProgressIndicator();
        }
      },
      future: _getMessages(),
    );
  }

  Future _getMessages() async {
    print('getMessages...');
    var dt = DateTime.now();
    //show messages from last 7 days
    dt = dt.subtract(Duration(days: 7));

    var messageList = [];
    QuerySnapshot querySnapshot = await Firestore.instance
        .collection("messages")
        .where("senderId", isEqualTo: GlobalState.uid)
        .where("timestamp", isGreaterThanOrEqualTo: dt)
        .getDocuments();

    QuerySnapshot querySnapshot2 = await Firestore.instance
        .collection("messages")
        .where("receiverId", isEqualTo: GlobalState.uid)
        .where("timestamp", isGreaterThanOrEqualTo: dt)
        .getDocuments();

    print("QuerySnapShot");
    print(querySnapshot.documents.length);
    var messages = [];
    for (var document in querySnapshot.documents) {
      Timestamp ts = document['timestamp'];
      DateTime d = ts.toDate();
      String fts = DateFormat('MM/dd – kk:mm').format(d);

      var message = {
        "senderId": document['senderId'],
        "receiverId": document['receiverId'],
        "senderName": document['senderName'],
        "receiverName": document['receiverName'],
        "timestamp": fts,
        "message": document['message'],
      };
      messages.add(message);
    }

    for (var document2 in querySnapshot2.documents) {
      Timestamp ts = document2['timestamp'];
      DateTime d = ts.toDate();
      String fts = DateFormat('MM/dd kk:mm').format(d);
      var message = {
        "senderId": document2['senderId'],
        "receiverId": document2['recieverId'],
        "senderName": document2['senderName'],
        "receiverName": document2['receiverName'],
        "timestamp": fts,
        "message": document2['message'],
      };
      messages.add(message);
    }

    //sort by timestamp
    print('Sorting start ' + messages.length.toString());
    /**
    messages.sort((a, b) {
      return a.value['timestamp']
          .toString()
          .toLowerCase()
          .compareTo(b.value['timestamp'].toString().toLowerCase());
    });
    */
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    print('Sorting done');
    for (var mesg in messages) {
      print(mesg);
      Icon mesgIcon = Icon(
        Icons.arrow_left,
        color: Colors.purple[900],
        size: 36.0,
      );

      // print('Receiver:' + mesg['receiverId'] + '  ' + mesg['senderId']);
      if (mesg['receiverId'] == GlobalState.uid) {
        mesgIcon = Icon(
          Icons.arrow_right,
          color: Colors.green[800],
          size: 36.0,
        );
      }

      //String mesg = message['message'];
      messageList.add(ListTile(
        leading: mesgIcon,
        title: Text(mesg['receiverName'] + ' ' + mesg['timestamp']),
        subtitle: Text(mesg['message']),
        trailing: Icon(Icons.more_vert),
      ));
    }

    print("MessageList: " + messageList.toString());

    return messageList;
  }
}
