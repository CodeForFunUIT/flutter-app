import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/models/destinations.dart';
import 'package:flutter_app/models/provinces.dart';

class DestinationRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Destination>> destinationStream() {
    return _db
        .collection('destinations')
        .orderBy('name', descending: true)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Destination> list = [];
      query.docs.forEach((element) {
        //add data
        list.add(Destination.fromJson(element));
      });
      return list;
    });
  }

  Stream<List<Destination>> destinationByProvinceStream(String provinceId) {
    return _db
        .collection('destinations')
        .orderBy('name', descending: true)
        .where('provinceId', isEqualTo: provinceId)
        .snapshots()
        .map((QuerySnapshot query) {
      List<Destination> list = [];
      query.docs.forEach((element) {
        //add data
        list.add(Destination.fromJson(element));
      });
      return list;
    });
  }
}
