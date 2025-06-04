import 'package:flutter/material.dart';
import 'package:denicotox/screens/splash.dart';
import 'package:denicotox/providers/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';


//DATABSE 
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox<int>('counter'); // crea/apre il box


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DataProvider>(
      create: (context) => DataProvider(),
      
      child: MaterialApp(
        
        //This specifies the entrypoint
        home: 
        
        Splash(),
        ),

      );

  }
}

