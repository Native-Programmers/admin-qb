import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String uid;
  final String name;
  final String category;
  final List imageUrl;
  final int price;
  final String desc;
  final bool isRecommended;
  final bool isPopular;
  final bool isActive;
  final List wishList;

  const Product({
    required this.uid,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.isRecommended,
    required this.isPopular,
    required this.isActive,
    required this.desc,
    required this.wishList,
  });

  @override
  List<Object?> get props =>
      [uid, name, category, imageUrl, price, isRecommended, isPopular];

  static Product fromSnapshot(DocumentSnapshot snap) {
    Product product = Product(
      uid: snap.id,
      name: snap['name'],
      category: snap['category'],
      imageUrl: snap['imageUrl'],
      price: snap['price'],
      isRecommended: snap['isRecommended'],
      isPopular: snap['isPopular'],
      isActive: snap['isActive'],
      desc: snap['desc'],
      wishList: snap['wishlist'],
    );
    return product;
  }

  static List<Product> products = const [];
}
