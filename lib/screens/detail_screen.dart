import 'package:flutter/material.dart';
import '../models/pakaian_model.dart';
import '../services/api_services.dart';
import 'edit_screen.dart';

class DetailScreen extends StatefulWidget {
  final int pakaianId;

  const DetailScreen({super.key, required this.pakaianId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<Pakaian> _futurePakaian;

  @override
  void initState() {
    super.initState();
    _loadPakaianData();
  }

  // Metode untuk memuat ulang data
  void _loadPakaianData() {
    setState(() {
      _futurePakaian = ApiService.fetchDetail(widget.pakaianId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pakaian")),
      body: FutureBuilder<Pakaian>(
        future: _futurePakaian,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final pakaian = snapshot.data!;
            // Debugging
            print("Material dari API: '${pakaian.material}'");

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailItem("ID", pakaian.id.toString()),
                  _buildDetailItem("Name", pakaian.name),
                  _buildDetailItem("Price", "Rp${pakaian.price}"),
                  _buildDetailItem("Category", pakaian.category),
                  _buildDetailItem("Brand", pakaian.brand),
                  _buildDetailItem("Sold", pakaian.sold.toString()),
                  _buildDetailItem("Rating", "${pakaian.rating} ⭐"),
                  _buildDetailItem("Stock", pakaian.stock.toString()),
                  _buildDetailItem(
                    "Year Released",
                    pakaian.yearReleased.toString(),
                  ),
                  _buildDetailItem(
                    "Material",
                    pakaian.material.isEmpty
                        ? "Tidak tersedia"
                        : pakaian.material,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditScreen(pakaian: pakaian),
                            ),
                          ).then(
                            (_) => _loadPakaianData(),
                          ); // Refresh data setelah kembali dari EditScreen
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text("Edit"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _showDeleteConfirmation(context);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Hapus"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Konfirmasi Hapus"),
            content: Text(
              "Apakah Anda yakin ingin menghapus '${widget.pakaianId}'?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(ctx); // Close dialog
                  try {
                    await ApiService.deletePakaian(widget.pakaianId);
                    Navigator.pop(context); // Return to home
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pakaian berhasil dihapus")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Gagal menghapus: $e")),
                    );
                  }
                },
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
