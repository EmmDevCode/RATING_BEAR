import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:async';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  State<RateScreen> createState() => _RateScreenState();
}
class _RateScreenState extends State<RateScreen> {
StateMachineController? controller;
SMIBool? isHandsUp;
  SMIBool? isChecking;
  SMITrigger? trigSuccess;
  SMITrigger? trigFail;
  SMINumber? numLook; 
  
  Timer? _gazeResetTimer; // Timer para reinicar la mirada
  Timer? _reactionTimer; // Dispara "fail" o "success" después de un retraso

  double _getLookValue(double rating) { //convertir calificacion en mirada
    return ((rating - 1) / 4) * 80;
  }

  void _onRatingChanged(double rating) {
    // cancela cualquier timer activo
  _gazeResetTimer?.cancel();
  _reactionTimer?.cancel();

  
  isHandsUp?.change(false);

  //Ejecutar animación asincrónica
  Future.delayed(Duration.zero, () async { 
    if (!mounted) return; //evita errores si el widget fue destruido

    final lookValue = _getLookValue(rating);

    // Mira directamente a la estrella seleccionada
    isChecking?.change(true);
    numLook?.value = lookValue;

    await Future.delayed(const Duration(seconds: 0)); // Permitir que la animación de mirada comience

    //Reacción 
    if (rating <= 2.0) {
      trigFail?.fire();
    } else if (rating >= 4.0) {
      trigSuccess?.fire();
    }

    //Esperar a que termine la animación 
    await Future.delayed(const Duration(seconds: 4));

    if (!mounted) return;

    //Asegurar mirada final en la estrella seleccionada 
    isChecking?.change(true);
    numLook?.value = lookValue;
  });
}

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
                  'assets/animated_login_character.riv',
                  stateMachines: ["Login Machine"],
                  onInit: (artboard) {
                    controller = StateMachineController.fromArtboard(
                      artboard,
                      "Login Machine",
                    );
                    if (controller == null) return;
                    artboard.addController(controller!);
                    isChecking = controller!.findSMI<SMIBool>('isChecking');
                    isHandsUp = controller!.findSMI<SMIBool>('isHandsUp');
                    trigSuccess = controller!.findSMI('trigSuccess');
                    trigFail = controller!.findSMI('trigFail');
                    numLook = controller!.findSMI('numLook');

                    // Estado inicial neutral
                    isHandsUp?.change(false);
                    isChecking?.change(false);
                    numLook?.value = 50.0;
                  },
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
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber
              ),
              onRatingUpdate: (rating) {
                _onRatingChanged(rating); 
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
            const SizedBox(height: 20),
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
  
  //liberar memoria 
  @override
  void dispose() {
    controller?.dispose();
    _gazeResetTimer?.cancel();
    _reactionTimer?.cancel();
    super.dispose();
  }

}