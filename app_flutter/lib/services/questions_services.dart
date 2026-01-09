import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:smart_fitting/models/pregunta.dart';

class QuestionsService {
  // ---------------------------
  // Configuración backend
  // ---------------------------

  final String baseUrl;
  final String questionsPath;

  // ---------------------------
  // Constructor
  // ---------------------------

  QuestionsService({
    required this.baseUrl,
    this.questionsPath = '/questions',
  });

  // ---------------------------
  // Construcción de la URL
  // ---------------------------

  Uri _questionsUri(String iaKey) {
    return Uri.parse('$baseUrl$questionsPath').replace(
      queryParameters: <String, String>{
        'ia_key': iaKey,
      },
    );
  }

  // ---------------------------
  // Obtener preguntas
  // ---------------------------

  Future<List<Pregunta>> getQuestions(String iaKey) async {
    final Uri url = _questionsUri(iaKey);

    late http.Response response;

    try {
      response = await http.get(url);
    } catch (e) {
      throw Exception('No se pudo conectar a la red ($url): $e');
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Error al cargar preguntas. HTTP ${response.statusCode}. URL: $url',
      );
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw const FormatException('Respuesta inválida: no es JSON válido');
    }

    if (decoded is! List) {
      throw const FormatException('Preguntas inválidas: se esperaba una lista JSON');
    }

    final List<Pregunta> preguntas = <Pregunta>[];

    for (final item in decoded) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Preguntas inválidas: item no es un objeto JSON');
      }

      preguntas.add(Pregunta.fromJson(item));
    }

    return preguntas;
  }
}
