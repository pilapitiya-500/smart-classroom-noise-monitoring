/*import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
////////////////////////////////
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NoiseDashboard(),
    );
  }
}

class NoiseDashboard extends StatefulWidget {
  const NoiseDashboard({super.key});

  @override
  State<NoiseDashboard> createState() => _NoiseDashboardState();
}

class _NoiseDashboardState extends State<NoiseDashboard> {
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref("classroom");

  int noise = 0;
  String status = "Loading";

  @override
  void initState() {
    super.initState();

    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map;
      setState(() {
        noise = data['noise'];
        status = data['status'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoud = status == "Loud";

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Title
              const Text(
                "Smart Classroom",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              const Text(
                "Noise Monitoring System",
                style: TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 40),

              // Main Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        const Text(
                          "Current Noise Level",
                          style: TextStyle(fontSize: 20),
                        ),

                        const SizedBox(height: 15),

                        Text(
                          noise.toString(),
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: isLoud ? Colors.red : Colors.green,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: isLoud ? Colors.red : Colors.green,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Icon(
                          isLoud
                              ? Icons.warning_amber_rounded
                              : Icons.volume_down_rounded,
                          size: 70,
                          color: isLoud ? Colors.red : Colors.green,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Info Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.indigo),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "This system monitors classroom noise levels in real time and alerts when noise exceeds the limit.",
                          ),
                        ),
                      ],
                    ),
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




//////////////////
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NoiseDashboard(),
    );
  }
}

class NoiseDashboard extends StatefulWidget {
  const NoiseDashboard({super.key});

  @override
  State<NoiseDashboard> createState() => _NoiseDashboardState();
}

class _NoiseDashboardState extends State<NoiseDashboard> {
  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref("classroom");

  int noise = 0;
  String status = "Loading";

  @override
  void initState() {
    super.initState();

    // Firebase database listener
    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      setState(() {
        noise = data['noise'] ?? 0;
        status = data['status'] ?? "Unknown";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoud = status.toLowerCase() == "loud";

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Title
                const Text(
                  "Smart Classroom",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Noise Monitoring System",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 40),

                // Main Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        children: [
                          const Text(
                            "Current Noise Level",
                            style: TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 15),

                          // Animated Noise Number
                          TweenAnimationBuilder(
                            tween: Tween<double>(
                                begin: 0, end: noise.toDouble()),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) {
                              return Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: isLoud ? Colors.red : Colors.green,
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 10),

                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: isLoud ? Colors.red : Colors.green,
                            ),
                          ),

                          const SizedBox(height: 20),

                          Icon(
                            isLoud
                                ? Icons.warning_amber_rounded
                                : Icons.volume_down_rounded,
                            size: 70,
                            color: isLoud ? Colors.red : Colors.green,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Info Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.indigo),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "This system monitors classroom noise levels in real time and alerts when noise exceeds the limit.",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




/////////////////



import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

// Syncfusion Radial Gauge import
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NoiseDashboard(),
    );
  }
}

class NoiseDashboard extends StatefulWidget {
  const NoiseDashboard({super.key});

  @override
  State<NoiseDashboard> createState() => _NoiseDashboardState();
}

class _NoiseDashboardState extends State<NoiseDashboard> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("classroom");

  int noise = 0;
  String status = "Loading";

  @override
  void initState() {
    super.initState();

    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      setState(() {
        noise = data['noise'] ?? 0;
        status = data['status'] ?? "Unknown";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoud = status.toLowerCase() == "loud";

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Smart Classroom",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Noise Monitoring System",
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 30),

                // 🔊 Analog Gauge
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SfRadialGauge(
                        axes: <RadialAxis>[
                          RadialAxis(
                            minimum: 0,
                            maximum: 100,
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 60,
                                  color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 60,
                                  endValue: 80,
                                  color: Colors.orange,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 80,
                                  endValue: 100,
                                  color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10),
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(value: noise.toDouble()),
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                widget: Text(
                                  noise.toString(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: isLoud
                                        ? Colors.red
                                        : Colors.green,
                                  ),
                                ),
                                angle: 90,
                                positionFactor: 0.7,
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Status Text
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: isLoud ? Colors.red : Colors.green,
                  ),
                ),

                const SizedBox(height: 30),

                // Info Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.indigo),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "This system monitors classroom noise levels in real time and alerts when noise exceeds the limit.",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 ////////////
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NoiseDashboard(),
    );
  }
}

class NoiseDashboard extends StatefulWidget {
  const NoiseDashboard({super.key});

  @override
  State<NoiseDashboard> createState() => _NoiseDashboardState();
}

class _NoiseDashboardState extends State<NoiseDashboard> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("classroom");

  int noise = 0;
  String status = "Loading";

  @override
  void initState() {
    super.initState();

    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      setState(() {
        noise = data['noise'] ?? 0;
        status = data['status'] ?? "Unknown";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoud = status.toLowerCase() == "loud";

    return Scaffold(
      backgroundColor: Colors.black, // Background black
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              children: [
                // Title
                const Text(
                  "Smart Classroom",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Noise Monitoring System",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 30),

                // 🔊 Analog Gauge (Top)
                Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                          minimum: 0,
                          maximum: 100,
                          showTicks: true,
                          showLabels: true,
                          axisLabelStyle: const GaugeTextStyle(
                            color: Colors.white, // Numbers color white
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          ranges: <GaugeRange>[
                            GaugeRange(
                                startValue: 0,
                                endValue: 60,
                                color: Colors.green,
                                startWidth: 10,
                                endWidth: 10),
                            GaugeRange(
                                startValue: 60,
                                endValue: 80,
                                color: Colors.orange,
                                startWidth: 10,
                                endWidth: 10),
                            GaugeRange(
                                startValue: 80,
                                endValue: 100,
                                color: Colors.red,
                                startWidth: 10,
                                endWidth: 10),
                          ],
                          pointers: <GaugePointer>[
                            NeedlePointer(
                              value: noise.toDouble(),
                              needleColor: Colors.white, // Needle white
                              knobStyle: const KnobStyle(
                                color: Colors.white, // Knob white
                              ),
                            ),
                          ],
                          annotations: <GaugeAnnotation>[
                            GaugeAnnotation(
                              widget: Text(
                                noise.toString(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isLoud ? Colors.red : Colors.white, // Value
                                ),
                              ),
                              angle: 90,
                              positionFactor: 0.7,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                 // Noise Number + Status Card (below gauge)
                Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Keep "Current Noise" text same position
                        const Text(
                          "Current Noise",
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 15),
                        // Horizontal Row: Noise + Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              noise.toString(),
                              style: const TextStyle(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(width: 30),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 15),
                              decoration: BoxDecoration(
                                color: isLoud ? Colors.red : Colors.green,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                status.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Info Card
                Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.indigo),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "This system monitors classroom noise levels in real time and alerts when noise exceeds the limit.",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//////////////

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoiseDashboard(),
    );
  }
}

class NoiseDashboard extends StatefulWidget {
  const NoiseDashboard({super.key});

  @override
  State<NoiseDashboard> createState() => _NoiseDashboardState();
}

class _NoiseDashboardState extends State<NoiseDashboard> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("classroom");

  int noise = 0;
  String status = "Loading";

  List<Map<String, dynamic>> loudHistory = [];

  @override
  void initState() {
    super.initState();

    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      setState(() {
        noise = data['noise'] ?? 0;

        // Calculate status
        if (noise <= 50) {
          status = "Quiet";
        } else if (noise <= 70) {
          status = "Average";
        } else {
          status = "Loud";
        }

        // Push to history only if Loud
        if (status == "Loud") {
          final now = DateTime.now();
          final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

          // Check if already exists in history
          bool alreadyExists = loudHistory.any(
              (e) => e['timestamp'] == timestamp && e['value'] == noise);

          if (!alreadyExists) {
            // Push to Firebase history
            dbRef.child("history").push().set({
              "timestamp": timestamp,
              "value": noise,
            });

            // Update local history
            loudHistory.add({
              "timestamp": timestamp,
              "value": noise,
            });
          }
        }

        // Load existing history from Firebase
        if (data.containsKey('history')) {
          loudHistory = (data['history'] as Map<dynamic, dynamic>)
              .values
              .map<Map<String, dynamic>>((e) => {
                    "timestamp": e['timestamp'],
                    "value": e['value'],
                  })
              .toList()
              // remove duplicates
              .where((element) => !loudHistory.any((e) =>
                  e['timestamp'] == element['timestamp'] &&
                  e['value'] == element['value']))
              .toList()
              .reversed
              .toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoud = status == "Loud";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Smart Classroom",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.history),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.grey[900],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setModalState) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Loud Events History",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await dbRef.child("history").remove();
                                  setModalState(() {
                                    loudHistory.clear();
                                  });
                                },
                                child: const Text(
                                  "RESET",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: loudHistory.isEmpty
                                ? const Center(
                                    child: Text(
                                      "No Loud Events Yet",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: loudHistory.length,
                                    itemBuilder: (context, index) {
                                      final item = loudHistory[index];
                                      return Card(
                                        color: Colors.grey[800],
                                        child: ListTile(
                                          leading: const Icon(Icons.warning,
                                              color: Colors.red),
                                          title: Text(
                                            item['timestamp'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          trailing: Text(
                                            item['value'].toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              });
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Noise Monitoring System",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              // Gauge
              Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SfRadialGauge(
                    axes: [
                      RadialAxis(
                        minimum: 0,
                        maximum: 100,
                        axisLabelStyle: const GaugeTextStyle(color: Colors.white),
                        ranges: [
                          GaugeRange(startValue: 0, endValue: 60, color: Colors.green),
                          GaugeRange(startValue: 60, endValue: 80, color: Colors.orange),
                          GaugeRange(startValue: 80, endValue: 100, color: Colors.red),
                        ],
                        pointers: [
                          NeedlePointer(
                            value: noise.toDouble(),
                            needleColor: Colors.white,
                            knobStyle: const KnobStyle(color: Colors.white),
                          ),
                        ],
                        annotations: [
                          GaugeAnnotation(
                            widget: Text(
                              noise.toString(),
                              style: TextStyle(
                                  color: isLoud ? Colors.red : Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                            angle: 90,
                            positionFactor: 0.7,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Noise + Status
              Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text("Current Noise",
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            noise.toString(),
                            style: const TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 25),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12),
                            decoration: BoxDecoration(
                              color: isLoud ? Colors.red : Colors.green,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
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


today

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoiseDashboard(),
    );
  }
}

class NoiseDashboard extends StatefulWidget {
  const NoiseDashboard({super.key});

  @override
  State<NoiseDashboard> createState() => _NoiseDashboardState();
}

class _NoiseDashboardState extends State<NoiseDashboard> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref("classroom");

  int noise = 0;
  String status = "Loading";

  List<Map<String, dynamic>> loudHistory = [];
  int? lastLoudValue; // track last loud value to prevent duplicates

  @override
  void initState() {
    super.initState();

    dbRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      setState(() {
        noise = data['noise'] ?? 0;

        // Calculate status
        if (noise <= 50) {
          status = "Quiet";
        } else if (noise <= 70) {
          status = "Average";
        } else {
          status = "Loud";
        }

        // Only push to history if Loud AND value changed
        if (status == "Loud" && lastLoudValue != noise) {
          final now = DateTime.now();
          final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

          dbRef.child("history").push().set({
            "timestamp": timestamp,
            "value": noise,
          });

          loudHistory.add({
            "timestamp": timestamp,
            "value": noise,
          });

          lastLoudValue = noise; // update last saved loud value
        }

        // Load existing history from Firebase (on app start or refresh)
        if (data.containsKey('history')) {
          loudHistory = (data['history'] as Map<dynamic, dynamic>)
              .values
              .map<Map<String, dynamic>>((e) => {
                    "timestamp": e['timestamp'],
                    "value": e['value'],
                  })
              .toList()
              .reversed
              .toList();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isLoud = status == "Loud";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Smart Classroom",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.history),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.grey[900],
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setModalState) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Loud Events History",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await dbRef.child("history").remove();
                                  setModalState(() {
                                    loudHistory.clear();
                                  });
                                },
                                child: const Text(
                                  "RESET",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Expanded(
                            child: loudHistory.isEmpty
                                ? const Center(
                                    child: Text(
                                      "No Loud Events Yet",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: loudHistory.length,
                                    itemBuilder: (context, index) {
                                      final item = loudHistory[index];
                                      return Card(
                                        color: Colors.grey[800],
                                        child: ListTile(
                                          leading: const Icon(Icons.warning,
                                              color: Colors.red),
                                          title: Text(
                                            item['timestamp'],
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          trailing: Text(
                                            item['value'].toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              });
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Noise Monitoring System",
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 30),
              // Gauge
              Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SfRadialGauge(
                    axes: [
                      RadialAxis(
                        minimum: 0,
                        maximum: 100,
                        axisLabelStyle: const GaugeTextStyle(color: Colors.white),
                        ranges: [
                          GaugeRange(startValue: 0, endValue: 60, color: Colors.green),
                          GaugeRange(startValue: 60, endValue: 80, color: Colors.orange),
                          GaugeRange(startValue: 80, endValue: 100, color: Colors.red),
                        ],
                        pointers: [
                          NeedlePointer(
                            value: noise.toDouble(),
                            needleColor: Colors.white,
                            knobStyle: const KnobStyle(color: Colors.white),
                          ),
                        ],
                        annotations: [
                          GaugeAnnotation(
                            widget: Text(
                              noise.toString(),
                              style: TextStyle(
                                  color: isLoud ? Colors.red : Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold),
                            ),
                            angle: 90,
                            positionFactor: 0.7,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Noise + Status
              Card(
                color: Colors.grey[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text("Current Noise",
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            noise.toString(),
                            style: const TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 25),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 12),
                            decoration: BoxDecoration(
                              color: isLoud ? Colors.red : Colors.green,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      )
                    ],
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
*/
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoiseDashboard(),
    );
  }
}

