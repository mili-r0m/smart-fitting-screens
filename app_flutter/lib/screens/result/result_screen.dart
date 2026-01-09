import 'package:flutter/material.dart';
import '../../models/prenda.dart';
import '../detail/prenda_detail_screen.dart';
import '../../config/ui_config.dart';






class ResultScreen extends StatelessWidget {
  final Prenda prendaBase;
  final List<Prenda> recomendadas;

  // Si querés banners por URL (opcional)
  final List<String> bannerImageUrls;

  const ResultScreen({
    super.key,
    required this.prendaBase,
    required this.recomendadas,
    this.bannerImageUrls = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recomendaciones'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // -----------------------
            // 1) DETALLE PRENDA (arriba)
            // -----------------------
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(12),
                  child: _PrendaHeroCard(
                    prenda: prendaBase,
                    recomendadas: recomendadas,
                    bannerImageUrls: bannerImageUrls,
                  ),
              ),
            ),

            // -----------------------
            // 2) RECOMENDACIONES (scroll horizontal)
            // -----------------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: theme.colorScheme.primary, width: 2),
                  bottom: BorderSide(color: theme.colorScheme.primary, width: 2),
                ),
              ),
              child: Text(
                'RECOMENDACIONES DESPUÉS DE RESPONDER PREGUNTAS',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            SizedBox(
              height: 190,
              child: recomendadas.isEmpty
                  ? Center(
                child: Text(
                  'No hay recomendaciones disponibles.',
                  style: theme.textTheme.bodyMedium,
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.all(12),
                scrollDirection: Axis.horizontal,
                itemCount: recomendadas.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final prenda = recomendadas[index];
                  return _RecomendacionCard(
                    prenda: prenda,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PrendaDetailScreen(
                            initialPrenda: prenda,
                            recomendadas: recomendadas,
                            bannerImageUrls: bannerImageUrls,
                          ),

                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // -----------------------
            // 3) BANNERS (abajo)
            // -----------------------
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: theme.colorScheme.primary, width: 2),
                  ),
                ),
                child: _BannersStrip(
                  bannerImageUrls: bannerImageUrls,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrendaHeroCard extends StatelessWidget {
  final Prenda prenda;
  final List<Prenda> recomendadas;
  final List<String> bannerImageUrls;

  const _PrendaHeroCard({
    required this.prenda,
    required this.recomendadas,
    required this.bannerImageUrls
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PrendaDetailScreen(
            initialPrenda: prenda,
            recomendadas: recomendadas,
            bannerImageUrls: bannerImageUrls,
          ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.primary, width: 3),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            // Imagen grande (tipo “hero”)
            Expanded(
              child: Image(
                image: UIConfig.useGenericImages
                    ? AssetImage(UIConfig.placeholderAsset)
                    : NetworkImage(prenda.imageUrl) as ImageProvider,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            // Info rápida
      Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              prenda.nombre,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Código: ${prenda.codigo}',
              style: theme.textTheme.bodyMedium,
            ),

            const SizedBox(height: 8),

            _TextTallesChips(talles: prenda.talles),
          ],
        ),
      ),
          ],
        ),
      ),
    );
  }
}

class _RecomendacionCard extends StatelessWidget {
  final Prenda prenda;
  final VoidCallback onTap;

  const _RecomendacionCard({
    required this.prenda,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 140,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.primary, width: 2),
            borderRadius: BorderRadius.circular(14),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Expanded(
                child: Image(
                  image: UIConfig.useGenericImages
                      ? AssetImage(UIConfig.placeholderAsset)
                      : NetworkImage(prenda.imageUrl) as ImageProvider,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  prenda.nombre,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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

class _BannersStrip extends StatelessWidget {
  final List<String> bannerImageUrls;

  const _BannersStrip({required this.bannerImageUrls});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Si todavía no tenés banners reales, mostramos placeholders
    if (bannerImageUrls.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          'BANNERS PUBLICITARIOS',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }

    // Si hay varios banners, podés rotarlos con PageView (swipe)
    return PageView.builder(
      itemCount: bannerImageUrls.length,
      itemBuilder: (context, index) {
        final url = bannerImageUrls[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              alignment: Alignment.center,
              child: Text(
                'Banner no disponible',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TextTallesChips extends StatelessWidget {
  final List<String> talles;
  const _TextTallesChips({required this.talles});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (talles.isEmpty) {
      return Text(
        'Talles: -',
        style: theme.textTheme.bodyMedium,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Talles:', style: theme.textTheme.bodyMedium),
        const SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: talles.map((t) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.primary),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(t),
            );
          }).toList(),
        ),
      ],
    );
  }
}

