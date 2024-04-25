//
//
// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;
//
// class StripePayment extends StatefulWidget {
//   const StripePayment({super.key});
//
//   @override
//   State<StripePayment> createState() => _StripePaymentState();
// }
//
// class _StripePaymentState extends State<StripePayment> {
//
//   Map ? paymentData;
//
//   initiallize()async {
//     WidgetsFlutterBinding.ensureInitialized();
//     Stripe.publishableKey="pk_test_51P8dHDSB3vNhGCu27kfYJRnX1v2tw18JjC76XCJ9HkA2C4pvdA78cIaTf0NHyh1NJikZBB6geMXPyYyPQQTKkI3q00eaMHbH1v";
//
//     makePayment();
//
//   }
//
//   makePayment() async{
//
//     try{
//
//       paymentData= await createPaymentIndent("100", "USD");
//       await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: paymentData!['Client_secret'],
//         // applePay: true,
//         // googlePay: true,
//         style: ThemeMode.dark,
//         merchantDisplayName: 'Fuzail Raza',
//       ));
//
//
//       displayPaymentSheet();
//
//     }
//     catch (ex){
//       print(ex.toString());
//     }
//
//   }
//
//   displayPaymentSheet()async{
//
//     try{
//
//       // await Stripe.instance.presentPaymentSheet(
//       //   options: PresentPaymentSheetParameters(clientSecret: 'Client_secret'),
//       //   confirmPayment:true
//       // );
//
//       setState(() {
//         paymentData=null;
//       });
//
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Paid Successfully")));
//
//     }
//     on StripeException catch (ex){
//       print(ex.toString());
//       showDialog(context: context, builder: (context) => AlertDialog(
//         content: Text("Cancelled"),
//       ),);
//     }
//
//   }
//
//   createPaymentIndent(String amount,String currency) async{
//
//     try{
//
//       Map body={
//
//         'amount':amount,
//         'currency':currency,
//         'payment_method_type[]':'card'
//
//       };
//
//       var uri="https://api.stripe.com/v1/payment_intents";
//
//       var response=await http.post(
//         Uri.parse(uri),
//         body: body,
//         headers: {
//           'Authorization':'Bearer sk_test_51P8dHDSB3vNhGCu2im6TpvlZIq4j2MXcj8jVX9ajpjBsTZyCSxKZXowYPLls2czZj604smY7slzg9J9rEQ94faaZ00Js647raP',
//           'Content-Type':'application/x-wwww-form-urlencoded'
//         }
//       );
//
//       return jsonDecode(response.body.toString());
//     }
//     catch(ex){
//
//       print(ex.toString());
//
//     }
//
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//
//           ElevatedButton(onPressed:() => initiallize(), child: Text("Pay"))
//
//
//         ],
//       ),
//
//     );
//   }
// }
