import 'package:flutter_dotenv/flutter_dotenv.dart';

String getServerUrl() {
  switch (dotenv.env['ENV']) {
    case 'local':
      return dotenv.env['LOCAL_SERVER']!;
    case 'dev':
      return dotenv.env['DEV_SERVER']!;
    case 'prod':
      return dotenv.env['PROD_SERVER']!;
    default:
      return dotenv.env['LOCAL_SERVER']!;
  }
}
