import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_project_flutter/apis/product_api.dart';
import 'package:mini_project_flutter/main.dart';
import 'package:mini_project_flutter/models/dio/index_params_model.dart';
import 'package:mini_project_flutter/models/dio/index_response_model.dart';
import 'package:mini_project_flutter/models/pagination/pagination_model.dart';
import 'package:mini_project_flutter/models/product_model.dart';
import 'package:mini_project_flutter/models/dio/show_params.model.dart';
import 'package:mini_project_flutter/states/loading_state.dart';
import 'package:mini_project_flutter/states/title_state.dart';
import 'package:mini_project_flutter/utils/confirm_dialog_util.dart';
import 'package:mini_project_flutter/utils/snackbar_util.dart';
import 'package:pagination_flutter/pagination.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class ProductIndexScreen extends StatefulWidget {
  const ProductIndexScreen({super.key});

  @override
  State<ProductIndexScreen> createState() => _ProductIndexScreenState();
}

class _ProductIndexScreenState extends State<ProductIndexScreen> {
  PaginationModel? paginationModel;
  List<ProductModel> data = [];
  int selectedPage = 1;

  setSelectedPage(int index) async {
    setState(() {
      selectedPage = index;
    });

    await fetchData();
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      fetchData();
      setTitle();
    });
  }

  void setTitle() {
    context.read<TitleState>().setTitle('Products');
  }

  LoadingState getLoadingState() {
    return context.read<LoadingState>();
  }

  Future<void> fetchData() async {
    LoadingState loadingState = getLoadingState();

    try {
      loadingState.showLoading();

      setState(() {
        data.clear();
      });

      IndexResponseModel<List<ProductModel>> response = await ProductAPI.index(
        params: IndexParamsModel(
          page: selectedPage,
        ),
      );

      data = response.data;
      paginationModel = response.pagination;

      setState(() {});
    } finally {
      loadingState.hideLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'List of Products',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilledButton.tonal(
                      onPressed: fetchData,
                      child: const Icon(Icons.refresh),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                      onPressed: () => context.goNamed('product.create'),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ResponsiveGridList(
              horizontalGridSpacing: 8,
              verticalGridSpacing: 8,
              minItemWidth: 300,
              minItemsPerRow: 1,
              maxItemsPerRow: 1,
              listViewBuilderOptions: ListViewBuilderOptions(),
              children: data
                  .map((product) =>
                      ItemCard(product: product, onDelete: fetchData))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8.0),
          Pagination(
            numOfPages: paginationModel?.lastPage ?? 1,
            selectedPage: selectedPage,
            pagesVisible: 3,
            onPageChanged: setSelectedPage,
            nextIcon: const Icon(
              Icons.chevron_right_rounded,
              color: Colors.blueAccent,
              size: 20,
            ),
            previousIcon: const Icon(
              Icons.chevron_left_rounded,
              color: Colors.blueAccent,
              size: 20,
            ),
            activeTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
            activeBtnStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              shape: MaterialStateProperty.all(const CircleBorder()),
            ),
            inactiveBtnStyle: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.secondaryContainer,
              ),
              shape: MaterialStateProperty.all(const CircleBorder()),
            ),
            inactiveTextStyle: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  const ItemCard({super.key, required this.product, required this.onDelete});

  final ProductModel product;
  final VoidCallback onDelete;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  Future<void> deleteData({required String id}) async {
    await ProductAPI.destroy(params: ShowParamsModel(id: id));

    showSuccessSnackbar('Request is successful');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: Colors.white,
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0.0),
                children: [
                  InkWell(
                    customBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      context.goNamed('product.read', pathParameters: {
                        'id': widget.product.id.toString(),
                      });
                    },
                    splashColor: Colors.blueAccent,
                    child: const ListTile(
                      leading: Icon(Icons.visibility),
                      title: Text('Read'),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const Text('Edit'),
                    onTap: () {
                      context.goNamed('product.edit', pathParameters: {
                        'id': widget.product.id.toString(),
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text('Delete'),
                    onTap: () {
                      showConfirmDialog(
                        context,
                        title: 'Confirmation',
                        subtitle:
                            'Are you sure want to delete this row? This action cannot be undone!',
                        yesButtonText: 'DELETE',
                        onYes: () {
                          deleteData(id: widget.product.id.toString());
                          widget.onDelete();
                        },
                      );
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      borderRadius: BorderRadius.circular(16.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        child: Container(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                width: 100,
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
                  size: 48.0,
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
                          widget.product.displayName,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      Text(
                        widget.product.category,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        currencyFormat.format(widget.product.price),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
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
    );
  }
}
