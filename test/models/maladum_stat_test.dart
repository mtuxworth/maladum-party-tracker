import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_maladum/models/maladum_stat.dart';

void main() {
  group('MaladumStat', () {
    test('current starts at starting value', () {
      final stat = MaladumStat(starting: 5, max: 10);
      expect(stat.current, equals(5));
    });

    test('starting and max are set correctly', () {
      final stat = MaladumStat(starting: 3, max: 8);
      expect(stat.starting, equals(3));
      expect(stat.max, equals(8));
    });

    test('toJson contains all three values', () {
      final stat = MaladumStat(starting: 2, max: 6);
      stat.current = 4;
      final json = stat.toJson();
      expect(json['starting'], equals(2));
      expect(json['current'], equals(4));
      expect(json['max'], equals(6));
    });

    test('fromJson restores all three values', () {
      final json = {'starting': 2, 'current': 4, 'max': 6};
      final stat = MaladumStat.fromJson(json);
      expect(stat.starting, equals(2));
      expect(stat.current, equals(4));
      expect(stat.max, equals(6));
    });

    test('JSON round-trip preserves mid-game state', () {
      final original = MaladumStat(starting: 5, max: 10);
      original.current = 3;
      final restored = MaladumStat.fromJson(original.toJson());
      expect(restored.starting, equals(original.starting));
      expect(restored.current, equals(original.current));
      expect(restored.max, equals(original.max));
    });
  });
}
