package thx.format;

import thx.culture.Culture;
import thx.culture.Embed;
import utest.Assert;
import thx.Decimal;
using thx.format.DecimalFormat;

class TestDecimalFormat {
  static var it : Culture = Embed.culture('it-it');
  static var us : Culture = Embed.culture('en-us');
  static var asIn : Culture = Embed.culture('as-in');
  static var baRu : Culture = Embed.culture('ba-ru');
  public function new() {}

  public function testNumber() {
    Assert.equals('1.00',        (1.0 : Decimal).number(2));
    Assert.equals('1.2',         (1.2 : Decimal).number(1));
    Assert.equals('1',           (1 : Decimal).number(0));
    Assert.equals('10,000',      (10000 : Decimal).number(0));
    Assert.equals('12,345.679',  (12345.6789 : Decimal).number(3));

    Assert.equals('-1.00',       (-1.0 : Decimal).number(2));
    Assert.equals('-1.2',        (-1.2 : Decimal).number(1));
    Assert.equals('-1',          (-1 : Decimal).number(0));
    Assert.equals('-10,000',     (-10000 : Decimal).number(0));
    Assert.equals('-12,345.679', (-12345.6789 : Decimal).number(3));

    var exp = (2 : Decimal).pow(50);
    Assert.equals('1,125,899,906,842,624.00', exp.number(2));

    var exp = (2 : Decimal).pow(-18);
    Assert.equals('0.000003814610', exp.number(11));
  }

  public function testCurrency() {
    Assert.equals('(¤12,345.68)', (-12345.6789 : Decimal).currency());
  }

  public function testCurrencyIT() {
    Assert.equals('-€ 12.345,68', (-12345.6789 : Decimal).currency(it));
  }

  public function testCurrencyUS() {
    Assert.equals('($12,345.68)', (-12345.6789 : Decimal).currency(us));
  }

  public function testPercent() {
    Assert.equals('2.33 %', (0.02333 : Decimal).percent());
    Assert.equals('2,33%',  (0.02333 : Decimal).percent(it));
  }

  public function testPermille() {
    Assert.equals('23.33 ‰', (0.02333 : Decimal).permille());
    Assert.equals('23,33‰',  (0.02333 : Decimal).permille(it));
  }

  public function testUnit() {
    Assert.equals('23.33 kg.', (23.3333 : Decimal).unit(2, 'kg.'));
    Assert.equals('23,33kg.',  (23.3333 : Decimal).unit(2, 'kg.', it));
  }

  public function testDecimal() {
    Assert.equals( '12',      (12 : Decimal).format('d'));
    Assert.equals( '0012',    (12 : Decimal).format('d4'));
  }

  public function testFormatFixed() {
    Assert.equals('1234.57',   (1234.5678 : Decimal).format('f'));
    Assert.equals('1234,57',   (1234.5678 : Decimal).format('f', it));
    Assert.equals('1234.5678', (1234.5678 : Decimal).format('f4'));
  }

  public function testExponential() {
    Assert.equals('1.000000e+001', (10 : Decimal).exponential());
    Assert.equals('-1.000000e+001', (-10 : Decimal).exponential());
    Assert.equals('1.000000e+000', (1 : Decimal).exponential());
    Assert.equals('-1.000000e+000', (-1 : Decimal).exponential());
    Assert.equals('7.000000e-001', (0.7 : Decimal).exponential());
    Assert.equals('-7.000000e-001', (-0.7 : Decimal).exponential());

    Assert.equals('1.234000e+003', (1.234e3 : Decimal).exponential());
    Assert.equals('1.234000e-003', (1.234e-003 : Decimal).exponential());
    Assert.equals('1.234000e-003', (0.001234 : Decimal).exponential());
    Assert.equals('-1.234000e+003', (-1.234e3 : Decimal).exponential());
    Assert.equals('-1.234000e-003', (-1.234e-003 : Decimal).exponential());

    Assert.equals('1.234000e+050', (1.234e50 : Decimal).exponential());
    Assert.equals('1.234000e-050', (1.234e-50 : Decimal).exponential());
    Assert.equals('-1.234000e+050', (-1.234e50 : Decimal).exponential());
    Assert.equals('-1.234000e-050', (-1.234e-50 : Decimal).exponential());

    Assert.equals('1.23e+003', (1.234e3 : Decimal).exponential(2));
    Assert.equals('1.23e-003', (1.234e-003 : Decimal).exponential(2));
    Assert.equals('-1.23e+003', (-1.234e3 : Decimal).exponential(2));
    Assert.equals('-1.23e-003', (-1.234e-003 : Decimal).exponential(2));

    Assert.equals('1,23e+003', (1.234e3 : Decimal).exponential(2, it));
    Assert.equals('1,23e-003', (1.234e-003 : Decimal).exponential(2, it));
    Assert.equals('-1,23e+003', (-1.234e3 : Decimal).exponential(2, it));
    Assert.equals('-1,23e-003', (-1.234e-003 : Decimal).exponential(2, it));
  }

