import '../models/prenda.dart';

class RecommendationService {
  final int tagMatchScore;
  final int sameIaKeyScore;

  const RecommendationService({
    this.tagMatchScore = 10,
    this.sameIaKeyScore = 20,
  });

  List<Prenda> recommend({
    required Prenda base,
    required Map<String, String> respuestas,
    required Iterable<Prenda> catalogo,
    int limit = 10,
  }) {
    // Convertimos respuestas en preferencias (MVP)
    final List<String> preferTags = <String>[];
    for (final entry in respuestas.entries) {
      preferTags.add(_norm(entry.value));
    }

    final List<_ScoredPrenda> scored = <_ScoredPrenda>[];

    for (final prenda in catalogo) {
      if (prenda.codigo == base.codigo) continue;

      int score = 0;

      // Bonus por “tipo” (iaKey)
      if (_norm(prenda.iaKey) == _norm(base.iaKey)) {
        score += sameIaKeyScore;
      }

      // Match por tags con prenda base
      score += _intersectionCount(base.tags, prenda.tags) * tagMatchScore;

      // Match por preferencias (de respuestas)
      score += _intersectionCount(preferTags, prenda.tags) * tagMatchScore;

      if (score > 0) scored.add(_ScoredPrenda(prenda, score));
    }

    scored.sort((a, b) => b.score.compareTo(a.score));

    final List<Prenda> res = <Prenda>[];
    for (final s in scored) {
      res.add(s.prenda);
      if (res.length >= limit) break;
    }
    return res;
  }

  int _intersectionCount(List<String> a, List<String> b) {
    int count = 0;
    for (final x in a) {
      final nx = _norm(x);
      for (final y in b) {
        if (nx == _norm(y)) {
          count++;
          break;
        }
      }
    }
    return count;
  }

  String _norm(String s) => s.toLowerCase().trim();
}

class _ScoredPrenda {
  final Prenda prenda;
  final int score;
  _ScoredPrenda(this.prenda, this.score);
}
