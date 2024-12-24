import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(WorldTimerApp());
}

class WorldTimerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'World Timer',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: WorldTimerHomePage(),
    );
  }
}

class WorldTimerHomePage extends StatefulWidget {
  @override
  _WorldTimerHomePageState createState() => _WorldTimerHomePageState();
}

class _WorldTimerHomePageState extends State<WorldTimerHomePage> {
  List<Map<String, dynamic>> _timeZones = [
    {'name': 'New York', 'zone': 'America/New_York'},
    {'name': 'London', 'zone': 'Europe/London'},
    {'name': 'Tokyo', 'zone': 'Asia/Tokyo'},
    {'name': 'Sydney', 'zone': 'Australia/Sydney'},
    {'name': 'Dubai', 'zone': 'Asia/Dubai'},
  ];

  late Timer _timer;
  
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _getTimeForZone(String timeZoneName) {
    final location = tz.getLocation(timeZoneName);
    final now = tz.TZDateTime.now(location);
    return DateFormat('HH:mm:ss').format(now);
  }

  String _getDateForZone(String timeZoneName) {
    final location = tz.getLocation(timeZoneName);
    final now = tz.TZDateTime.now(location);
    return DateFormat('EEE, MMM d').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'World Timer',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: _timeZones.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final timeZone = _timeZones[index];
          return _buildTimeCard(
            cityName: timeZone['name'], 
            timeZone: timeZone['zone']
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewTimeZone,
        child: Icon(Icons.add),
        tooltip: 'Add Time Zone',
      ),
    );
  }

  Widget _buildTimeCard({required String cityName, required String timeZone}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cityName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _getDateForZone(timeZone),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              _getTimeForZone(timeZone),
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w300,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addNewTimeZone() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add New Time Zone',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'City Name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  // In a real app, you'd show a picker of time zones
                  // This is a simplified example
                  setState(() {
                    _timeZones.add({
                      'name': value,
                      'zone': 'America/New_York' // Default timezone
                    });
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}