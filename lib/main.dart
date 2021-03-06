import 'package:flutter/material.dart';
import 'package:flutter_stetho/flutter_stetho.dart';
import 'package:tagros_comptes/bloc/bloc_provider.dart';
import 'package:tagros_comptes/bloc/entry_db_bloc.dart';
import 'package:tagros_comptes/bloc/game_db_bloc.dart';
import 'package:tagros_comptes/data/database_moor.dart';
import 'package:tagros_comptes/model/game_with_players.dart';
import 'package:tagros_comptes/screen/add_modify.dart';
import 'package:tagros_comptes/screen/menu.dart';
import 'package:tagros_comptes/screen/tableau.dart';
import 'package:tagros_comptes/screen/test_native.dart';

void main() {
  Stetho.initialize();
  runApp(MyApp());
}
//
//void _runAppSpector() {
//  var config = Config();
//  config.androidApiKey =
//      "android_YjE3ODM3ZDctZTdiMC00ZjRlLWJiMWMtZTJjOTg2ZjNjZjEz";
//  AppSpectorPlugin.run(config);
//}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(bloc: GameDbBloc(), child: MenuScreen()),
      routes: <String, WidgetBuilder>{
        MenuScreen.routeName: (context) => MenuScreen(),
        TestNative.routeName: (context) => TestNative(),
        AddModifyEntry.routeName: (context) => AddModifyEntry(),
      },
    );
  }
}

Future<T> navigateToTableau<T>(BuildContext context,
    {@required GameWithPlayers game}) async {
  if (game.game.id == null) {
    var idGame = await MyDatabase.db.newGame(game);
    game.game = game.game.copyWith(id: idGame);
  }
  return Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => BlocProvider(
            bloc: EntriesDbBloc(game),
            child: TableauPage(
              game: game,
            ),
          )));
}
