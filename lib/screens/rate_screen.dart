import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  State<RateScreen> createState() => _RateScreenState();
}
class _RateScreenState extends State<RateScreen> {
StateMachineController? controller;
  SMIBool? isChecking;
  SMITrigger? trigSuccess;
  SMITrigger? trigFail;
  SMINumber? numLook; 

@override 
 Widget build(BuildContext context) {
    //para obtener el tamaño de la pantalla (dispositivo)
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                height: 200,
                child: RiveAnimation.asset(
                  'assets/animated_login_character.riv'
                )
           ),
           const SizedBox(height: 20),
           //texto abajo del osito
           Text(
            'Enjoying Sounter?' ,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.bold,
            ),
           ),
           const SizedBox(height: 20),
            Text(
              'With how many stars do \n you rate your experience. \n Tap a star to rate!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.grey,
                ),
            ),
            const SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber
              ),
              onRatingUpdate: (rating) {
                print(rating); 
              },
            ),
            const SizedBox(height: 20),
            MaterialButton(
              onPressed: () {},
              color: const Color.fromARGB(255, 110, 33, 243),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 130,
                ),
                child: Text(
                  'Rate now',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
             MaterialButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 130,
                ),
                child: Text(
                  'NO THANKS',
                  style: TextStyle(
                    color: Color.fromARGB(255, 110, 33, 243),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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