  public function testPrintfd() {
    var n : Decimal = 461012;
    Assert.equals('461012',   n.printf("%d"));
    Assert.equals('00461012', n.printf("%08d"));
    Assert.equals(' +461012', n.printf("%+8d"));
    Assert.equals('461012  ', n.printf("%-8d"));
    Assert.equals('+461012 ', n.printf("%-+8d"));
  }

  public function testPrintfb() {
    var n : Decimal = 10;
    Assert.equals('1010',   n.printf("%b"));
    Assert.equals('b1010',   n.printf("%#b"));
    Assert.equals('B1010',   n.printf("%#B"));
    Assert.equals('     B1010', n.printf("%#10B"));
    Assert.equals('00000B1010', n.printf("%#010B"));
  }

  public function testRounding() {
    Assert.equals('0.9', (0.89 : Decimal).fixed(1));
    Assert.equals('1', (0.99 : Decimal).fixed(0));
    Assert.equals('0.9', (0.91 : Decimal).fixed(1));
  }

  public function testDifferentGroups() {
    var value : Decimal = 1234567890.123456;
    Assert.equals('1,23,45,67,890.12', value.number(asIn));
    Assert.equals('1234567 890,12', value.number(baRu));

    Assert.equals('1,23,45,67,890.1', value.format("0,0000.0", asIn));
    Assert.equals('1234567 890,1', value.format("0,0000.0", baRu));
  }

  public function testCustomFormat0() {
    var value : Decimal = 123;

    Assert.equals('00123', value.format('00000'));

    value = 1.2;
    Assert.equals('1.20', value.format('0.00'));
    Assert.equals('01,20', value.format('00.00', it));
    value = 0.56;
    Assert.equals('0,6', value.format('0.0', it));

    value = 1234567890;
    Assert.equals('1,234,567,890', value.format('0,0'));
    Assert.equals('1.234.567.890', value.format('0,0', it));

    value = 1234567890.123456;
    Assert.equals('1,234,567,890.1', value.format('0,0.0'));

    value = 1234.567890;
    Assert.equals('1,234.57', value.format('0,0.00'));
    value = "1234567890.12345";
    Assert.equals("(1,234,567,8) 90.123", value.format("(000) 0,0.000"));
    Assert.equals("(12345678) 90.123", value.format("(000) 00.000"));
    Assert.equals("(123456789) 0.123", value.format("(000) 0.000"));
    Assert.equals("1234567890.1", value.format("0.0"));
    Assert.equals("(123456) 7890", value.format("(000) 0000"));

    value = 1.23;
    Assert.equals("(00,0) 01.230", value.format("(000) 0,0.000"));
    Assert.equals("(000) 01.230", value.format("(000) 00.000"));
    Assert.equals("(000) 1.230", value.format("(000) 0.000"));
    Assert.equals("1.2", value.format("0.0"));
    Assert.equals("(000) 0001", value.format("(000) 0000"));
    Assert.equals("(000) 0001", value.format("(000) 0000;(000) 0000-"));
    Assert.equals("(000) 0001-", (-value).format("(000) 0000;(000) 0000-"));
  }

