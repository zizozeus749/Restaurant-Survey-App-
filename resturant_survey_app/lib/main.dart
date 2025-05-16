import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:untitled15/user_information.dart';
import 'package:untitled15/selected_meals_page.dart';
import 'home_page.dart';

final cloud = Supabase.instance.client;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://kwombdxzzieovaxexnei.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt3b21iZHh6emllb3ZheGV4bmVpIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY2NTA1MjAsImV4cCI6MjA2MjIyNjUyMH0.UHlQ5nSzl8qPo2QCGk1C5_iDxobJqAYBgBGhQC7FEFo',
  );
  runApp(const MyApp());
  final cloud = Supabase.instance.client;
}

class MyApp extends StatelessWidget {
  const MyApp({key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(home: HomePage());
  }
}
