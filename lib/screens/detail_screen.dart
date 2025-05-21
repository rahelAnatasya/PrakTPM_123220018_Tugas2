import 'package:flutter/material.dart';
import '../models/pakaian_model.dart';
import '../services/api_services.dart';
import 'edit_screen.dart';

class DetailScreen extends StatelessWidget {
  final Pakaian pakaian;

  const DetailScreen({super.key, required this.pakaian});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pakaian.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${pakaian.name}"),
            Text("Price: ${pakaian.price}"),
            Text("Category: ${pakaian.category}"),
            Text("Rating: ${pakaian.rating}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditScreen(pakaian: pakaian),
                      ),
                    );
                  },
                  child: Text("Edit"),
                ),
                TextButton(
                  onPressed: () async {
                    await ApiService.deletePakaian(pakaian.id);
                    Navigator.pop(context);
                  },
                  child: Text("Hapus", style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
