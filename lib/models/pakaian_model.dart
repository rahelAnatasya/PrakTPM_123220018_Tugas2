class Pakaian {
  final int id;
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
    // Debug untuk melihat data mentah dari API
    print("Raw JSON data: $json");

    // Handle kasus di mana kita menerima respons API lengkap atau hanya bagian data
    Map<String, dynamic> data = json;
    if (json.containsKey('data')) {
      data = json['data'];
    }

    print("Material from API: ${data['material']}");

    return Pakaian(
      id: data['id'],
      name: data['name'],
      price: data['price'],
      category: data['category'],
      brand: data['brand'] ?? '',
      sold: data['sold'] ?? 0,
      rating:
          (data['rating'] is int)
              ? (data['rating'] as int).toDouble()
              : (data['rating'] ?? 0.0),
      stock: data['stock'] ?? 0,
      yearReleased: data['yearReleased'] ?? 0,
      material: data['material'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
