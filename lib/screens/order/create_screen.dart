import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:mini_project_flutter/apis/customer_api.dart';
import 'package:mini_project_flutter/apis/order_api.dart';
import 'package:mini_project_flutter/apis/product_api.dart';
import 'package:mini_project_flutter/main.dart';
import 'package:mini_project_flutter/models/customer_model.dart';
import 'package:mini_project_flutter/models/dio/index_params_model.dart';
import 'package:mini_project_flutter/models/dio/index_response_model.dart';
import 'package:mini_project_flutter/models/order_model.dart';
import 'package:mini_project_flutter/models/order_product_model.dart';
import 'package:mini_project_flutter/models/product_model.dart';
import 'package:mini_project_flutter/states/loading_state.dart';
import 'package:mini_project_flutter/states/title_state.dart';
import 'package:mini_project_flutter/utils/snackbar_util.dart';
import 'package:provider/provider.dart';

class OrderCreateScreen extends StatefulWidget {
  const OrderCreateScreen({super.key});

  @override
  State<OrderCreateScreen> createState() => _OrderCreateScreenState();
}

class _OrderCreateScreenState extends State<OrderCreateScreen> {
  final formKey = GlobalKey<FormBuilderState>();
  final customerFieldKey = GlobalKey<FormBuilderFieldState>();
  final customerFocusNode = FocusNode();
  List<CustomerModel> customers = [];
  List<OrderProductModel> products = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      setTitle();
    });
  }

  void setTitle() {
    context.read<TitleState>().setTitle('Create Order');
  }

  Future<void> onSubmit() async {
    LoadingState loadingState = getLoadingState();

    try {
      loadingState.showLoading();

      if (products.isEmpty) {
        showErrorSnackbar('Must have at least one product');
      }

      await OrderAPI.store(OrderModel.form(
        orderProducts: products,
        customer: customers.firstWhere((customer) =>
            customer.displayName == customerFieldKey.currentState!.value),
      ));

      showSuccessSnackbar('Request is successful');

      goToIndex();
    } finally {
      loadingState.hideLoading();
    }
  }

  Future<void> fetchCustomer(String search) async {
    IndexResponseModel response =
        await CustomerAPI.index(params: IndexParamsModel(search: search));

    customers = response.data;
  }

  void goToIndex() {
    context.goNamed('order.index');
  }

  LoadingState getLoadingState() {
    return context.read<LoadingState>();
  }

  void onBlur() {
    customerFocusNode.unfocus();
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

  void onProductAdd(OrderProductModel product) {
    products.add(product);

    Logger().d(products.map((e) => e.toJson()).toList());

    setState(() {});
  }

  void onProductDelete(int id) {
    products.removeWhere((product) => product.product.id == id);

    setState(() {});
  }

  String getSubtotal() {
    return currencyFormat.format(products.fold(0.0,
        (previousValue, e) => previousValue + (e.product.price * e.quantity)));
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          FormBuilderTypeAhead<String>(
                            key: customerFieldKey,
                            name: 'customer',
                            focusNode: customerFocusNode,
                            decoration: defaultDecoration(label: 'Customer'),
                            itemBuilder: (BuildContext context, customer) =>
                                ListTile(title: Text(customer)),
                            noItemsFoundBuilder: (context) => Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'No item found.',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(color: Colors.black38),
                              ),
                            ),
                            suggestionsCallback: (String query) async {
                              if (query.isNotEmpty) {
                                var lowercaseQuery = query.toLowerCase();

                                await fetchCustomer(query);

                                if (customers.isNotEmpty) {
                                  return customers
                                      .map((e) => e.displayName)
                                      .where((customer) {
                                    return customer
                                        .toLowerCase()
                                        .contains(lowercaseQuery);
                                  }).toList(growable: false)
                                    ..sort((a, b) => a
                                        .toLowerCase()
                                        .indexOf(lowercaseQuery)
                                        .compareTo(b
                                            .toLowerCase()
                                            .indexOf(lowercaseQuery)));
                                }
                              }

                              return customers
                                  .map((e) => e.displayName)
                                  .toList();
                            },
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(),
                            ]),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Products',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              FilledButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AddDialogWidget(
                                      onSubmit: onProductAdd,
                                    ),
                                  );
                                },
                                child: const Icon(Icons.add),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          ...products
                              .map((e) => SizedBox(
                                    height: 70,
                                    child: ItemCard(
                                      orderProduct: e,
                                      onDelete: onProductDelete,
                                    ),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    right: 8.0,
                    left: 8.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SUBTOTAL:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      Text(
                        getSubtotal(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FilledButton.tonal(
                          onPressed: () {
                            context.goNamed('order.index');
                          },
                          child: const Icon(Icons.chevron_left),
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

class AddDialogWidget extends StatefulWidget {
  const AddDialogWidget({super.key, required this.onSubmit});

  final Function(OrderProductModel) onSubmit;

  @override
  State<AddDialogWidget> createState() => _AddDialogWidgetState();
}

class _AddDialogWidgetState extends State<AddDialogWidget> {
  final formKey = GlobalKey<FormBuilderState>();
  final productFieldKey = GlobalKey<FormBuilderFieldState>();
  final quantityFieldKey = GlobalKey<FormBuilderFieldState>();
  List<ProductModel> products = [];

  InputDecoration defaultDecoration({required String label}) {
    return InputDecoration(
      labelText: label,
      isDense: true,
      filled: true,
    );
  }

  Future<void> fetchProducts(String search) async {
    IndexResponseModel response =
        await ProductAPI.index(params: IndexParamsModel(search: search));

    products = response.data;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Product',
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      content: FormBuilder(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormBuilderTypeAhead<String>(
              key: productFieldKey,
              name: 'product',
              decoration: defaultDecoration(label: 'Product'),
              itemBuilder: (BuildContext context, product) =>
                  ListTile(title: Text(product)),
              noItemsFoundBuilder: (context) => Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'No item found.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.black38),
                ),
              ),
              suggestionsCallback: (String query) async {
                if (query.isNotEmpty) {
                  var lowercaseQuery = query.toLowerCase();

                  await fetchProducts(query);

                  if (products.isNotEmpty) {
                    return products.map((e) => e.displayName).where((product) {
                      return product.toLowerCase().contains(lowercaseQuery);
                    }).toList(growable: false)
                      ..sort((a, b) => a
                          .toLowerCase()
                          .indexOf(lowercaseQuery)
                          .compareTo(b.toLowerCase().indexOf(lowercaseQuery)));
                  }
                }

                return products.map((e) => e.displayName).toList();
              },
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
            const SizedBox(height: 32.0),
            FormBuilderTextField(
              key: quantityFieldKey,
              name: 'quantity',
              keyboardType: TextInputType.number,
              decoration: defaultDecoration(
                label: 'Quantity',
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
              ]),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton.tonal(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('CANCEL'),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState!.validate(
              autoScrollWhenFocusOnInvalid: true,
              focusOnInvalid: true,
            )) {
              formKey.currentState!.save();
              widget.onSubmit(
                OrderProductModel.form(
                  product: products.firstWhere(
                    (product) =>
                        product.displayName ==
                        productFieldKey.currentState!.value,
                  ),
                  quantity: int.parse(quantityFieldKey.currentState!.value),
                ),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('ADD'),
        ),
      ],
    );
  }
}

class ItemCard extends StatefulWidget {
  const ItemCard({
    super.key,
    required this.orderProduct,
    required this.onDelete,
  });

  final OrderProductModel orderProduct;
  final Function(int id) onDelete;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: const BorderSide(color: Colors.black12)),
      elevation: 0.0,
      child: Container(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              padding: const EdgeInsets.all(12.0),
              width: 64,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                ),
                color: Colors.blue[200],
              ),
              child: const Icon(
                Icons.archive,
                size: 32.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        widget.orderProduct.product.displayName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                    Text(
                      '${widget.orderProduct.quantity.toString()} pcs',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(32, 32),
                padding: const EdgeInsets.all(0.0),
              ),
              onPressed: () => widget.onDelete(widget.orderProduct.product.id),
              child: const Icon(
                Icons.delete,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
