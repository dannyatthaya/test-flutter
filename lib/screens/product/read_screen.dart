import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_project_flutter/apis/product_api.dart';
import 'package:mini_project_flutter/main.dart';
import 'package:mini_project_flutter/models/product_model.dart';
import 'package:mini_project_flutter/models/dio/show_params.model.dart';
import 'package:mini_project_flutter/states/title_state.dart';
import 'package:provider/provider.dart';

class ProductReadScreen extends StatefulWidget {
  const ProductReadScreen({super.key, required this.id});

  final String id;

  @override
  State<ProductReadScreen> createState() => _ProductReadScreenState();
}

class _ProductReadScreenState extends State<ProductReadScreen> {
  ProductModel? data;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      fetchData();
      setTitle();
    });
  }

  void setTitle() {
    context.read<TitleState>().setTitle('Product Detail');
  }

  Future<void> fetchData() async {
    setTitle();

    data = await ProductAPI.show(params: ShowParamsModel(id: widget.id));

    setState(() {});
  }

  String formatGender(String? gender) {
    if (gender == 'F') {
      return 'Female';
    } else if (gender == 'M') {
      return 'Male';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 0.0,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Product ID'),
                      subtitle: Text(data?.name ?? ''),
                    ),
                    ListTile(
                      title: const Text('Product Name'),
                      subtitle: Text(data?.displayName ?? ''),
                    ),
                    ListTile(
                      title: const Text('Category'),
                      subtitle: Text(data?.category ?? ''),
                    ),
                    ListTile(
                      title: const Text('Price'),
                      subtitle: Text(currencyFormat.format(data?.price ?? 0)),
                    ),
                    ListTile(
                      title: const Text('Created At'),
                      subtitle: Text(
                          dateFormat.format(data?.createdAt ?? DateTime.now())),
                    ),
                    ListTile(
                      title: const Text('Updated At'),
                      subtitle: Text(
                          dateFormat.format(data?.updatedAt ?? DateTime.now())),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          context.goNamed('product.index');
                        },
                        icon: const Icon(Icons.chevron_left),
                        label: const Text('GO BACK'),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    FilledButton.tonal(
                      onPressed: fetchData,
                      child: const Icon(Icons.refresh),
                    ),
                    const SizedBox(width: 8.0),
                    FilledButton.tonal(
                      onPressed: () {
                        context.goNamed('product.edit', pathParameters: {
                          'id': widget.id,
                        });
                      },
                      child: const Icon(Icons.edit),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
