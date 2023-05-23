import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_project_flutter/apis/customer_api.dart';
import 'package:mini_project_flutter/main.dart';
import 'package:mini_project_flutter/models/customer_model.dart';
import 'package:mini_project_flutter/models/dio/show_params.model.dart';
import 'package:mini_project_flutter/states/title_state.dart';
import 'package:provider/provider.dart';

class CustomerReadScreen extends StatefulWidget {
  const CustomerReadScreen({super.key, required this.id});

  final String id;

  @override
  State<CustomerReadScreen> createState() => _CustomerReadScreenState();
}

class _CustomerReadScreenState extends State<CustomerReadScreen> {
  CustomerModel? data;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      fetchData();
      setTitle();
    });
  }

  void setTitle() {
    context.read<TitleState>().setTitle('Customer Detail');
  }

  Future<void> fetchData() async {
    setTitle();

    data = await CustomerAPI.show(params: ShowParamsModel(id: widget.id));

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
                      title: const Text('Customer ID'),
                      subtitle: Text(data?.name ?? ''),
                    ),
                    ListTile(
                      title: const Text('Customer Name'),
                      subtitle: Text(data?.displayName ?? ''),
                    ),
                    ListTile(
                      title: const Text('Location'),
                      subtitle: Text(data?.location ?? ''),
                    ),
                    ListTile(
                      title: const Text('Gender'),
                      subtitle: Text(formatGender(data?.gender)),
                    ),
                    ListTile(
                      title: const Text('Address'),
                      subtitle: Text(data?.address ?? ''),
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
                          context.goNamed('customer.index');
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
                        context.goNamed('customer.edit', pathParameters: {
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
