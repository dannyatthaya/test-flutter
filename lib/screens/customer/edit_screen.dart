import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_project_flutter/apis/customer_api.dart';
import 'package:mini_project_flutter/models/customer_model.dart';
import 'package:mini_project_flutter/models/dio/show_params.model.dart';
import 'package:mini_project_flutter/states/loading_state.dart';
import 'package:mini_project_flutter/states/title_state.dart';
import 'package:mini_project_flutter/utils/snackbar_util.dart';
import 'package:provider/provider.dart';

class CustomerEditScreen extends StatefulWidget {
  const CustomerEditScreen({super.key, required this.id});

  final String id;

  @override
  State<CustomerEditScreen> createState() => _CustomerEditScreenState();
}

class _CustomerEditScreenState extends State<CustomerEditScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  final nameFieldKey = GlobalKey<FormBuilderFieldState>();
  final displayNameFieldKey = GlobalKey<FormBuilderFieldState>();
  final locationFieldKey = GlobalKey<FormBuilderFieldState>();
  final genderFieldKey = GlobalKey<FormBuilderFieldState>();
  final addressFieldKey = GlobalKey<FormBuilderFieldState>();
  final nameFocusNode = FocusNode();
  final displayNameFocusNode = FocusNode();
  final locationFocusNode = FocusNode();
  final genderFocusNode = FocusNode();
  final addressFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      fetchData();
      setTitle();
    });
  }

  void setTitle() {
    context.read<TitleState>().setTitle('Edit Customer');
  }

  Future<void> fetchData() async {
    setTitle();

    CustomerModel? data =
        await CustomerAPI.show(params: ShowParamsModel(id: widget.id));

    formKey.currentState!.patchValue({
      'name': data?.name,
      'displayName': data?.displayName,
      'location': data?.location,
      'gender': data?.gender,
      'address': data?.address,
    });

    setState(() {});
  }

  Future<void> onSubmit() async {
    LoadingState loadingState = getLoadingState();

    try {
      loadingState.showLoading();

      await CustomerAPI.update(CustomerModel.form(
        id: int.parse(widget.id),
        name: nameFieldKey.currentState!.value,
        displayName: displayNameFieldKey.currentState!.value,
        location: locationFieldKey.currentState!.value,
        gender: genderFieldKey.currentState!.value,
        address: addressFieldKey.currentState!.value,
      ));

      showSuccessSnackbar('Request is successful');

      goToIndex();
    } finally {
      loadingState.hideLoading();
    }
  }

  void goToIndex() {
    context.goNamed('customer.index');
  }

  LoadingState getLoadingState() {
    return context.read<LoadingState>();
  }

  void onBlur() {
    nameFocusNode.unfocus();
    displayNameFocusNode.unfocus();
    locationFocusNode.unfocus();
    genderFocusNode.unfocus();
    addressFocusNode.unfocus();
  }

  InputDecoration defaultDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      filled: true,
    );
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
    return GestureDetector(
      onTap: onBlur,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 0.0,
          child: FormBuilder(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          FormBuilderTextField(
                            key: nameFieldKey,
                            name: 'name',
                            focusNode: nameFocusNode,
                            decoration: defaultDecoration(label: 'Identifier'),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          const SizedBox(height: 32.0),
                          FormBuilderTextField(
                            key: displayNameFieldKey,
                            name: 'displayName',
                            focusNode: displayNameFocusNode,
                            decoration: defaultDecoration(
                              label: 'Customer Name',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          const SizedBox(height: 32.0),
                          FormBuilderTextField(
                            key: locationFieldKey,
                            name: 'location',
                            focusNode: locationFocusNode,
                            decoration: defaultDecoration(
                              label: 'Location',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          const SizedBox(height: 32.0),
                          FormBuilderDropdown(
                            key: genderFieldKey,
                            name: 'gender',
                            focusNode: genderFocusNode,
                            decoration: defaultDecoration(
                              label: 'Gender',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                            items: ['F', 'M']
                                .map((gender) => DropdownMenuItem(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      value: gender,
                                      child: Text(formatGender(gender)),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 32.0),
                          FormBuilderTextField(
                            key: addressFieldKey,
                            name: 'address',
                            focusNode: addressFocusNode,
                            decoration: defaultDecoration(
                              label: 'Address',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                        ],
                      ),
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
                        FilledButton.tonal(
                          onPressed: () {
                            context.goNamed('customer.index');
                          },
                          child: const Icon(Icons.chevron_left),
                        ),
                        const SizedBox(width: 8.0),
                        FilledButton.tonal(
                          onPressed: fetchData,
                          child: const Icon(Icons.refresh),
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
