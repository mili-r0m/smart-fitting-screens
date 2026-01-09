import 'package:flutter/material.dart';
import '../../models/prenda.dart';
import '../../config/ui_config.dart';



class PrendaDetailScreen extends StatefulWidget {
  final Prenda initialPrenda;
  final List<Prenda> recomendadas;
  final List<String> bannerImageUrls;

  const PrendaDetailScreen({
    super.key,
    required this.initialPrenda,
    required this.recomendadas,
    this.bannerImageUrls = const [],
  });

  @override
  State<PrendaDetailScreen> createState() => _PrendaDetailScreenState();
}

class _PrendaDetailScreenState extends State<PrendaDetailScreen> {
  late Prenda _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initialPrenda;
  }

  void _selectPrenda(Prenda p) {
    setState(() => _selected = p);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: SafeArea(
        child: Column(
          children: [
            // 1) Hero con prenda seleccionada
            Expanded(
              flex: 7,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _PrendaHeroCard(prenda: _selected),
              ),
            ),

            // 2) Recomendaciones horizontal
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
                'RECOMENDACIONES',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            SizedBox(
              height: 190,
              child: widget.recomendadas.isEmpty
                  ? Center(
                child: Text(
                  'No hay recomendaciones disponibles.',
                  style: theme.textTheme.bodyMedium,
                ),
              )
                  : ListView.separated(
                padding: const EdgeInsets.all(12),
                scrollDirection: Axis.horizontal,
                itemCount: widget.recomendadas.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final prenda = widget.recomendadas[index];
                  final bool active = prenda.codigo == _selected.codigo;

                  return _RecomendacionCard(
                    prenda: prenda,
                    active: active,
                    onTap: () => _selectPrenda(prenda),
                  );
                },
              ),
            ),

            // 3) Banners
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
                child: _BannersStrip(bannerImageUrls: widget.bannerImageUrls),
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
  const _PrendaHeroCard({required this.prenda});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary, width: 3),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Image(
              image: UIConfig.useGenericImages
                  ?  AssetImage(UIConfig.placeholderAsset)
                  : NetworkImage(prenda.imageUrl) as ImageProvider,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  prenda.nombre,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text('Código: ${prenda.codigo}')),
                    const SizedBox(height: 8),
                    _TextTallesChips(talles: prenda.talles),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tags: ${prenda.tags.join(", ")}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RecomendacionCard extends StatelessWidget {
  final Prenda prenda;
  final VoidCallback onTap;
  final bool active;

  const _RecomendacionCard({
    required this.prenda,
    required this.onTap,
    this.active = false,
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
            border: Border.all(
              color: theme.colorScheme.primary,
              width: active ? 3 : 2,
            ),
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
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
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

    if (bannerImageUrls.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          'BANNERS PUBLICITARIOS',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
      );
    }

    return PageView.builder(
      itemCount: bannerImageUrls.length,
      itemBuilder: (_, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            bannerImageUrls[index],
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Center(
              child: Text('Banner no disponible', style: theme.textTheme.bodyMedium),
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
