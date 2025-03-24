// const openWeatherAPIKey=  'ee5180ad1d2687ebf2f5ff5e906a6c99';

import 'package:flutter_dotenv/flutter_dotenv.dart';

final openWeatherAPIKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
