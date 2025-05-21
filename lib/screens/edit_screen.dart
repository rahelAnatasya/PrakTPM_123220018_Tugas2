import 'package:flutter/material.dart';
import '../models/pakaian_model.dart';
import '../services/api_services.dart';

class EditScreen extends StatefulWidget {
  final Pakaian pakaian;

  const EditScreen({super.key, required this.pakaian});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController nameController;
  late TextEditingController priceController;
  late TextEditingController categoryController;
  late TextEditingController brandController;
  late TextEditingController soldController;
  late TextEditingController ratingController;
  late TextEditingController stockController;
  late TextEditingController yearReleasedController;
  late TextEditingController materialController;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.pakaian.name);
    priceController = TextEditingController(
      text: widget.pakaian.price.toString(),
    );
    categoryController = TextEditingController(text: widget.pakaian.category);
    brandController = TextEditingController(text: widget.pakaian.brand);
    soldController = TextEditingController(
      text: widget.pakaian.sold.toString(),
    );
    ratingController = TextEditingController(
      text: widget.pakaian.rating.toString(),
    );
    stockController = TextEditingController(
      text: widget.pakaian.stock.toString(),
    );
    yearReleasedController = TextEditingController(
      text: widget.pakaian.yearReleased.toString(),
    );
    materialController = TextEditingController(text: widget.pakaian.material);
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    categoryController.dispose();
    brandController.dispose();
    soldController.dispose();
    ratingController.dispose();
    stockController.dispose();
    yearReleasedController.dispose();
    materialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Pakaian')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                          validator:
                              (v) => v?.isEmpty == true ? 'Required' : null,
                        ),
                        TextFormField(
                          controller: priceController,
                          decoration: InputDecoration(labelText: 'Price'),
                          keyboardType: TextInputType.number,
                          validator:
                              (v) => v?.isEmpty == true ? 'Required' : null,
                        ),
                        TextFormField(
                          controller: categoryController,
                          decoration: InputDecoration(labelText: 'Category'),
                          validator:
                              (v) => v?.isEmpty == true ? 'Required' : null,
                        ),
                        TextFormField(
                          controller: brandController,
                          decoration: InputDecoration(labelText: 'Brand'),
                          validator:
                              (v) => v?.isEmpty == true ? 'Required' : null,
                        ),
                        TextFormField(
                          controller: soldController,
                          decoration: InputDecoration(labelText: 'Sold'),
                          keyboardType: TextInputType.number,
                          validator:
                              (v) => v?.isEmpty == true ? 'Required' : null,
                        ),
                        TextFormField(
                          controller: ratingController,
                          decoration: InputDecoration(
                            labelText: 'Rating (0-5)',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v?.isEmpty == true) return 'Required';
                            final value = double.tryParse(v!);
                            if (value == null) return 'Must be a number';
                            if (value < 0 || value > 5)
                              return 'Must be between 0 and 5';
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: stockController,
                          decoration: InputDecoration(labelText: 'Stock'),
                          keyboardType: TextInputType.number,
                          validator:
                              (v) => v?.isEmpty == true ? 'Required' : null,
                        ),
                        TextFormField(
                          controller: yearReleasedController,
                          decoration: InputDecoration(
                            labelText:
                                'Year Released (2018-${DateTime.now().year})',
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
                        ),
                        TextFormField(
                          controller: materialController,
                          decoration: InputDecoration(labelText: 'Material'),
                          validator:
                              (v) => v?.isEmpty == true ? 'Required' : null,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _updatePakaian,
                          child: Text('Update'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }

  Future<void> _updatePakaian() async {
    if (_formKey.currentState?.validate() == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        final updated = Pakaian(
          id: widget.pakaian.id,
          name: nameController.text,
          price: int.parse(priceController.text),
          category: categoryController.text,
          brand: brandController.text,
          sold: int.parse(soldController.text),
          rating: double.parse(ratingController.text),
          stock: int.parse(stockController.text),
          yearReleased: int.parse(yearReleasedController.text),
          material: materialController.text,
        );

        await ApiService.updatePakaian(widget.pakaian.id, updated);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pakaian berhasil diperbarui')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        }
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
