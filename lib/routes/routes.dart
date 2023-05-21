import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mini_project_flutter/layouts/blank_layout.dart';
import 'package:mini_project_flutter/layouts/normal_layout.dart';
import 'package:mini_project_flutter/screens/customer/create_screen.dart';
import 'package:mini_project_flutter/screens/customer/edit_screen.dart';
import 'package:mini_project_flutter/screens/customer/index_screen.dart';
import 'package:mini_project_flutter/screens/customer/read_screen.dart';
import 'package:mini_project_flutter/screens/home_screen.dart';
import 'package:mini_project_flutter/screens/order/create_screen.dart';
import 'package:mini_project_flutter/screens/order/edit_screen.dart';
import 'package:mini_project_flutter/screens/order/index_screen.dart';
import 'package:mini_project_flutter/screens/order/read_screen.dart';
import 'package:mini_project_flutter/screens/product/create_screen.dart';
import 'package:mini_project_flutter/screens/product/edit_screen.dart';
import 'package:mini_project_flutter/screens/product/index_screen.dart';
import 'package:mini_project_flutter/screens/product/read_screen.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return NormalLayout(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
        ),
        // Customer Route
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return BlankLayout(child: child);
          },
          routes: [
            GoRoute(
              path: '/customer/index',
              name: 'customer.index',
              builder: (BuildContext context, GoRouterState state) {
                return const CustomerIndexScreen();
              },
            ),
            GoRoute(
              path: '/customer/create',
              name: 'customer.create',
              builder: (BuildContext context, GoRouterState state) {
                return const CustomerCreateScreen();
              },
            ),
            GoRoute(
              path: '/customer/:id/edit',
              name: 'customer.edit',
              builder: (BuildContext context, GoRouterState state) {
                return CustomerEditScreen(id: state.pathParameters['id']!);
              },
            ),
            GoRoute(
              path: '/customer/:id/read',
              name: 'customer.read',
              builder: (BuildContext context, GoRouterState state) {
                return CustomerReadScreen(id: state.pathParameters['id']!);
              },
            ),
          ],
        ),
        // Product Route
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return BlankLayout(child: child);
          },
          routes: [
            GoRoute(
              path: '/product/index',
              name: 'product.index',
              builder: (BuildContext context, GoRouterState state) {
                return const ProductIndexScreen();
              },
            ),
            GoRoute(
              path: '/product/create',
              name: 'product.create',
              builder: (BuildContext context, GoRouterState state) {
                return const ProductCreateScreen();
              },
            ),
            GoRoute(
              path: '/product/:id/edit',
              name: 'product.edit',
              builder: (BuildContext context, GoRouterState state) {
                return ProductEditScreen(id: state.pathParameters['id']!);
              },
            ),
            GoRoute(
              path: '/product/:id/read',
              name: 'product.read',
              builder: (BuildContext context, GoRouterState state) {
                return ProductReadScreen(id: state.pathParameters['id']!);
              },
            ),
          ],
        ),
        // Order Route
        ShellRoute(
          builder: (BuildContext context, GoRouterState state, Widget child) {
            return BlankLayout(child: child);
          },
          routes: [
            GoRoute(
              path: '/order/index',
              name: 'order.index',
              builder: (BuildContext context, GoRouterState state) {
                return const OrderIndexScreen();
              },
            ),
            GoRoute(
              path: '/order/create',
              name: 'order.create',
              builder: (BuildContext context, GoRouterState state) {
                return const OrderCreateScreen();
              },
            ),
            GoRoute(
              path: '/order/:id/edit',
              name: 'order.edit',
              builder: (BuildContext context, GoRouterState state) {
                return OrderEditScreen(id: state.pathParameters['id']!);
              },
            ),
            GoRoute(
              path: '/order/:id/read',
              name: 'order.read',
              builder: (BuildContext context, GoRouterState state) {
                return OrderReadScreen(id: state.pathParameters['id']!);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
