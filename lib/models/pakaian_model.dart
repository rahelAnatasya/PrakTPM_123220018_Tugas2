class Pakaian {
  final String id;
  final String name;
  final int price;
  final String category;
  final String brand;
  final int sold;
  final double rating;
  final int stock;
  final int yearReleased;
  final String material;
  Pakaian({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.brand,
    required this.sold,
    required this.rating,
    required this.stock,
    required this.yearReleased,
    required this.material,
  });

  factory Pakaian.fromJson(Map<String, dynamic> json) {
    return Pakaian(
      id: json['id'].toString(),
      name: json['name'].toString(),
      price: int.parse(json['price'].toString()),
      category: json['category'].toString(),
      brand: json['brand'].toString(),
      sold: int.parse(json['sold'].toString()),
      rating: (json['rating'] as num).toDouble(),
      stock: int.parse(json['stock'].toString()),
      yearReleased: int.parse(json['yearReleased'].toString()),
      material: json['material'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'category': category,
      'brand': brand,
      'sold': sold,
      'rating': rating,
      'stock': stock,
      'yearReleased': yearReleased,
      'material': material,
    };
  }
}
