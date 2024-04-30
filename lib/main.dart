import 'package:flutter/material.dart';
import 'package:test1/cache.dart';
import 'package:test1/custom_dropdown.dart';
import 'package:test1/custom_textformfield.dart';
import 'package:test1/primary_custom_button.dart';
import 'package:test1/secure_storage.dart';
import 'package:test1/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'user_agent/io.dart' if (dart.library.html) 'user_agent/web.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

const Color themeColor = Color(0xff00bc56);

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

Future<List<Map<String, dynamic>>> getPhoneNumberList() async {
    return await SharedPrefCache.listData();
  }

Future<void> initializePhoneNumberList() async {
  List<Map<String, Map<String, String>>> phoneNumbers = [
    {
      '0': {'name': 'Dad', 'number': '998938966698'},
      '1': {'name': 'Mum', 'number': '998909157824'},
      '2': {'name': 'Brother', 'number': '998938966698'},
      '3': {'name': 'Sister', 'number': '998909157824'},
    }
          ];
          for (var phoneNumber in phoneNumbers) {
            await SharedPrefCache.storeData(phoneNumber);
          }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool p = await _checkPermissions();

  if (p == false) _requestPermission();
  
  // initializePhoneNumberList();

  runApp(const MyApp());
    SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
  );
  
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

    ThemeData _buildTheme(Brightness brightness) {
    return ThemeData(
      brightness: brightness,
      primarySwatch: Colors.green,
      textSelectionTheme: const TextSelectionThemeData(cursorColor: themeColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TYLO',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      builder: (BuildContext c, Widget? w) {
        return ScrollConfiguration(
          behavior: const NoGlowScrollBehavior(),
          child: w!,
        );
      },
      home: const MyHomePage(title: 'TYLO'),
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
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController newPatientNameController = TextEditingController();
  final TextEditingController birthYearController = TextEditingController();
  List<Map<String, dynamic>> phoneNumbers = [];

  @override
void initState() {
  super.initState();
  data();
}

void data() async {
  phoneNumbers = await getPhoneNumberList();
  setState(() {});
}

@override
void dispose() {
  phoneNumberController.dispose();
  super.dispose();
}



  bool _loading = false;
  bool isSavingNewPatient = false;
  LocationData? _location;
  List<String> errors = [];
  String? _error;
  List<String> debugList = [];
  int? selectedTime; // Store the selected time in minutes



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

  Future<bool> launchSms(String? number,) async {
    debugList.add('Checking permissions');
    bool p = await _checkPermissions();

    if (p == false) {
      await _requestPermission();
    }
    debugList.add('Permissions checked');

    print('Permission status: $_permissionGranted');
    debugList.add('Permission status: $_permissionGranted');

    debugList.add('Getting location');
    await _getLocation();
    debugList.add('Location: $_location');

    print('Location: $_location');

    print('function called');

    number ??= '';
    // final Uri uri = Uri(scheme: 'sms', path: number);
    if (_location != null) {
      final double latitude = _location!.latitude!;
        final double longitude = _location!.longitude!;
      final String url = 'https://www.google.com/maps/search/?api=1&query=${latitude},${longitude}';

      final encodedBody = Uri.encodeComponent('Here is my location: $url');
      final Uri uri = Uri.parse('sms:/$number${separator}body=$encodedBody');
      print('URI: $uri');
      debugList.add('URI: $uri');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        debugList.add('SMS launched');
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

  Future<void> sendSms() async {
    if (selectedTime != null) {
      debugList.add('Launching SMS every $selectedTime minutes');
      Timer.periodic(Duration(minutes: selectedTime!), (_) => launchSms(phoneNumberController.text)); 
      Navigator.pop(context);
    } else {
      debugList.add('Launching SMS once');
      launchSms(phoneNumberController.text);
      Navigator.pop(context);
    }
    debugList.add('SMS sent');
  }

  void showAddNewPatientBottomSheet(BuildContext context) {

  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return 
      Container(
        height: 600,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        color: const Color.fromARGB(255, 31, 33, 38),
        child: SingleChildScrollView(
          child:
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24.0),
            Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
                              'Add new phone number',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255), // Add your background color here
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 18,),
        ),
      ),
    ],
),
          
const SizedBox(height: 32.0),

CustomTextFormField(
  labelText: 'Name (ex: John Doe)',
  isInputEmpty: newPatientNameController.text.isEmpty,
  onChanged: (value) => setState(() => newPatientNameController.text = value),
  onClear: () => setState(() => newPatientNameController.text = ''),
  initialValue: newPatientNameController.text,
),
  const SizedBox(height: 24.0),
