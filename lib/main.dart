import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'user_agent/io.dart' if (dart.library.html) 'user_agent/web.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';


final Location location = Location();

  PermissionStatus? _permissionGranted;

  Future<bool> _checkPermissions() async {
    final permissionGrantedResult = await location.hasPermission();
      _permissionGranted = permissionGrantedResult;
    return _permissionGranted == PermissionStatus.granted;
  }

  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final permissionRequestedResult = await location.requestPermission();
        _permissionGranted = permissionRequestedResult;
    }
  }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool p = await _checkPermissions();

  if (p == false) _requestPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
final Location location = Location();

  bool _loading = false;

  LocationData? _location;
  String? _error;

  List<String> debugList = [];

Future<void> _getLocation() async {
    setState(() {
      _error = null;
      _loading = true;
    });
    try {
      final locationResult = await location.getLocation();
      setState(() {
        _location = locationResult;
        _loading = false;
      });
    } on PlatformException catch (err) {
      setState(() {
        _error = err.code;
        _loading = false;
      });
    }
  }

Future<bool> launchSms(String? number, [String? body]) async {
  bool p = await _checkPermissions();

  if (p == false) {
    await _requestPermission();
  }

  print('Permission: $_permissionGranted');
  debugList.add('Permission: $_permissionGranted');

  await _getLocation();
  debugList.add('Location: $_location');

  print('Location: $_location');

  print('function called');
  debugList.add('function called');

  number ??= '';
  // final Uri uri = Uri(scheme: 'sms', path: number);
  if (_location != null) {
    final String latitude = _location!.latitude.toString();
      final String longitude = _location!.longitude.toString();
    final String url = 'https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}';

    final encodedBody = Uri.encodeComponent('Here is my location: $url');
    final Uri uri = Uri.parse('sms:/$number${separator}body=$encodedBody');
    print('URI: $uri');
    debugList.add('URI: $uri');

  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return true;
    } else {
      print('Could not launch SMS');
      debugList.add('Could not launch SMS');
      return false;
    }
  } catch (e) {
    print('Error launching SMS: $e');
    debugList.add('Error launching SMS: $e');
    return false;
  }
  }
  return false;
}

  String get separator => isCupertino() ? '&' : '?';


  @override
  Widget build(BuildContext context) {

    String message = "This is a test message!";
  String recipents = "998938966698";
  // String recipents = "998909157824";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            TextField(
              controller: TextEditingController(text: recipents),
              onChanged: (String value) {
                recipents = value;
              },
            ),
            IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            showModalBottomSheet(
    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
              return Container(
                height: 1000,
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Center(
                  child: SingleChildScrollView(child: Column(
                    children: debugList.map((String item) => Text(item)).toList(),
                ),
                ),
                ),
              );
            }
            );
          },
        ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('Sending SMS');
          debugList.add('Sending SMS');
          launchSms(recipents, message);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), 
    );
  }
}
