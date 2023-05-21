import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_project_flutter/apis/product_api.dart';
import 'package:mini_project_flutter/models/product_model.dart';
import 'package:mini_project_flutter/models/dio/show_params.model.dart';
import 'package:mini_project_flutter/states/loading_state.dart';
import 'package:mini_project_flutter/states/title_state.dart';
import 'package:mini_project_flutter/utils/snackbar_util.dart';
import 'package:provider/provider.dart';

class ProductEditScreen extends StatefulWidget {
  const ProductEditScreen({super.key, required this.id});

  final String id;

  @override
  State<ProductEditScreen> createState() => _ProductEditScreenState();
}

class _ProductEditScreenState extends State<ProductEditScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  final nameFieldKey = GlobalKey<FormBuilderFieldState>();
  final displayNameFieldKey = GlobalKey<FormBuilderFieldState>();
  final categoryFieldKey = GlobalKey<FormBuilderFieldState>();
  final priceFieldKey = GlobalKey<FormBuilderFieldState>();
  final nameFocusNode = FocusNode();
  final displayNameFocusNode = FocusNode();
  final categoryFocusNode = FocusNode();
  final priceFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      fetchData();
      setTitle();
    });
  }

  void setTitle() {
    context.read<TitleState>().setTitle('Edit Product');
  }

  Future<void> fetchData() async {
    setTitle();

    ProductModel? data =
        await ProductAPI.show(params: ShowParamsModel(id: widget.id));

    formKey.currentState!.patchValue({
      'name': data?.name,
      'displayName': data?.displayName,
      'category': data?.category,
      'price': data?.price.toString(),
    });

    setState(() {});
  }

  Future<void> onSubmit() async {
    LoadingState loadingState = getLoadingState();

    try {
      loadingState.showLoading();

      await ProductAPI.update(ProductModel.form(
        id: int.parse(widget.id),
        name: nameFieldKey.currentState!.value,
        displayName: displayNameFieldKey.currentState!.value,
        category: categoryFieldKey.currentState!.value,
        price: double.parse(priceFieldKey.currentState!.value),
      ));

      showSuccessSnackbar('Request is successful');

      goToIndex();
    } finally {
      loadingState.hideLoading();
    }
  }

  void goToIndex() {
    context.goNamed('product.index');
  }

  LoadingState getLoadingState() {
    return context.read<LoadingState>();
  }

  void onBlur() {
    nameFocusNode.unfocus();
    displayNameFocusNode.unfocus();
    categoryFocusNode.unfocus();
    priceFocusNode.unfocus();
  }

  InputDecoration defaultDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      filled: true,
    );
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
                              label: 'Product Name',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          const SizedBox(height: 32.0),
                          FormBuilderTextField(
                            key: categoryFieldKey,
                            name: 'category',
                            focusNode: categoryFocusNode,
                            decoration: defaultDecoration(
                              label: 'Category',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          const SizedBox(height: 32.0),
                          FormBuilderTextField(
                            key: priceFieldKey,
                            name: 'price',
                            focusNode: priceFocusNode,
                            keyboardType: TextInputType.number,
                            decoration: defaultDecoration(
                              label: 'Price',
                            ),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                              FormBuilderValidators.numeric(),
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
                            context.goNamed('product.index');
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
