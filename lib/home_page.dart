import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/widgets/icon_widgets.dart';
import 'package:weather/widgets/text_widgets.dart';

import 'list/weather_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherList weatherList = WeatherList();
  late Position position;
  late List<Placemark> placemarks;
  bool isLoading = false;

  getData() async {
    final response = await Dio().get(
        'https://api.tomorrow.io/v4/weather/forecast?location=${position.latitude},${position.longitude}&apikey=I5KAMadzBFue0Q7w09tAh2tMaUyynAdX');
    print(response.data);

    weatherList = WeatherList.fromJson(response.data);
    setState(() {
      isLoading = false;
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<Position> getLocation() async {
    position = await _determinePosition();
    print("position.latitude");
    print(position.latitude);
    print("position.longitude");
    print(position.longitude);
    placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks.first.locality);
    getData();
    return position;
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getLocation();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: GradientColors.coolBlues,
                      ),
                    ),
                    width: 430,
                    height: 1000,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 80, left: 20),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  TextWidgets(
                                    texts: placemarks.first.subLocality,
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(right: 60, bottom: 10),
                                    child: IconWidgets(
                                      icon: Icon(Icons.location_pin,
                                          color: Colors.white, size: 16),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 50, left: 150),
                                child: IconWidgets(
                                  icon: Icon(Icons.add,
                                      color: Colors.white, size: 35),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 50),
                                child: IconWidgets(
                                  icon: Icon(Icons.settings_outlined,
                                      color: Colors.white, size: 30),
                                ),
                              )
                            ],
                          ),
                        ),
                        TextWidgets(
                          texts:
                              '${weatherList.timelines?.minutely?[0].values?['temperature']} ℃'
                                  .toString(),
                          color: Colors.white,
                          fontSize: 80,
                          weight: FontWeight.w500,
                        ),
                        // const TextWidgets(
                        //   texts: "Haze 28/34/ Air quality:67-Satisfactory",
                        //   color: Colors.white,
                        //   fontSize: 20,
                        //   textAlign: TextAlign.justify,
                        // ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 80),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height - 800,
                                width: MediaQuery.of(context).size.width - 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const IconWidgets(
                                      icon: Icon(Icons.thermostat_auto_sharp,
                                          color: Colors.white),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: TextWidgets(
                                        texts: "Feels like",
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 12),
                                          child: TextWidgets(
                                            texts:
                                                '${weatherList.timelines?.minutely![0].values?['temperatureApparent']}°',
                                            color: Colors.white,
                                            fontSize: 24,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height - 800,
                                width: MediaQuery.of(context).size.width - 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const IconWidgets(
                                      icon: Icon(Icons.visibility,
                                          color: Colors.white),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: TextWidgets(
                                        texts: "Visibility",
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextWidgets(
                                            texts: weatherList
                                                .timelines
                                                ?.minutely![0]
                                                .values?['visibility']
                                                .toString(),
                                            color: Colors.white,
                                            fontSize: 24,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: TextWidgets(
                                            texts: "mi",
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 80),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height - 800,
                                width: MediaQuery.of(context).size.width - 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const IconWidgets(
                                      icon: Icon(Icons.water_drop,
                                          color: Colors.white),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: TextWidgets(
                                        texts: "Humidity",
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextWidgets(
                                            texts: weatherList
                                                .timelines
                                                ?.minutely![0]
                                                .values?['humidity']
                                                .toString(),
                                            color: Colors.white,
                                            fontSize: 24,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: TextWidgets(
                                            texts: "%",
                                            color: Colors.white,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, top: 20),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                height:
                                    MediaQuery.of(context).size.height - 800,
                                width: MediaQuery.of(context).size.width - 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const IconWidgets(
                                      icon: Icon(Icons.air_sharp,
                                          color: Colors.white),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10),
                                      child: TextWidgets(
                                        texts: "WNW wind",
                                        color: Colors.white70,
                                        fontSize: 15,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: TextWidgets(
                                            texts: weatherList
                                                .timelines
                                                ?.minutely![0]
                                                .values?['windSpeed']
                                                .toString(),
                                            color: Colors.white,
                                            fontSize: 24,
                                            weight: FontWeight.bold,
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: TextWidgets(
                                            texts: "km/h",
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
