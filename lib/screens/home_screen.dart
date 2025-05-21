import 'package:flutter/material.dart';
import 'package:pakaian_app/services/api_services.dart';
import '../models/pakaian_model.dart';
//import '../services/api_services.dart';
import 'detail_screen.dart';
import 'create_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Pakaian")),
      body: FutureBuilder<List<Pakaian>>(
        future: ApiService.fetchPakaian(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final pakaianList = snapshot.data!;
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: pakaianList.length,
              itemBuilder: (context, index) {
                final p = pakaianList[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(pakaian: p),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          p.name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text("Kategori: ${p.category}"),
                        Text("Harga: ${p.price}"),
                        Text("Rating: ${p.rating}"),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Gagal memuat data"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
