import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_fitting/screens/questions/questions_screen.dart';
import '../../routes/app_routes.dart';




class IdleScreen extends StatefulWidget {
  const IdleScreen({super.key});

  @override
  State<IdleScreen> createState() => _IdleScreenState();
}

class _IdleScreenState extends State<IdleScreen> with SingleTickerProviderStateMixin {
  final FocusNode _focusNode = FocusNode();
  String _buffer = '';

  late final AnimationController _bgController;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bgController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onKey(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter) {
        if (_buffer.isNotEmpty) {
          _buscarPrenda(_buffer);
          _buffer = '';
        }
      } else {
        final String? key = event.character;
        if (key != null && key.isNotEmpty) {
          _buffer += key;
        }
      }
    }
  }

  void _buscarPrenda(String codigo) {
    debugPrint('Buscando prenda con código: $codigo');
    // TODO: llamar a CatalogService y navegar


  }

  void _abrirBusquedaManual() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Buscar prenda manualmente'),
            TextField(
              autofocus: true,
              onSubmitted: (value) {
                Navigator.pop(context);
                _buscarPrenda(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RawKeyboardListener(
      focusNode: _focusNode,
      onKey: _onKey,
      child: Scaffold(
        body: Stack(
          children: [
            // -----------------------
            // Fondo tipo “salvapantallas”
            // -----------------------
          AnimatedBuilder(
          animation: _bgController,
          builder: (context, _) {
            final t = _bgController.value; // 0..1

            return Stack(
              children: [
                // Fondo base
                Container(color: Theme.of(context).colorScheme.background),

                // Burbuja 1 (se mueve)
                Align(
                  alignment: Alignment(-1.0 + 2.0 * t, -0.6),
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
                    ),
                  ),
                ),

                // Burbuja 2 (se mueve al revés)
                Align(
                  alignment: Alignment(1.0 - 2.0 * t, 0.7),
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

            // -----------------------
            // Tu UI actual encima
            // -----------------------
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Escaneá una prenda',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _abrirBusquedaManual,
                    child: const Text('Buscar manualmente'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
