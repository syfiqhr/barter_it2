import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class Payment{
  
  static Payment instance = Payment();
  Map<String, dynamic>? paymentIntent;

  Future <bool> makePayment(String amount) async {
    try{
      paymentIntent = await createPaymentIntent("200", 'MYR');

      var gpay = const PaymentSheetGooglePay(
        merchantCountryCode: "MYS", currencyCode: "MYR", testEnv: true);

        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent![
              'client_secret'],
              merchantDisplayName: 'Syafiqah Rostuah',
              googlePay: gpay
          )).then((value) => {});

      displayPaymentSheet();
      return true;
    } catch(err){
      print(err);
      return false;
    }
  }

   displayPaymentSheet() async{
    try{
      await Stripe.instance.presentPaymentSheet().then((value){
        print("Payment Succesfully");
      });
    } catch(e){
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency)async{
    try{
      Map<String, dynamic> body ={
        "amount" : amount,
        "currency" : currency,
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers:{
          'Authorization': 'Bearer sk_test_51NVGM1J7QsZfEUPTXjd2iJa9K8OtUWufgXrdfm7dATe2Zu8WxR6gVavD9ywPwgtNn9vQ1aJMtMO7165UcWZCHKsa00M5RUpfjZ',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }
}