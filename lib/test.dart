import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

//void pushSprintFeedbackForm(clientId, sprintDocId, data, source) async {
//  //method to add client feedback to a sprint
//  final resp = await _firestore.collection('players').add({
//    'overallScore': data['overallScore'].toDouble(),
//    'recommendScore': data['recommendScore'].toDouble(),
//    'recommendComments': data['recommendComments'].toString(),
//    'responsiveness': data['responsiveness'].toDouble(),
//    'communication': data['communication'].toDouble(),
//    'techSkills': data['techSkills'].toDouble(),
//    'teamComments': data['teamComments'].toString(),
//    'createdOn': new DateTime.now(),
//    'source': source.toString(),
//  });
//
//  print(resp.toString());
//}
//
//
Firestore _firestore = Firestore.instance;

Future<String> pushDoc(coll, doc) async {
  // coll is the collection to push to
  // doc is the new document to add
  String docID = 'nothing';
  //coll is the collection name
  final ret = await _firestore.collection(coll).add(doc).then((docRef) {
    docID = docRef.documentID;
  }).catchError((e) {});
  return docID;
}

Future<int> playerCount() async {
  int playerlimit = 0;
  final response = await _firestore.collection("players").getDocuments();
  print(response.documents.length);
  playerlimit = response.documents.length;
//      .then((QuerySnapshot snapshot) {
//    snapshot.documents.forEach((f) => (playerlimit++));
//  });
  return playerlimit + 1;
}

Future<List> getPlayerList() async {
  DocumentSnapshot player;
  final snapshot = await _firestore.collection('players').getDocuments();
  List players = snapshot.documents;
  return (players);
}

Future<Map> getPlayerInfo(userID) async {
  final response =
      await _firestore.document('/players/${userID.toString()}').get();
  return (response.data);
}

void teamAssign(userID, status, leaderstatus) async {
  final playersInGame = await getPlayerList();

  final ret = await _firestore
      .collection('players')
      .document(userID)
      .setData({'userID': userID, 'alien': status, 'leader': leaderstatus});
}

Future<Map> getCurrentPlayer(userID) async {
  final currentplayer =
      await _firestore.collection('players').document(userID).get();
  return (currentplayer.data);
}
