import 'package:flutter/material.dart';

import '../../models/prenda.dart';
import '../../models/pregunta.dart';

import '../idle/idle_screen.dart';
import '../questions/questions_screen.dart';
import '../result/result_screen.dart';
import '../detail/prenda_detail_screen.dart';

class DebugHomeScreen extends StatelessWidget {
  const DebugHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --------
    // Datos fake para probar todas las pantallas
    // --------

    final Prenda base = Prenda(
      codigo: '123',
      nombre: 'Remera negra (Base)',
      iaKey: 'remera_basica',
      tags: const ['casual', 'basico', 'algodon'],
      imageUrl: 'https://via.placeholder.com/600x800',
      talles: ['XL','S','M']
    );

    final List<Pregunta> preguntas =  [
      Pregunta(id: 'uso', texto: '¿Para qué ocasión?', opciones: ['Trabajo', 'Salida', 'Diario']),
      Pregunta(id: 'fit', texto: '¿Cómo te gusta el calce?', opciones: ['Ajustado', 'Regular', 'Oversize']),
      Pregunta(id: 'color', texto: '¿Qué colores preferís?', opciones: ['Negro', 'Blanco', 'Azul', 'Gris']),
    ];

    final List<Prenda> recomendadas = [
      Prenda(
        codigo: '200',
        nombre: 'Campera denim',
        iaKey: 'campera',
        tags: const ['casual', 'denim', 'oversize'],
        imageUrl: 'https://via.placeholder.com/600x800?text=Campera',
        talles: ['XL','S','M']
      ),
      Prenda(
        codigo: '201',
        nombre: 'Pantalón sastrero',
        iaKey: 'pantalon',
        tags: const ['office', 'formal-casual', 'gris'],
        imageUrl: 'https://via.placeholder.com/600x800?text=Pantalon',
        talles: ['XL','S','M']
      ),
      Prenda(
        codigo: '202',
        nombre: 'Zapatillas urbanas',
        iaKey: 'zapas',
        tags: const ['casual', 'urbano', 'negro'],
        imageUrl: 'https://via.placeholder.com/600x800?text=Zapas',
        talles: ['XL','S','M']
      ),
    ];

    final List<String> banners = const [
      'https://via.placeholder.com/1200x300?text=Banner+1',
      'https://via.placeholder.com/1200x300?text=Banner+2',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Debug Menu')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _NavButton(
            label: 'IdleScreen',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const IdleScreen()),
            ),
          ),
          _NavButton(
            label: 'QuestionsScreen (fake)',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuestionsScreen(
                  prendaBase: base,
                  preguntas: preguntas,
                ),
              ),
            ),
          ),
          _NavButton(
            label: 'ResultScreen (fake)',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ResultScreen(
                  prendaBase: base,
                  recomendadas: recomendadas,
                  bannerImageUrls: banners,
                ),
              ),
            ),
          ),
          _NavButton(
            label: 'PrendaDetailScreen (plantilla + cambio)',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PrendaDetailScreen(
                  initialPrenda: recomendadas.first,
                  recomendadas: recomendadas,
                  bannerImageUrls: banners,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NavButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }
}
