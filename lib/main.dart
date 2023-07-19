import 'package:barter_it2/main/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';


void main() {
WidgetsFlutterBinding.ensureInitialized();
Stripe.publishableKey = "pk_test_51NVGM1J7QsZfEUPTx2U1bBfxnraOknjHcCbaBfhOKDWDklggeadhtPf4SQrr0k0C6fbvFcK6Lts08QeRCdO3FPbS004Ee4HZrF";
runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData( 
        primarySwatch: Colors.brown,
        cardColor: Color.fromARGB(255, 233, 214, 203),
      ),
      home: const SplashScreen(), //nanti letak splashscreen balik
      );
  }
}
