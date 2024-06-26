

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:noti6/notification_screen.dart';
import 'firebase_options.dart';


Future<void> setfirebase() async {
WidgetsFlutterBinding.ensureInitialized();

await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('تم استلام رسالة أثناء وجود التطبيق في المقدمة!');
      print('بيانات الرسالة: ${message.data}');

      if (message.notification != null) {
        print('الرسالة تحتوي أيضًا على إشعار: ${message.notification}');
      }
    });

}
 Future<void> handleBackgroundMessage (RemoteMessage message)  async {

    print( 'Title: ${message.notification?.title}');
    print( 'Body: ${message.notification?.body}');
    print ( 'Payload: ${message?.data}');


}
final navigatorkey = GlobalKey<NavigatorState>();
Future<void> main() async {

  await setfirebase();
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

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),


        routes: {
        NotificationScreen.route: (context) => NotificationScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void handleMessage (RemoteMessage? message){
     print('handleMessage0') ;
        if(message == null) {
          return ;
        }
         Navigator.pushNamed(context, NotificationScreen.route);
        print('handleMessage1') ;
    // navigatorkey.currentState?.pushNamed(
    // NotificationScreen.route, arguments: message);

  //     Navigator.of(context).push(
  //   MaterialPageRoute(
  //     builder: (context) =>  NotificationScreen(),
  //   ),
  // );
     print('handleMessage2') ;
  }


Future initPushNotifications(BuildContext context)async 
{
       print('initPushNotifications 1') ;
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions (
      alert: true, badge: true, sound: true,
      ) ;
      print('initPushNotifications 2') ;
      FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
      print('initPushNotifications 3') ;
      FirebaseMessaging.onMessageOpenedApp.listen (handleMessage);
      print('initPushNotifications 4') ;
      FirebaseMessaging.onBackgroundMessage( handleBackgroundMessage );
      print('initPushNotifications 5') ;
}

 setMessagingNoti(BuildContext context) async {
final fcm = FirebaseMessaging.instance;
await fcm.requestPermission();
final token = await fcm.getToken ();
  print('token :$token');
initPushNotifications(context);

 }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setMessagingNoti();


  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
     setMessagingNoti(context);


  }

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
