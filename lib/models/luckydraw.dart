// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class LuckyDraw extends Equatable {
  String charges, discount, productId, uid, name;
  String winnerId, link;
  Timestamp date;
  bool isActive;
  LuckyDraw({
    required this.link,
    required this.winnerId,
    required this.charges,
    required this.date,
    required this.discount,
    required this.isActive,
    required this.productId,
    required this.uid,
    required this.name,
  });

  @override
  List<Object?> get props =>
      [productId, charges, date, isActive, discount, link, winnerId];
  static LuckyDraw fromSnapshot(DocumentSnapshot snap) {
    LuckyDraw draw = LuckyDraw(
      uid: snap.id,
      date: snap['date'],
      discount: snap['discount'],
      productId: snap['product_id'],
      charges: snap['charges'],
      isActive: snap['isActive'],
      name: snap['name'],
      winnerId: snap['winner'],
      link: snap['link'],
    );
    return draw;
  }

  static List<LuckyDraw> products = [];
}
