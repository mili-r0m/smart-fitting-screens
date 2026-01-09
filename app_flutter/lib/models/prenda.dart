import 'dart:collection';

class Prenda{
  final String codigo;
  final String nombre;
  final String iaKey;
  final List<String> tags;
  final String imageUrl;
  final List<String> talles;


  Prenda({
    required this.codigo,
    required this.nombre,
    required this.iaKey,
    required this.tags,
    required this.imageUrl,
    required this.talles
  });

  factory Prenda.fromJson(Map<String, dynamic> json) {
    final dynamic codigoRaw = json['codigo'];
    final dynamic nombreRaw = json['nombre'];
    final dynamic iaKeyRaw = json['ia_key'];
    final dynamic tagsRaw = json['tags'];
    final dynamic imageUrlRaw = json['image_u rl'];
    final dynamic tallesRaw = json['talles'];

    if (codigoRaw is! String || codigoRaw.trim().isEmpty) {
      throw const FormatException('Prenda inválida: "codigo" faltante o no es String');
    }

    if (nombreRaw is! String || nombreRaw.trim().isEmpty) {
      throw const FormatException('Prenda inválida: "nombre" faltante o no es String');
    }

    if (iaKeyRaw is! String || iaKeyRaw.trim().isEmpty) {
      throw const FormatException('Prenda inválida: "ia_key" faltante o no es String');
    }

    if (tagsRaw is! List) {
      throw const FormatException('Prenda inválida: "tags" faltante o no es List');
    }

    // chequeo: todos los elementos deben ser String
    for (final t in tagsRaw) {
      if (t is! String) {
        throw const FormatException('Prenda inválida: "tags" contiene elementos no String');
      }
    }
    // chequeo si imageUrlRaw es String
    if (imageUrlRaw is! String || imageUrlRaw.isEmpty) {
      throw const FormatException('URL de imagen invalida');
    }


    List<String> talles = <String> [];

    if (tallesRaw == null) {
      talles = <String>[];
    } else{
      if (tallesRaw is! List) {
        throw const FormatException('Prenda invalida: talles no es List');
      }
      for (final medida in tallesRaw) {
        if (medida is! String) {
          throw const FormatException('Prenda invalida: medida en talles no es String');
        }
        talles = tallesRaw.cast<String>();
      }
    }


    // Casteo a String las listas correspondientes a los campos 'tags' y 'talles'
    final List<String> tags = tagsRaw.cast<String>();
    // ----------------------------------------------------------------------------------



    return Prenda(
      codigo: codigoRaw,
      nombre: nombreRaw,
      iaKey: iaKeyRaw,
      tags: tags,
      imageUrl: imageUrlRaw,
      talles: talles,
    );
  }
}