import 'package:flutter/material.dart';
import 'package:pakaian_app/services/api_services.dart';
import '../models/pakaian_model.dart';
import 'detail_screen.dart';
import 'create_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Pakaian>> _futurePakaian;

  @override
  void initState() {
    super.initState();
    _futurePakaian = ApiService.fetchPakaian();
  }

  Future<void> _refreshData() async {
    setState(() {
      _futurePakaian = ApiService.fetchPakaian();
    });
  }

  // Helper method untuk mendapatkan warna berdasarkan kategori
  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'jacket':
        return Colors.blue[700]!;
      case 't-shirt':
        return Colors.green[600]!;
      case 'sweater':
        return Colors.purple[600]!;
      case 'shirt':
        return Colors.teal[600]!;
      case 'jeans':
        return Colors.indigo[600]!;
      case 'pants':
        return Colors.brown[600]!;
      case 'dress':
        return Colors.pink[400]!;
      default:
        return Colors.orange[600]!;
    }
  }

  // Helper method untuk mendapatkan ikon berdasarkan kategori
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'jacket':
        return Icons.support;
      case 't-shirt':
        return Icons.accessibility_new;
      case 'sweater':
        return Icons.layers;
      case 'shirt':
        return Icons.person;
      case 'jeans':
        return Icons.west;
      case 'pants':
        return Icons.stream;
      case 'dress':
        return Icons.female;
      default:
        return Icons.checkroom;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Pakaian"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
        ],
      ),
      body: FutureBuilder<List<Pakaian>>(
        future: _futurePakaian,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final pakaianList = snapshot.data!;
            if (pakaianList.isEmpty) {
              return const Center(child: Text("Tidak ada data pakaian"));
            }

            pakaianList.sort((a, b) => b.id.compareTo(a.id));

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: pakaianList.length,
                itemBuilder: (context, index) {
                  final p = pakaianList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailScreen(pakaianId: p.id),
                        ),
                      ).then((_) => _refreshData());
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header dengan warna kategori
                          Container(
                            height: 24,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _getCategoryColor(p.category),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                p.category,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                          // Avatar/Image placeholder
                          Expanded(
                            child: Center(
                              child: Icon(
                                _getCategoryIcon(p.category),
                                size: 60,
                                color: _getCategoryColor(p.category),
                              ),
                            ),
                          ),
                          // Item details
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  p.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Rp${p.price}",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 16,
                                    ),
                                    Text(
                                      " ${p.rating}",
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                    const Spacer(),
                                    Text(
                                      "#${p.id}",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Gagal memuat data: ${snapshot.error}",
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: const Text("Coba Lagi"),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateScreen()),
          ).then((_) => _refreshData());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