class NoiseDashboard extends StatefulWidget {
  const NoiseDashboard({super.key});

  @override
  State<NoiseDashboard> createState() => _NoiseDashboardState();
}

class _NoiseDashboardState extends State<NoiseDashboard> {

  final DatabaseReference dbRef =
      FirebaseDatabase.instance.ref("classroom");

  int noise = 0;
  String status = "Loading";

  List<Map<String, dynamic>> loudHistory = [];
  int? lastLoudValue;

  @override
  void initState() {
    super.initState();

    dbRef.onValue.listen((event) {

      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};

      setState(() {

        noise = data['noise'] ?? 0;

        // STATUS CALCULATION
        if (noise <= 50) {
          status = "Quiet";
        } 
        else if (noise <= 70) {
          status = "Average";
        } 
        else {
          status = "Loud";
        }

        // SAVE LOUD EVENTS
        if (status == "Loud" && lastLoudValue != noise) {

          final now = DateTime.now();
          final timestamp =
              DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

          dbRef.child("history").push().set({
            "timestamp": timestamp,
            "value": noise,
          });

          loudHistory.add({
            "timestamp": timestamp,
            "value": noise,
          });

          lastLoudValue = noise;
        }

        // LOAD HISTORY FROM FIREBASE
        if (data.containsKey('history')) {

          loudHistory = (data['history'] as Map<dynamic, dynamic>)
              .values
              .map<Map<String, dynamic>>((e) => {
                    "timestamp": e['timestamp'],
                    "value": e['value'],
                  })
              .toList()
              .reversed
              .toList();
        }

      });

    });
  }

  @override
  Widget build(BuildContext context) {

    bool isLoud = status == "Loud";

    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Smart Classroom",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.history),
        onPressed: () {

          showModalBottomSheet(
              context: context,
              backgroundColor: Colors.grey[900],
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (context) {

                return Padding(
                  padding: const EdgeInsets.all(16),

                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [

                          const Text(
                            "Loud Events History",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),

                          TextButton(
                            onPressed: () async {

                              await dbRef.child("history").remove();

                              setState(() {
                                loudHistory.clear();
                              });

                            },
                            child: const Text(
                              "RESET",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Expanded(
                        child: loudHistory.isEmpty
                            ? const Center(
                                child: Text(
                                  "No Loud Events Yet",
                                  style: TextStyle(
                                      color: Colors.white70),
                                ),
                              )
                            : ListView.builder(
                                itemCount: loudHistory.length,

                                itemBuilder: (context, index) {

                                  final item = loudHistory[index];

                                  return Card(
                                    color: Colors.grey[800],

                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.warning,
                                        color: Colors.red,
                                      ),

                                      title: Text(
                                        item['timestamp'],
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),

                                      trailing: Text(
                                        item['value'].toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight:
                                                FontWeight.bold),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              });
        },
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const SizedBox(height: 10),

            const Text(
              "Noise Monitoring System",
              style: TextStyle(color: Colors.white70),
            ),

            const SizedBox(height: 30),

            // GAUGE
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: SfRadialGauge(
                  axes: [

                    RadialAxis(
                      minimum: 0,
                      maximum: 100,

                      axisLabelStyle:
                          const GaugeTextStyle(color: Colors.white),

                      ranges: [

                        GaugeRange(
                            startValue: 0,
                            endValue: 50,
                            color: Colors.green),

                        GaugeRange(
                            startValue: 50,
                            endValue: 70,
                            color: Colors.orange),

                        GaugeRange(
                            startValue: 70,
                            endValue: 100,
                            color: Colors.red),
                      ],

                      pointers: [

                        NeedlePointer(
                          value: noise.toDouble(),
                          needleColor: Colors.white,
                          knobStyle:
                              const KnobStyle(color: Colors.white),
                        ),
                      ],

                      annotations: [

                        GaugeAnnotation(
                          widget: Text(
                            noise.toString(),
                            style: TextStyle(
                                color: isLoud
                                    ? Colors.red
                                    : Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                          angle: 90,
                          positionFactor: 0.7,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // STATUS CARD
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  children: [

                    const Text(
                      "Current Noise",
                      style: TextStyle(color: Colors.white70),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        Text(
                          noise.toString(),
                          style: const TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),

                        const SizedBox(width: 25),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 12),

                          decoration: BoxDecoration(
                            color: status == "Quiet"
                                ? Colors.green
                                : status == "Average"
                                    ? Colors.orange
                                    : Colors.red,
                            borderRadius:
                                BorderRadius.circular(30),
                          ),

                          child: Text(
                            status.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

