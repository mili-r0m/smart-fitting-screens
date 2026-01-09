class Pregunta {
  final String id;
  final String texto;
  final List<String> opciones;

  Pregunta({
    required this.id,
    required this.texto,
    required this.opciones
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    final dynamic idPreguntaRaw = json['id'];
    final dynamic textoRaw = json['texto'];
    final dynamic opcionesRaw = json['opciones'];


    // chequeo si idPreguntaRaw es string y distinto de Vacio
    if (idPreguntaRaw is! String || idPreguntaRaw.trim().isEmpty) {
    throw const FormatException('id invalido');
    }

    // chequeo si textoRaw es string y distinto de Vacio
    if (textoRaw is! String || textoRaw.trim().isEmpty) {
      throw const FormatException('Texto invalido');
    }

    // chequeo si opcionesRaw es List<string>
    if (opcionesRaw is! List) {
      throw const FormatException('Opciones invalidas');
    }


    // chequeo si los elem en opcionesRaw son String
    for (final elem in opcionesRaw) {
      if (elem is! String) {
        throw const FormatException('Lista con opciones invalidas');
      }
    }
    final List<String> opciones = opcionesRaw.cast<String>();

    return Pregunta(
      id: idPreguntaRaw,
      texto: textoRaw,
      opciones: opciones,
    );

  }


}