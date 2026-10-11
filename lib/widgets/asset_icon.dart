import 'package:flutter/material.dart';

class AssetIcon extends StatelessWidget {
  const AssetIcon({
    super.key,
    required this.path,
    required this.label,
    this.size,
    this.color = const Color(0xFF546E7A),
  });

  final String path;
  final String label;
  final double? size;
  final Color color;

  String get _initials {
    final words = label.trim().split(RegExp(r'\s+'));
    if (words.first.isEmpty) return '?';
    if (words.length == 1) {
      return words.first.substring(0, words.first.length.clamp(1, 2));
    }
    return '${words[0][0]}${words[1][0]}';
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: size,
      height: size,
      filterQuality: FilterQuality.medium,
      errorBuilder: (_, _, _) => _buildFallback(),
    );
  }

  // Shown when the icon asset is missing so the UI still reads correctly.
  Widget _buildFallback() {
    return Tooltip(
      message: label,
      child: Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color),
        ),
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(2),
            child: Text(
              _initials.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFFF5F5F5),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
