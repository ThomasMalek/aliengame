import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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

Future<String> addDoc(coll, doc, data) async {
  // coll is the collection to push to
  // doc is the new document to add
  String docID = 'nothing';
  //coll is the collection name
  final ret = await _firestore.collection(coll).document(doc).updateData(data);
  return docID;
}

Future<int> playerCount() async {
  int playerlimit = 0;
  final response = await _firestore.collection("players").getDocuments();
  playerlimit = response.documents.length;
//      .then((QuerySnapshot snapshot) {
//    snapshot.documents.forEach((f) => (playerlimit++));
//  });
  return playerlimit + 1;
}

//This gets playerlist for waitscreen
Future<List> getPlayerList() async {
  DocumentSnapshot player;
  final snapshot = await _firestore.collection('players').getDocuments();
  List players = snapshot.documents;
  return (players);
}

//This gets players in current game
Future<List> getPlayerLists(gameID) async {
  DocumentSnapshot player;
  final snapshot =
      await _firestore.collection('games/$gameID/players').getDocuments();
  return (snapshot.documents);
}

Future<List> getRoundsList(gameID) async {
  DocumentSnapshot player;
  final snapshot =
      await _firestore.collection('games/$gameID/rounds').getDocuments();
  return (snapshot.documents);
}

Future<Map> getPlayerInfo(userID) async {
  final response =
      await _firestore.document('/players/${userID.toString()}').get();
  return (response.data);
}

Future<Map> getCurrentPlayer(userID) async {
  final currentPlayer =
      await _firestore.collection('players').document(userID).get();
  return (currentPlayer.data);
}

void deletePlayers() async {
  _firestore.collection('players').getDocuments().then((snapshot) {
    for (DocumentSnapshot ds in snapshot.documents) {
      ds.reference.delete();
    }
  });
}

List shuffle(List items) {
  var random = new Random();
  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }
  return items;
}
