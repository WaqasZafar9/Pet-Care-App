import 'package:flutter/material.dart';

class PaymentForm extends StatefulWidget {
  const PaymentForm({super.key});

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  String userName = "Fuzail";
  GlobalKey<FormState> paymentForm=GlobalKey<FormState>();
  var cardNumber=TextEditingController();
  var cardHolderName=TextEditingController();
  var CVV=TextEditingController();
  var DateExpiry=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Welcome " + userName),
      ),
      body: Container(
        color: Colors.grey.shade100,
          child: Form(
        key: paymentForm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Text("Card Holder Name"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:28.0,right:28.0,bottom:15.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: cardHolderName,
                keyboardType:TextInputType.emailAddress ,
                decoration: InputDecoration(
                  hintText: "Name",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) => validateCard(value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                  ),
                  Text("Card Number"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:28.0,right:28.0,bottom:15.0),
              child: TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: cardNumber,
                keyboardType:TextInputType.emailAddress ,
                decoration: InputDecoration(
                  hintText: "Card Numebr",
                  prefixIcon: Icon(Icons.credit_card),
                ),
                validator: (value) => validateCardNumber(value),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                children: [
                  SizedBox(width: 40,),
                  Text("Expiry"),
                  SizedBox(width: 140),
                  Text("CVV"),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:28.0,right:28.0,bottom:15.0),
                  child: Container(
                    width: 150,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: DateExpiry,
                      keyboardType:TextInputType.emailAddress ,
                      decoration: InputDecoration(
                        hintText: "Expiry",
                        prefixIcon: Icon(Icons.date_range),
                      ),
                      validator: (value) => validateExpiry(value),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left:1.0,right:28.0,bottom:15.0),
                  child: Container(
                    width: 145,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: CVV,
                      keyboardType:TextInputType.emailAddress ,
                      decoration: InputDecoration(
                        hintText: "CVV",
                        prefixIcon: Icon(Icons.security_outlined),

                      ),
                      validator: (value) => validateCVV(value),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){

              }, child: Text("Proceed"),style: ButtonStyle(
                  minimumSize:MaterialStateProperty.all(Size(250,50)) ,
                  elevation: MaterialStateProperty.all(20)
              )),
            )


          ],
        ),
      )),
    );
  }

  validateCard(String? value) {

  }

  validateCardNumber(String? value) {

  }

  validateCVV(String? value) {

  }

  validateExpiry(String? value) {

  }
}
