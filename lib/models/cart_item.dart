import 'package:hive/hive.dart';

part 'cart_item.g.dart'; // jangan dihapus, ini tetap diperlukan

@HiveType(typeId: 0)
class CartItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String imageUrl;

  @HiveField(3)
  String price;

  @HiveField(4)
  String priceSign;

  @HiveField(5)
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.priceSign,
    this.quantity = 1,
  });

  /// Method bantu untuk membuat salinan dengan nilai tertentu diubah
  CartItem copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? price,
    String? priceSign,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      priceSign: priceSign ?? this.priceSign,
      quantity: quantity ?? this.quantity,
    );
  }
}
