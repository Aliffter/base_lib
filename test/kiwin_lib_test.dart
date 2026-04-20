import 'package:flutter_test/flutter_test.dart';
import 'package:kiwin_lib/src/extension/num_extension.dart';

void main() {
  group('NumSafeExt', () {
    test('safeNum returns the original positive value', () {
      expect(12.safeNum(), 12.0);
      expect(0.5.safeNum(), 0.5);
    });

    test(
      'safeNum returns default value for null, zero, and negative values',
      () {
        num? emptyValue;

        expect(emptyValue.safeNum(), 0.01);
        expect(0.safeNum(), 0.01);
        expect((-1).safeNum(defaultValue: 1), 1);
      },
    );
  });

  group('NumFormatExt', () {
    test('toRound supports rounding and truncating', () {
      expect(123.555.toRound(2), 123.56);
      expect(123.555.toRound(2, false), 123.55);
    });

    test('toDecimal supports all decimal round types', () {
      expect(1.235.toDecimal(2), 1.24);
      expect(1.239.toDecimal(2, DecimalRoundType.truncate), 1.23);
      expect(1.231.toDecimal(2, DecimalRoundType.ceil), 1.24);
      expect(1.239.toDecimal(2, DecimalRoundType.floor), 1.23);
    });

    test('formatDecimalStr keeps or trims trailing zeros', () {
      expect(12.3.formatDecimalStr(2), '12.30');
      expect(12.3.formatDecimalStr(2, true), '12.3');
      expect(12.0.formatDecimalStr(2, true), '12');
    });

    test('formatCurrency adds separators and handles decimal round types', () {
      expect(1234.567.formatCurrency(), '1,234.57');
      expect(1234.567.formatCurrency(2, DecimalRoundType.truncate), '1,234.56');
      expect(1234.561.formatCurrency(2, DecimalRoundType.ceil), '1,234.57');
      expect(1234.569.formatCurrency(2, DecimalRoundType.floor), '1,234.56');
    });
  });
}
