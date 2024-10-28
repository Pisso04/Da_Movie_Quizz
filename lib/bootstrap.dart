import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;


Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // env
  await dotenv.dotenv.load();
}