CustomTextFormField(
  labelText: 'Phone number (ex: 998938966698)',
  isInputEmpty: birthYearController.text.isEmpty,
  onChanged: (value) => setState(() => birthYearController.text = value),
  onClear: () => setState(() => birthYearController.text = ''),
  initialValue: birthYearController.text,
),
  const SizedBox(height: 32.0),

  SizedBox(
                  width: double.infinity,
                  child:

          ElevatedButton(
  onPressed: (isSavingNewPatient) ? () {} : () {
    print('Saving new patient');
    if (newPatientNameController.text.isEmpty) {
      showToast(message: 'Name is required.', bgColor: Colors.red[900]);
      return;
    }
    if (birthYearController.text.isEmpty) {
      showToast(message: 'Phone number is required.', bgColor: Colors.red[900]);
      return;
    }
    setState(() {
      isSavingNewPatient = true;
    });



              //  save 
               String id = DateTime.now().millisecondsSinceEpoch.toString();
                        Map<String, dynamic> selected = {
                          id: {
                            'name': newPatientNameController.text,
                            'number': birthYearController.text

                          }
                        };
                        SharedPrefCache.storeData(selected);
                        phoneNumbers.add(selected);
                        setState(() {
                          isSavingNewPatient = false;
                        });
                        Navigator.of(context).pop();
                        showToast(message: 'New phone number saved.', bgColor: Colors.green[900]);
                        
  },
  style: ElevatedButton.styleFrom(
    elevation: 5,
    surfaceTintColor: Colors.transparent,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white, // Set the text color (applies to foreground)
    textStyle: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700, 
    ),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40), // Set the padding
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)), // Set the border radius
            side: BorderSide(
        color: Colors.white,
        width: 2,
      ),
    ),
  ),
  child: 
    isSavingNewPatient ? 
      CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF232428)), // Change the progress color
    backgroundColor: Color(0xFFC3C3C3), // Change the background color
  ) :
  Text(
    'SAVE'
  ),
),
),
          ],
        ),
        ),
      );
    },
    );
}

  @override
  Widget build(BuildContext context) {
    // int? selectedTime; // Store the selected time in minutes

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 31, 33, 38),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 23, 24, 28),
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.bug_report), // Debug icon
          onPressed: () {
            showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return
                    Container(
        height: 800,
        color: const Color.fromARGB(255, 31, 33, 38),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 0.0),
          child:
        SingleChildScrollView(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            const SizedBox(height: 20),
            Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
                              'Debugging info',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 18,),
        ),
      ),
    ],
),
const SizedBox(height: 20),
Text(
                              'Debugging information for the app',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
const SizedBox(height: 24),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: debugList.map((String item) => Text(item, style: TextStyle(color: Colors.white),)).toList(),
                      ),
                    ],
                    ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return
                    Container(
        height: 800,
        color: const Color.fromARGB(255, 31, 33, 38),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 0.0, bottom: 0.0),
          child:
        SingleChildScrollView(
          child:
          Column(crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
            children: [
            const SizedBox(height: 20),
            Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
                              'Send your location',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
      Container(
        alignment: Alignment.center,
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: Color.fromARGB(200, 255, 255, 255),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.close, color: Colors.black, size: 18,),
        ),
      ),
    ],
),
const SizedBox(height: 20),
Text(
                              'Select phone number and time interval to send your location',
                              maxLines: 2,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
const SizedBox(height: 24),
Text(
  'Phone number',
  textAlign: TextAlign.left,
  style: TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ),
),
const SizedBox(height: 16),
                  CustomDropdownWithSearch( 
                    labelText: "Select phone number",
          items: phoneNumbers,
          itemName: 'Select',
          dState: 1,
          isAddNewPatient: true,
          onAddNewPatient: () {
            showAddNewPatientBottomSheet(context);
          },
          onSelected: (value) {
            phoneNumberController.text = value;
            debugList.add('Selected phone number: $value');
          },
        ),
            const SizedBox(height: 20),

                    Row(
                    children: [
                      Expanded(child: 
                      ChoiceChip(
                        label: const Text('1 min'),
                        selected: selectedTime == 1,
                        onSelected: (value) { 
                          setState(() => selectedTime = value ? 1 : null); 
                          debugList.add('Selected time: $selectedTime min');
                        },
                      ),
                      ),
                      Expanded(child: 
                      ChoiceChip(
                        label: const Text('3 mins'),
                        selected: selectedTime == 3,
                        onSelected: (value) {
                          setState(() => selectedTime = value ? 3 : null);
                          debugList.add('Selected time: $selectedTime min');
                        }
                      ),
                      ),
                      Expanded(child: 
                      ChoiceChip(
                        label: const Text('5 mins'),
                        selected: selectedTime == 5,
                        onSelected: (value) {
                          setState(() => selectedTime = value ? 5 : null);
                          debugList.add('Selected time: $selectedTime min');
                        }
                      ),
                      ),
                    ],
        ),
        const SizedBox(height: 60),
        PrimaryCustomButton(
          onPressed: _loading ? () {} : sendSms,
          label: 'Send'.toUpperCase(),
          isDisabled: selectedTime == null || _loading,
          loading: _loading,
        ),
          ],)
        ),
        ),
                  );
                  }
                );
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

class NoGlowScrollBehavior extends ScrollBehavior {
  const NoGlowScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;
}