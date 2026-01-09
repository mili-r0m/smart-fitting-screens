
import 'package:flutter/material.dart';
import '../../models/prenda.dart';
import '../../models/pregunta.dart';
import '../../routes/app_routes.dart';
import '../result/result_screen.dart';



class QuestionsScreen extends StatefulWidget {
  final Prenda prendaBase;
  final List<Pregunta> preguntas;

  const QuestionsScreen({
    super.key,
    required this.prendaBase,
    required this.preguntas,
  });

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int _currentIndex = 0;
  final Map<String, String> _respuestas = {};

  @override
  Widget build(BuildContext context) {
    final Pregunta preguntaActual = widget.preguntas[_currentIndex];
    final String? respuestaElegida = _respuestas[preguntaActual.id];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pregunta ${_currentIndex + 1} de ${widget.preguntas.length}',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.1, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Column(
                key: ValueKey<int>(_currentIndex), // 🔑 CLAVE
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    preguntaActual.texto,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  ...preguntaActual.opciones.map((opcion) {
                    final bool seleccionada = opcion == respuestaElegida;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          seleccionada ? Colors.black : Colors.white,
                          foregroundColor:
                          seleccionada ? Colors.white : Colors.black,
                          side: const BorderSide(color: Colors.black),
                        ),
                        onPressed: () {
                          setState(() {
                            _respuestas[preguntaActual.id] = opcion;
                          });
                        },
                        child: Text(opcion),
                      ),
                    );
                  }),
                ],
              ),
            ),


            const Spacer(),

            // Botón siguiente
            ElevatedButton(
              onPressed: respuestaElegida == null
                  ? null
                  : () {
                setState(() {
                  if (_currentIndex <
                      widget.preguntas.length - 1) {
                    _currentIndex++;
                  } else {
                    _finalizar();
                  }
                });
              },
              child: Text(
                _currentIndex < widget.preguntas.length - 1
                    ? 'Siguiente'
                    : 'Finalizar',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _finalizar() {
    final List<Prenda> recomendadas = <Prenda> [
      Prenda(
        codigo: '200',
        nombre: 'Campera denim',
        iaKey: 'campera',
        tags: const ['casual', 'denim'],
        imageUrl: 'https://via.placeholder.com/600x800?text=Campera',
        talles:['XL','S','M']
      ),
      Prenda(
        codigo: '201',
        nombre: 'Pantalón sastrero',
        iaKey: 'pantalon',
        tags: const ['office', 'formal-casual'],
        imageUrl: 'https://via.placeholder.com/600x800?text=Pantalon',
        talles: ['XL','S','M'],
      ),
    ];;
    Navigator.pushReplacement(
      context,
      fadeSlideRoute(
        ResultScreen(prendaBase: widget.prendaBase, recomendadas: recomendadas),
      ),
    );

  }
}

