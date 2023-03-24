import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

String getServerUrl() {
  switch (dotenv.env['ENV']) {
    case 'local':
      if (kIsWeb) {
        return dotenv.env['LOCAL_SERVER']!;
      } else {
        return dotenv.env['LOCAL_SERVER']!.replaceAll('10.0.2.2:', 'localhost');
      }
    case 'dev':
      return dotenv.env['DEV_SERVER']!;
    case 'prod':
      return dotenv.env['PROD_SERVER']!;
    default:
      return dotenv.env['LOCAL_SERVER']!;
  }
}
