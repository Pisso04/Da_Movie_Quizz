import 'package:da_movie_quizz/src/constants/boxes.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';


Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  // env
  await dotenv.dotenv.load();

  // Init hive
  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);

  // open hive boxes
  await Hive.openBox<String>(BoxNames.quizzes);
}
