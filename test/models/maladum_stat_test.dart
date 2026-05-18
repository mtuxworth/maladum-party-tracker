import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_maladum/models/maladum_stat.dart';

void main() {
  group('MaladumStat', () {
    test('current starts at starting value', () {
      final stat = MaladumStat(starting: 5, potential: 10);
      expect(stat.current, equals(5));
    });

    test('starting and potential are set correctly', () {
      final stat = MaladumStat(starting: 3, potential: 8);
      expect(stat.starting, equals(3));
      expect(stat.potential, equals(8));
    });

    test('toJson contains all three values', () {
      final stat = MaladumStat(starting: 2, potential: 6);
      stat.current = 4;
      final json = stat.toJson();
      expect(json['starting'], equals(2));
      expect(json['current'], equals(4));
      expect(json['potential'], equals(6));
    });

    test('fromJson restores all three values', () {
      final json = {'starting': 2, 'current': 4, 'potential': 6};
      final stat = MaladumStat.fromJson(json);
      expect(stat.starting, equals(2));
      expect(stat.current, equals(4));
      expect(stat.potential, equals(6));
    });

    test('fromJson accepts legacy max key', () {
      final json = {'starting': 2, 'current': 4, 'max': 6};
      final stat = MaladumStat.fromJson(json);
      expect(stat.potential, equals(6));
    });

    test('JSON round-trip preserves mid-game state', () {
      final original = MaladumStat(starting: 5, potential: 10);
      original.current = 3;
      final restored = MaladumStat.fromJson(original.toJson());
      expect(restored.starting, equals(original.starting));
      expect(restored.current, equals(original.current));
      expect(restored.potential, equals(original.potential));
    });
  });
}
