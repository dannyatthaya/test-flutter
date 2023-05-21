import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_project_flutter/apis/customer_api.dart';
import 'package:mini_project_flutter/models/customer_model.dart';
import 'package:mini_project_flutter/models/dio/index_params_model.dart';
import 'package:mini_project_flutter/models/dio/index_response_model.dart';
import 'package:mini_project_flutter/models/pagination/pagination_model.dart';
import 'package:mini_project_flutter/models/dio/show_params.model.dart';
import 'package:mini_project_flutter/states/loading_state.dart';
import 'package:mini_project_flutter/states/title_state.dart';
import 'package:mini_project_flutter/utils/confirm_dialog_util.dart';
import 'package:mini_project_flutter/utils/snackbar_util.dart';
import 'package:pagination_flutter/pagination.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

class CustomerIndexScreen extends StatefulWidget {
  const CustomerIndexScreen({super.key});

  @override
  State<CustomerIndexScreen> createState() => _CustomerIndexScreenState();
}

class _CustomerIndexScreenState extends State<CustomerIndexScreen> {
  PaginationModel? paginationModel;
  List<CustomerModel> data = [];
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
    context.read<TitleState>().setTitle('Customers');
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

      IndexResponseModel<List<CustomerModel>> response =
          await CustomerAPI.index(
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
                'List of Customers',
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
                      onPressed: () => context.goNamed('customer.create'),
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
                  .map((customer) =>
                      ItemCard(customer: customer, onDelete: fetchData))
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
  const ItemCard({super.key, required this.customer, required this.onDelete});

  final CustomerModel customer;
  final VoidCallback onDelete;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  Future<void> deleteData({required String id}) async {
    await CustomerAPI.destroy(params: ShowParamsModel(id: id));

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
                      context.goNamed('customer.read', pathParameters: {
                        'id': widget.customer.id.toString(),
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
                      context.goNamed('customer.edit', pathParameters: {
                        'id': widget.customer.id.toString(),
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
                          deleteData(id: widget.customer.id.toString());
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
                  Icons.people,
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
                          widget.customer.displayName,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ),
                      Text(
                        widget.customer.location,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                      Text(
                        widget.customer.gender == 'F' ? 'Female' : 'Male',
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
