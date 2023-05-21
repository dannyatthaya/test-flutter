import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_project_flutter/main.dart';
import 'package:mini_project_flutter/utils/snackbar_util.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  final urlFieldKey = GlobalKey<FormBuilderFieldState>();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      formKey.currentState?.patchValue({
        'url': sharedPreferences.getString('API_URL'),
      });
    });
  }

  InputDecoration defaultDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      filled: true,
    );
  }

  void onSubmit() {
    sharedPreferences.setString(
      'API_URL',
      urlFieldKey.currentState!.value,
    );

    setState(() {});

    showSuccessSnackbar('URL is saved successfully');
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Welcome to',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Text(
              'the Mini Project',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32.0,
              ),
              child: FormBuilder(
                key: formKey,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      key: urlFieldKey,
                      name: 'url',
                      decoration: defaultDecoration(label: 'API URL'),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.url(),
                      ]),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () {
                          if (formKey.currentState!.validate(
                            autoScrollWhenFocusOnInvalid: true,
                            focusOnInvalid: true,
                          )) {
                            onSubmit();
                          } else {
                            showErrorSnackbar('Form is invalid');
                          }
                        },
                        icon: const Icon(Icons.save),
                        label: const Text('SUBMIT'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            FilledButton(
              onPressed:
                  sharedPreferences.getString('API_URL')?.isNotEmpty ?? false
                      ? () {
                          context.goNamed('customer.index');
                        }
                      : null,
              style: FilledButton.styleFrom(elevation: 0.0),
              child: const Text('Go to Customer Page'),
            ),
            FilledButton(
              onPressed:
                  sharedPreferences.getString('API_URL')?.isNotEmpty ?? false
                      ? () {
                          context.goNamed('product.index');
                        }
                      : null,
              style: FilledButton.styleFrom(elevation: 0.0),
              child: const Text('Go to Product Page'),
            ),
            FilledButton(
              onPressed:
                  sharedPreferences.getString('API_URL')?.isNotEmpty ?? false
                      ? () {
                          context.goNamed('order.index');
                        }
                      : null,
              style: FilledButton.styleFrom(elevation: 0.0),
              child: const Text('Go to Order Page'),
            ),
          ],
        ),
      ),
    );
  }
}
