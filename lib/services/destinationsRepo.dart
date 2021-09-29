import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/const_values/controller.dart';
import 'package:flutter_app/models/destinations.dart';
import 'package:flutter_app/models/provinces.dart';
import 'package:flutter_app/services/usersRepo.dart';
import 'package:get/get.dart';

class DestinationRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Destination>> destinationStream() {
    return _db
        .collection('destinations')
        .orderBy('favorites', descending: true)
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
    if (provinceId == 'Alls') {
      return _db
          .collection('destinations')
          .snapshots()
          .map((QuerySnapshot query) {
        List<Destination> list = [];
        query.docs.forEach((element) {
          //add data
          list.add(Destination.fromJson(element));
        });
        return list;
      });
    } else {
      return _db
          .collection('destinations')
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

  Stream<List<Destination>> favDestinationStream(List<String>? listId) {
    return _db
        .collection('destinations')
        .snapshots()
        .map((QuerySnapshot query) {
      List<Destination> list = [];
      query.docs.forEach((element) {
        //add data
        if (listId!.contains(element.id))
          list.add(Destination.fromJson(element));
      });
      return list;
    });
  }

  // Future<void> updateUserFav(Destination destination, bool isLiked) async {
  //   if (!isLiked) {
  //     await _db.collection('users').doc('${UserRepo.customer.uid}').update({
  //       'favoriteDes': UserRepo.customer.favoriteDes
  //     }).then((value) async => {
  //           await _db
  //               .collection('destinations')
  //               .doc('${destination.uid}')
  //               .update({'favorites': destination.favorites + 1}).then(
  //                   (value) =>
  //                       UserRepo.customer.favoriteDes!.add(destination.uid))
  //         });
  //   } else {
  //     await _db.collection('users').doc('${UserRepo.customer.uid}').update({
  //       'favoriteDes': UserRepo.customer.favoriteDes
  //     }).then((value) async => {
  //           await _db
  //               .collection('destinations')
  //               .doc('${destination.uid}')
  //               .update({'favorites': destination.favorites - 1}).then(
  //                   (value) =>
  //                       UserRepo.customer.favoriteDes!.remove(destination.uid))
  //         });
  //   }
  // }

  Future<bool> updateUserFav(Destination destination, bool isLiked) async {
    bool _success = false;
    if (!isLiked) {
      UserRepo.customer.favoriteDes!.add(destination.uid);
      await _db
          .collection('users')
          .doc('${UserRepo.customer.uid}')
          .update({'favoriteDes': UserRepo.customer.favoriteDes});
      await _db
          .collection('destinations')
          .doc('${destination.uid}')
          .update({'favorites': destination.favorites + 1});
      _success = true;
    } else {
      UserRepo.customer.favoriteDes!.remove(destination.uid);
      await _db
          .collection('users')
          .doc('${UserRepo.customer.uid}')
          .update({'favoriteDes': UserRepo.customer.favoriteDes});
      await _db
          .collection('destinations')
          .doc('${destination.uid}')
          .update({'favorites': destination.favorites - 1});
      _success = true;
    }
    return _success;
  }
}