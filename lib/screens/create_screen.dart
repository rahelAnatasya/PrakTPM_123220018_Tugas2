import 'package:flutter/material.dart';
import '../models/pakaian_model.dart';
import '../services/api_services.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  State<CreateScreen> createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', category = '', brand = '', material = '';
  int price = 0, sold = 0, stock = 0, yearReleased = DateTime.now().year;
  double rating = 0.0;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Pakaian')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  onChanged: (val) => name = val,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  onChanged: (val) => price = int.tryParse(val) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Category'),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  onChanged: (val) => category = val,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Brand'),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  onChanged: (val) => brand = val,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Sold'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  onChanged: (val) => sold = int.tryParse(val) ?? 0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Rating (0-5)'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v?.isEmpty == true) return 'Required';
                    final value = double.tryParse(v!);
                    if (value == null) return 'Must be a number';
                    if (value < 0 || value > 5)
                      return 'Must be between 0 and 5';
                    return null;
                  },
                  onChanged: (val) => rating = double.tryParse(val) ?? 0.0,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Stock'),
                  keyboardType: TextInputType.number,
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  onChanged: (val) => stock = int.tryParse(val) ?? 0,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Year Released (2018-${DateTime.now().year})',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v?.isEmpty == true) return 'Required';
                    final value = int.tryParse(v!);
                    if (value == null) return 'Must be a number';
                    if (value < 2018 || value > DateTime.now().year) {
                      return 'Must be between 2018 and ${DateTime.now().year}';
                    }
                    return null;
                  },
                  onChanged:
                      (val) =>
                          yearReleased =
                              int.tryParse(val) ?? DateTime.now().year,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Material'),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                  onChanged: (val) => material = val,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Simpan'),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });

      // Store the context before async gap
      final currentContext = context;
      try {
        // Note: Passing 0 as ID since the backend will generate it
        await ApiService.createPakaian(
          Pakaian(
            id: 0, // Backend will generate ID
            name: name,
            price: price,
            category: category,
            brand: brand,
            sold: sold,
            rating: rating,
            stock: stock,
            yearReleased: yearReleased,
            material: material,
          ),
        );

        // Check if the widget is still in the tree after the async gap
        if (mounted) {
          ScaffoldMessenger.of(currentContext).showSnackBar(
            const SnackBar(content: Text('Pakaian berhasil ditambahkan')),
          );
          Navigator.pop(currentContext);
        }
      } catch (e) {
        // Check if the widget is still mounted before showing error
        if (!mounted) return;

        ScaffoldMessenger.of(
          currentContext,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}
