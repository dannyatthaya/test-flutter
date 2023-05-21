import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mini_project_flutter/states/title_state.dart';
import 'package:provider/provider.dart';
import 'package:mini_project_flutter/routes/routes.dart';
import 'package:mini_project_flutter/states/loading_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPreferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sharedPreferences = await SharedPreferences.getInstance();

  runApp(const MyApp());
}

final currencyFormat = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp',
  decimalDigits: 0,
);

final dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoadingState()),
        ChangeNotifierProvider(create: (context) => TitleState()),
      ],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        routerConfig: router,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
      ),
    );
  }
}
