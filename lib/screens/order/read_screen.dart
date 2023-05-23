import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_project_flutter/apis/order_api.dart';
import 'package:mini_project_flutter/main.dart';
import 'package:mini_project_flutter/models/dio/show_params.model.dart';
import 'package:mini_project_flutter/models/order_model.dart';
import 'package:mini_project_flutter/states/title_state.dart';
import 'package:provider/provider.dart';

class OrderReadScreen extends StatefulWidget {
  const OrderReadScreen({super.key, required this.id});

  final String id;

  @override
  State<OrderReadScreen> createState() => _OrderReadScreenState();
}

class _OrderReadScreenState extends State<OrderReadScreen> {
  OrderModel? data;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      fetchData();
      setTitle();
    });
  }

  void setTitle() {
    context.read<TitleState>().setTitle('Order Detail');
  }

  Future<void> fetchData() async {
    setTitle();

    data = await OrderAPI.show(params: ShowParamsModel(id: widget.id));

    setState(() {});
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
                      title: const Text('Customer ID'),
                      subtitle: Text(data?.customer?.name ?? ''),
                    ),
                    ListTile(
                      title: const Text('Customer Name'),
                      subtitle: Text(data?.customer?.displayName ?? ''),
                    ),
                    ListTile(
                      title: const Text('Customer Address'),
                      subtitle: Text(data?.customer?.address ?? ''),
                    ),
                    ...?data?.products
                        ?.map(
                          (e) => ListTile(
                            title: Text(e.displayName),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(e.color),
                                Text(currencyFormat.format(e.price)),
                              ],
                            ),
                            trailing: Text('${e.quantity} pcs'),
                          ),
                        )
                        .toList(),
                    ListTile(
                      title: const Text('Subtotal'),
                      subtitle:
                          Text(currencyFormat.format(data?.subtotal ?? 0)),
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
                          context.goNamed('order.index');
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
                        context.goNamed('order.edit', pathParameters: {
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
