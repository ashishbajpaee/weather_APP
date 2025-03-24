import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:weather_app/aditional_info_item.dart';
import 'package:weather_app/secrets.dart';
import 'dart:ui';
import 'package:weather_app/weather_forecast_item.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String,dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityName = 'London';


      String apiKey = dotenv.env['OPENWEATHER_API_KEY'] ?? '';
      
      if (apiKey.isEmpty) throw 'API Key is missing. Check .env file.';



//       final res = await http.get(
//         // Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),
//  Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$apiKey'),
     

//       );

final res = await http.get(
  Uri.parse('https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),
);


      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected Error occurred';
      }
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState(){
    super.initState();
    weather= getCurrentWeather();
  }
    
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather=getCurrentWeather();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            final temp = data['list'][0]['main']['temp'];
            final currentSky = data['list'][0]['weather'][0]['main'];
            final pressure= data['list'][0]['main']['pressure'];
            final windSpeed= data['list'][0]['wind']['speed'];
            final humidity= data['list'][0]['main']['humidity'];


            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 20,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$temp K',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                 Icon(
                                  currentSky =='Clouds'|| currentSky=='Rain'
                                  ?Icons.cloud
                                  :Icons.sunny,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  '$currentSky',
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  //  SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       for(int i=0; i<5 ;i++)
                  //       HourlyForeCastItem(
                  //         time: data['list'][i+1]['dt'].toString(),
                          // icon:data['list'][i+1]['weather'][0]['main']== "Clouds" || 
                          // data['list'][i+1]['weather'][0]['main']== "Rain" ? 
                          // Icons.cloud
                          // :Icons.sunny,
                  //         temperature: data['list'][i+1]['main']['temp'].toString(),
                  //       ),




                        // HourlyForeCastItem(
                        //   time: '03.00',
                        //   icon: Icons.sunny,
                        //   temperature: '300.52',
                        // ),
                        // HourlyForeCastItem(
                        //   time: '06.00',
                        //   icon: Icons.cloud,
                        //   temperature: '301.22',
                        // ),
                        // HourlyForeCastItem(
                        //   time: '09.00',
                        //   icon: Icons.sunny,
                        //   temperature: '300.12',
                        // ),
                        // HourlyForeCastItem(
                        //   time: '12.00',
                        //   icon: Icons.cloud,
                        //   temperature: '304.12',
                        // ),



                  //     ],
                  //   ),
                  // ),

              SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: 5,
                  scrollDirection: Axis.horizontal ,
                  itemBuilder: (context ,index){
                    final hourlyForecast= data['list'][index+1];
                    final time=DateTime.parse( hourlyForecast['dt_txt']);
                    return HourlyForeCastItem(
                      time: DateFormat.j().format(time),
                      temperature: hourlyForecast['main']['temp'].toString(),
                      icon: data['list'][index+1]['weather'][0]['main']== "Clouds" || 
                            data['list'][index+  1]['weather'][0]['main']== "Rain" ? 
                            Icons.cloud
                            :Icons.sunny,
                            );
                  }
                ),
              ),

                  const SizedBox(height: 20),
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:  [
                      AditionalInfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: '$humidity'.toString(),
                      ),
                      AditionalInfoItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: '$windSpeed'.toString(),
                      ),
                      AditionalInfoItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: "$pressure".toString() ,
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}





// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:weather_app/aditional_info_item.dart';
// import 'package:weather_app/secrets.dart';
// import 'package:weather_app/weather_forecast_item.dart';

// class WeatherScreen extends StatefulWidget {
//   const WeatherScreen({super.key});

//   @override
//   _WeatherScreenState createState() => _WeatherScreenState();
// }

// class _WeatherScreenState extends State<WeatherScreen> {
//   late Future<Map<String, dynamic>> weatherData;

//   @override
//   void initState() {
//     super.initState();
//     weatherData = getCurrentWeather();
//   }

//   Future<Map<String, dynamic>> getCurrentWeather() async {
//     try {
//       String cityName = 'London';
//       final res = await http.get(
//         Uri.parse('http://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey'),
//       );
//       final data = jsonDecode(res.body);
//       if (data['cod'] != '200') {
//         throw 'An unexpected Error occurred';
//       }
//       return data;
//     } catch (e) {
//       throw e.toString();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Weather App',
//           style: TextStyle(fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//             onPressed: () {
//               setState(() {
//                 weatherData = getCurrentWeather(); // Refresh weather data
//               });
//             },
//             icon: const Icon(Icons.refresh),
//           ),
//         ],
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: weatherData,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator.adaptive());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final data = snapshot.data!;
//             final temp = data['list'][0]['main']['temp'];
//             final currentSky = data['list'][0]['weather'][0]['main'];
//             final pressure = data['list'][0]['main']['pressure'];
//             final windSpeed = data['list'][0]['wind']['speed'];
//             final humidity = data['list'][0]['main']['humidity'];

//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     width: double.infinity,
//                     child: Card(
//                       elevation: 10,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16.0),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: BackdropFilter(
//                           filter: ImageFilter.blur(sigmaX: 10, sigmaY: 20),
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Column(
//                               children: [
//                                 Text(
//                                   '$temp K',
//                                   style: const TextStyle(
//                                     fontSize: 32,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Icon(
//                                   currentSky == 'Clouds' || currentSky == 'Rain'
//                                       ? Icons.cloud
//                                       : Icons.sunny,
//                                   size: 64,
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Text(
//                                   currentSky,
//                                   style: const TextStyle(fontSize: 16),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Hourly Forecast',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   SizedBox(
//                     height: 120,
//                     child: ListView.builder(
//                       itemCount: 5,
//                       scrollDirection: Axis.horizontal,
//                       itemBuilder: (context, index) {
//                         final hourlyForecast = data['list'][index + 1];
//                         final time = DateTime.parse(hourlyForecast['dt_txt']);
//                         return HourlyForeCastItem(
//                           time: DateFormat.Hm().format(time),
//                           temperature: hourlyForecast['main']['temp'].toString(),
//                           icon: hourlyForecast['weather'][0]['main'] == "Clouds" ||
//                                   hourlyForecast['weather'][0]['main'] == "Rain"
//                               ? Icons.cloud
//                               : Icons.sunny,
//                         );
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Additional Information',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       AditionalInfoItem(
//                         icon: Icons.water_drop,
//                         label: 'Humidity',
//                         value: humidity.toString(),
//                       ),
//                       AditionalInfoItem(
//                         icon: Icons.air,
//                         label: 'Wind Speed',
//                         value: windSpeed.toString(),
//                       ),
//                       AditionalInfoItem(
//                         icon: Icons.beach_access,
//                         label: 'Pressure',
//                         value: pressure.toString(),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
