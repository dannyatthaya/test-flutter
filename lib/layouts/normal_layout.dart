import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mini_project_flutter/main.dart';
import 'package:mini_project_flutter/states/loading_state.dart';
import 'package:mini_project_flutter/states/title_state.dart';
import 'package:mini_project_flutter/utils/snackbar_util.dart';
import 'package:provider/provider.dart';

class NormalLayout extends StatefulWidget {
  const NormalLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<NormalLayout> createState() => _NormalLayoutState();
}

class _NormalLayoutState extends State<NormalLayout> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: snackBarKey,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Consumer<TitleState>(
                builder: (context, titleState, child) => Text(titleState.title),
              ),
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const SizedBox(
                    height: 88.0,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Text(
                        'Mini Project',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Home'),
                    onTap: () {
                      context.goNamed('home');

                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text('Customer'),
                    enabled:
                        sharedPreferences.getString('API_URL')?.isNotEmpty ??
                            false,
                    onTap: () {
                      context.goNamed('customer.index');

                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.archive),
                    title: const Text('Product'),
                    enabled:
                        sharedPreferences.getString('API_URL')?.isNotEmpty ??
                            false,
                    onTap: () {
                      context.goNamed('product.index');

                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.receipt),
                    title: const Text('Order'),
                    enabled:
                        sharedPreferences.getString('API_URL')?.isNotEmpty ??
                            false,
                    onTap: () {
                      context.goNamed('order.index');

                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    color: Colors.black.withOpacity(0.05),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: widget.child,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (context.watch<LoadingState>().state)
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black54,
              child: Center(
                child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.white,
                  size: 48.0,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
