import 'package:flutter/material.dart';
import 'services/db.dart';
import 'news.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(FlutterNews());
}
