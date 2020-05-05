import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

//pushdoc("players", {'name':thing, 'avatar': link})