  public function testCustomFormatHash() {
    var value : Decimal = 1.2;

    Assert.equals('1.2', value.format('#.##'));

    value = 123;
    Assert.equals('123', value.format('####'));


    value = 123456;
    Assert.equals('[12-34-56]', value.format('[##-##-##]', it));

    value = 1234567890;
    Assert.equals('1234567890', value.format('#'));
    Assert.equals('(123) 456-7890', value.format('(###) ###-####"'));

    value = "1234567890.12345";
    Assert.equals("(1,234,567,8) 90.123", value.format("(###) #,#.###"));
    Assert.equals("(12345678) 90.123", value.format("(###) ##.###"));
    Assert.equals("(123456789) 0.123", value.format("(###) #.###"));
    Assert.equals("1234567890.1", value.format("#.#"));
    Assert.equals("(123456) 7890", value.format("(###) ####"));

    value = 1.23;
    Assert.equals("() 1.23", value.format("(###) #,#.###"));
    Assert.equals("() 1.23", value.format("(###) ##.###"));
    Assert.equals("() 1.23", value.format("(###) #.###"));
    Assert.equals("1.2", value.format("#.#"));
    Assert.equals("() 1", value.format("(###) ####"));
    Assert.equals("() 1", value.format("(###) ####;(###) ####-"));
    Assert.equals("() 1-", (-value).format("(###) ####;(###) ####-"));
  }

  public function testCustomDecimalSeparator() {
    var value : Decimal = 1234567890;

    Assert.equals("1,234,567,890", value.format("#,#"));

    Assert.equals("1,235", value.format("#,#,,"));
    Assert.equals("1,235", value.format("#,##0,,"));

    Assert.equals("1", value.format("#,#,,,"));
  }

  public function testCustomDecimalFranction() {
    var value : Decimal = 1.2;

    Assert.equals("1.20", value.format("0.00"));
    Assert.equals("01.20", value.format("00.00"));
    Assert.equals("01,20", value.format("00.00", it));

    value = 0.086;
    Assert.equals("8.6%", value.format("#0.##%"));
    Assert.equals("8.60%", value.format("#0.00%"));

    value = 86000;
    Assert.equals("8.6E+4", value.format("0.###E+0"));
  }

  public function testCustomPercentSpecifier() {
    Assert.equals("8.6%", (0.086 : Decimal).format("#0.##%"));
  }

  public function testCustomPermilleSpecifier() {
    Assert.equals("3.54‰", (0.00354 : Decimal).format("#0.##‰"));
  }

  public function testCustomE() {
    var value : Decimal = 86000;
    Assert.equals("8.6E+4", value.format("0.###E+0"));
    Assert.equals("8.6E+004", value.format("0.###E+000"));
    Assert.equals("8.6E004", value.format("0.###E-000"));
  }

  public function testCustomEscape() {
    var value : Decimal = 123;
    Assert.equals("### 123 dollars and 00 cents ###", value.format("\\#\\#\\# ##0 dollars and \\0\\0 c\\ents \\#\\#\\#"));
    Assert.equals("\\\\\\ 123 dollars and 00 cents \\\\\\", value.format("\\\\\\\\\\\\ ##0 dollars and \\0\\0 c\\ents \\\\\\\\\\\\"));
  }

  public function testSectionSeparator() {
    var pos : Decimal = 1234.0,
        neg : Decimal = -1234.0,
        zero : Decimal = 0,

        fmt1 = "##;(##)",
        fmt2 = "##;(##);**Z\\ero**";

    Assert.equals("1234", pos.format(fmt1));
    Assert.equals("(1234)", neg.format(fmt1));
    Assert.equals("0", zero.format(fmt1));

    Assert.equals("1234", pos.format(fmt2));
    Assert.equals("(1234)", neg.format(fmt2));
    Assert.equals("**Zero**", zero.format(fmt2));
  }

  public function testCustomRounding() {
    Assert.equals("1",   (0.99 : Decimal).format("0"));
    Assert.equals("1.0", (0.99 : Decimal).format("0.0"));
    Assert.equals("0.1", (0.099 : Decimal).format("0.0"));
    Assert.equals("10",  (9.9 : Decimal).format("0"));
    Assert.equals("100",  (99.9 : Decimal).format("0"));
    Assert.equals("-1",   (-0.99 : Decimal).format("0"));
    Assert.equals("-1.0", (-0.99 : Decimal).format("0.0"));
    Assert.equals("-0.1", (-0.099 : Decimal).format("0.0"));
    Assert.equals("-10",  (-9.9 : Decimal).format("0"));
    Assert.equals("-100",  (-99.9 : Decimal).format("0"));
  }

  public function testCustomEscapedDecimalSeparator() {
    Assert.equals("1.2.3", (12.34 : Decimal).format("0\\.0.0"));
    Assert.equals("1.2.3", (12.34 : Decimal).format("0'.'0.0"));
    Assert.equals("1.2.3", (12.34 : Decimal).format('0"."0.0'));
  }
}
