import 'package:flutter/material.dart';

import '../models/game_keyword.dart';

class IconReferenceView extends StatelessWidget {
  const IconReferenceView({super.key});

  static void show(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const IconReferenceView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categories = KeywordCategory.values;

    return Scaffold(
      appBar: AppBar(title: const Text('Icon Reference')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: categories.map((cat) {
          final keywords =
              kAllKeywords.where((k) => k.category == cat).toList();
          if (keywords.isEmpty) return const SizedBox.shrink();
          return _CategorySection(category: cat, keywords: keywords);
        }).toList(),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final KeywordCategory category;
  final List<GameKeyword> keywords;

  const _CategorySection({required this.category, required this.keywords});

  String get _label => switch (category) {
        KeywordCategory.activation => 'Activation Types',
        KeywordCategory.status => 'Status Effects',
        KeywordCategory.combat => 'Combat & Stats',
        KeywordCategory.damageType => 'Damage Types',
        KeywordCategory.ability => 'Abilities',
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            _label.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF9E9E9E),
                  letterSpacing: 1.2,
                ),
          ),
        ),
        ...keywords.map((kw) => _KeywordRow(keyword: kw)),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _KeywordRow extends StatelessWidget {
  final GameKeyword keyword;

  const _KeywordRow({required this.keyword});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon badge — real game icon image.
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF444444)),
            ),
            padding: const EdgeInsets.all(4),
            child: Image.asset(
              keyword.imagePath,
              filterQuality: FilterQuality.medium,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  keyword.keyword,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFFF5F5F5),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  keyword.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9E9E9E),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
