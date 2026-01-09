import 'package:smart_fitting/models/prenda.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



class CatalogService {
 final Map<String,Prenda> _catalogo = {};


 final String baseUrl;
 final String catalogPath;

 CatalogService({
   required this.baseUrl,
   this.catalogPath = '/catalog'
});



 Uri _catalogUri() {
   return Uri.parse('$baseUrl$catalogPath');
 }


 Future<void> loadCatalog() async {
   final Uri url = _catalogUri();
   late http.Response response;
   try {
     response = await http.get(url);
   } catch (e) {
     // Aca atrapo error de conexion a Internet
     throw Exception('No se pudo establecer conexion a la red ($url): $e');
   }


   if (response.statusCode != 200) {
     throw Exception('Error al cargar el catalogo. HTTP ${response.statusCode}. URL: $url',
     );
   }

   final dynamic decoded;
   try {
    decoded = jsonDecode(response.body);
   } catch(e) {
     throw const FormatException('Respuesta Invalida: el JSON no es valido');
   }

   if (decoded is! List) {
   throw const FormatException('Catalogo invalido: se esperaba una lista JSON');
   }

   // Si llego bien, refrescamos el mapa en su totalidad


   _catalogo.clear();


   for (final item in decoded) {
     if (item is! Map<String, dynamic>) {
     throw const FormatException('Catalogo invalido: item no es un objeto JSON');
     }

    final Prenda prenda = Prenda.fromJson(item);

     if(_catalogo.containsKey(prenda.codigo)) {
       throw FormatException('Catalogo invalido: codigo duplicado "${prenda.codigo}"');
     }

     _catalogo[prenda.codigo] = prenda;

   }

 }




 Prenda? findByCodigo(String codigo) {
   return _catalogo[codigo];
 }


}