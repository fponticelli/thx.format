package thx.format;

import thx.culture.Culture;
import thx.culture.Embed;
import utest.Assert;
using thx.format.NumberFormat;

class TestNumberFormat {
  static var it : Culture = Embed.culture('it-it');
  static var us : Culture = Embed.culture('en-us');
  static var asIn : Culture = Embed.culture('as-in');
  static var baRu : Culture = Embed.culture('ba-ru');
  public function new() {}

  public function testIssue20151201() {
    var s = NumberFormat.printf(5.7, "%.1f%%");
    Assert.equals("5.7%", s);
  }

  // public function testIssues() {
  //   Assert.equals("1,081,072,410", 1081072409.99914.number(0));
  //   Assert.equals("1,081,072,410.0", 1081072409.99914.number(1));
  //   Assert.equals("1,081,072,410.00", 1081072409.99914.number(2));
  //   Assert.equals("1,081,072,410", 1081072409.99914.format("#,##0"));
  // }
  //
  // public function testNumber() {
  //   Assert.equals('1.00',        1.0.number(2));
  //   Assert.equals('1.2',         1.2.number(1));
  //   Assert.equals('1',           1.number(0));
  //   Assert.equals('10,000',      10000.number(0));
  //   Assert.equals('12,345.679',  12345.6789.number(3));
  //
  //   Assert.equals('-1.00',       (-1.0).number(2));
  //   Assert.equals('-1.2',        (-1.2).number(1));
  //   Assert.equals('-1',          (-1).number(0));
  //   Assert.equals('-10,000',     (-10000).number(0));
  //   Assert.equals('-12,345.679', (-12345.6789).number(3));
  //
  //   var exp = Math.pow(2, 50);
  //   #if php
  //   Assert.equals("1,125,899,906,842,600.00", exp.number(2));
  //   #elseif (neko || cs || cpp || php)
  //   // floats in Neko have a different precision
  //   Assert.equals('1,125,899,906,842,620.00', exp.number(2));
  //   #else
  //   Assert.equals('1,125,899,906,842,624.00', exp.number(2));
  //   #end
  //
  //   var exp = Math.pow(2, -18);
  //   Assert.equals('0.00000381470', exp.number(11));
  // }
  //
  // public function testCurrency() {
  //   Assert.equals('(¤12,345.68)', (-12345.6789).currency());
  // }
  //
  // public function testCurrencyIT() {
  //   Assert.equals('-€ 12.345,68', (-12345.6789).currency(it));
  // }
  //
  // public function testCurrencyUS() {
  //   Assert.equals('($12,345.68)', (-12345.6789).currency(us));
  // }
  //
  // public function testInteger() {
  //   Assert.equals('12,346',  12345.6789.integer());
  // }
  //
  // public function testPercent() {
  //   Assert.equals('2.33 %', 0.02333.percent());
  //   Assert.equals('2,33%',  0.02333.percent(it));
  // }
  //
  // public function testPermille() {
  //   Assert.equals('23.33 ‰', 0.02333.permille());
  //   Assert.equals('23,33‰',  0.02333.permille(it));
  // }
  //
  // public function testUnit() {
  //   Assert.equals('23.33 kg.', 23.3333.unit(2, 'kg.'));
  //   Assert.equals('23,33kg.',  23.3333.unit(2, 'kg.', it));
  // }
  //
  // public function testDecimal() {
  //   Assert.equals( '12',      12.format('d'));
  //   Assert.equals( '0012',    12.format('d4'));
  // }
  //
  // public function testFormatHex() {
  //   Assert.equals('7b',     123.format('x'));
  //   Assert.equals('7B',     123.format('X'));
  //   Assert.equals('007b',   123.format('x4'));
  //   Assert.equals('00007B', 123.format('X6'));
  // }
  //
  // public function testFormatFixed() {
  //   Assert.equals('1234.57',   (1234.5678).format('f'));
  //   Assert.equals('1234,57',   (1234.5678).format('f', it));
  //   Assert.equals('1234.5678', (1234.5678).format('f4'));
  // }
  //
  // public function testExponential() {
  //   Assert.equals('1.000000e+001', (10).exponential());
  //   Assert.equals('-1.000000e+001', (-10).exponential());
  //   Assert.equals('1.000000e+000', (1).exponential());
  //   Assert.equals('-1.000000e+000', (-1).exponential());
  //   Assert.equals('7.000000e-001', (0.7).exponential());
  //   Assert.equals('-7.000000e-001', (-0.7).exponential());
  //
  //   Assert.equals('1.234000e+003', (1.234e3).exponential());
  //   Assert.equals('1.234000e-003', (1.234e-003).exponential());
  //   Assert.equals('1.234000e-003', (0.001234).exponential());
  //   Assert.equals('-1.234000e+003', (-1.234e3).exponential());
  //   Assert.equals('-1.234000e-003', (-1.234e-003).exponential());
  //
  //   Assert.equals('1.234000e+050', (1.234e50).exponential());
  //   Assert.equals('1.234000e-050', (1.234e-50).exponential());
  //   Assert.equals('-1.234000e+050', (-1.234e50).exponential());
  //   Assert.equals('-1.234000e-050', (-1.234e-50).exponential());
  //
  //
  //   Assert.equals('1.23e+003', (1.234e3).exponential(2));
  //   Assert.equals('1.23e-003', (1.234e-003).exponential(2));
  //   Assert.equals('-1.23e+003', (-1.234e3).exponential(2));
  //   Assert.equals('-1.23e-003', (-1.234e-003).exponential(2));
  //
  //
  //   Assert.equals('1,23e+003', (1.234e3).exponential(2, it));
  //   Assert.equals('1,23e-003', (1.234e-003).exponential(2, it));
  //   Assert.equals('-1,23e+003', (-1.234e3).exponential(2, it));
  //   Assert.equals('-1,23e-003', (-1.234e-003).exponential(2, it));
  // }
  //
  // public function testOctal() {
  //   Assert.equals('112', 74.octal());
  // }
  //
  // public function testHex() {
  //   Assert.equals('2af3', 10995.hex());
  // }
  //
  // public function testBinary() {
  //   Assert.equals('11001',        25.binary());
  //   Assert.equals('-10000101', (-133).binary());
  // }
  //
  // public function testPrintfd() {
  //   var n = 461012;
  //   Assert.equals('461012',   n.printf("%d"));
  //   Assert.equals('00461012', n.printf("%08d"));
  //   Assert.equals(' +461012', n.printf("%+8d"));
  //   Assert.equals('461012  ', n.printf("%-8d"));
  //   Assert.equals('+461012 ', n.printf("%-+8d"));
  // }
  //
  // public function testPrintfb() {
  //   var n = 10;
  //   Assert.equals('1010',   n.printf("%b"));
  //   Assert.equals('b1010',   n.printf("%#b"));
  //   Assert.equals('B1010',   n.printf("%#B"));
  //   Assert.equals('     B1010', n.printf("%#10B"));
  //   Assert.equals('00000B1010', n.printf("%#010B"));
  // }
  //
  // public function testRounding() {
  //   Assert.equals('0.9', 0.89.fixed(1));
  //   Assert.equals('1', 0.99.fixed(0));
  //   Assert.equals('0.9', 0.91.fixed(1));
  // }
  //
  // public function testDifferentGroups() {
  //   var value = 1234567890.123456;
  //   Assert.equals('1,23,45,67,890.12', value.number(asIn));
  //   Assert.equals('1234567 890,12', value.number(baRu));
  //
  //   Assert.equals('1,23,45,67,890.1', value.format("0,0000.0", asIn));
  //   Assert.equals('1234567 890,1', value.format("0,0000.0", baRu));
  // }
  //
  // public function testCustomFormat0() {
  //   var value : Float = 123;
  //
  //   Assert.equals('00123', value.format('00000'));
  //
  //   value = 1.2;
  //   Assert.equals('1.20', value.format('0.00'));
  //   Assert.equals('01,20', value.format('00.00', it));
  //   value = 0.56;
  //   Assert.equals('0,6', value.format('0.0', it));
  //
  //   value = 1234567890;
  //   Assert.equals('1,234,567,890', value.format('0,0'));
  //   Assert.equals('1.234.567.890', value.format('0,0', it));
  //
  //   value = 1234567890.123456;
  //   Assert.equals('1,234,567,890.1', value.format('0,0.0'));
  //
  //   value = 1234.567890;
  //   Assert.equals('1,234.57', value.format('0,0.00'));
  //   value = 1234567890.12345;
  //   Assert.equals("(1,234,567,8) 90.123", value.format("(000) 0,0.000"));
  //   Assert.equals("(12345678) 90.123", value.format("(000) 00.000"));
  //   Assert.equals("(123456789) 0.123", value.format("(000) 0.000"));
  //   Assert.equals("1234567890.1", value.format("0.0"));
  //   Assert.equals("(123456) 7890", value.format("(000) 0000"));
  //
  //   value = 1.23;
  //   Assert.equals("(00,0) 01.230", value.format("(000) 0,0.000"));
  //   Assert.equals("(000) 01.230", value.format("(000) 00.000"));
  //   Assert.equals("(000) 1.230", value.format("(000) 0.000"));
  //   Assert.equals("1.2", value.format("0.0"));
  //   Assert.equals("(000) 0001", value.format("(000) 0000"));
  //   Assert.equals("(000) 0001", value.format("(000) 0000;(000) 0000-"));
  //   Assert.equals("(000) 0001-", (-value).format("(000) 0000;(000) 0000-"));
  // }
  //
  // public function testCustomFormatHash() {
  //   var value : Float = 1.2;
  //
  //   Assert.equals('1.2', value.format('#.##'));
  //
  //   value = 123;
  //   Assert.equals('123', value.format('####'));
  //
  //
  //   value = 123456;
  //   Assert.equals('[12-34-56]', value.format('[##-##-##]', it));
  //
  //   value = 1234567890;
  //   Assert.equals('1234567890', value.format('#'));
  //   Assert.equals('(123) 456-7890', value.format('(###) ###-####"'));
  //
  //   value = 1234567890.12345;
  //   Assert.equals("(1,234,567,8) 90.123", value.format("(###) #,#.###"));
  //   Assert.equals("(12345678) 90.123", value.format("(###) ##.###"));
  //   Assert.equals("(123456789) 0.123", value.format("(###) #.###"));
  //   Assert.equals("1234567890.1", value.format("#.#"));
  //   Assert.equals("(123456) 7890", value.format("(###) ####"));
  //
  //   value = 1.23;
  //   Assert.equals("() 1.23", value.format("(###) #,#.###"));
  //   Assert.equals("() 1.23", value.format("(###) ##.###"));
  //   Assert.equals("() 1.23", value.format("(###) #.###"));
  //   Assert.equals("1.2", value.format("#.#"));
  //   Assert.equals("() 1", value.format("(###) ####"));
  //   Assert.equals("() 1", value.format("(###) ####;(###) ####-"));
  //   Assert.equals("() 1-", (-value).format("(###) ####;(###) ####-"));
  // }
  //
  // public function testCustomDecimalSeparator() {
  //   var value = 1234567890;
  //
  //   Assert.equals("1,234,567,890", value.format("#,#"));
  //
  //   Assert.equals("1,235", value.format("#,#,,"));
  //   Assert.equals("1,235", value.format("#,##0,,"));
  //
  //   Assert.equals("1", value.format("#,#,,,"));
  // }
  //
  // public function testCustomDecimalFranction() {
  //   var value = 1.2;
  //
  //   Assert.equals("1.20", value.format("0.00"));
  //   Assert.equals("01.20", value.format("00.00"));
  //   Assert.equals("01,20", value.format("00.00", it));
  //
  //   value = 0.086;
  //   Assert.equals("8.6%", value.format("#0.##%"));
  //
  //   value = 86000;
  //   Assert.equals("8.6E+4", value.format("0.###E+0"));
  // }
  //
  // public function testCustomPercentSpecifier() {
  //   Assert.equals("8.6%", 0.086.format("#0.##%"));
  // }
  //
  // public function testCustomPermilleSpecifier() {
  //   Assert.equals("3.54‰", 0.00354.format("#0.##‰"));
  // }
  //
  // public function testCustomE() {
  //   var value = 86000;
  //   Assert.equals("8.6E+4", value.format("0.###E+0"));
  //   Assert.equals("8.6E+004", value.format("0.###E+000"));
  //   Assert.equals("8.6E004", value.format("0.###E-000"));
  // }
  //
  // public function testCustomEscape() {
  //   var value = 123;
  //   Assert.equals("### 123 dollars and 00 cents ###", value.format("\\#\\#\\# ##0 dollars and \\0\\0 c\\ents \\#\\#\\#"));
  //   Assert.equals("\\\\\\ 123 dollars and 00 cents \\\\\\", value.format("\\\\\\\\\\\\ ##0 dollars and \\0\\0 c\\ents \\\\\\\\\\\\"));
  // }
  //
  // public function testSectionSeparator() {
  //   var pos = 1234.0,
  //       neg = -1234.0,
  //       zero = 0,
  //
  //       fmt1 = "##;(##)",
  //       fmt2 = "##;(##);**Z\\ero**";
  //
  //   Assert.equals("1234", pos.format(fmt1));
  //   Assert.equals("(1234)", neg.format(fmt1));
  //   Assert.equals("0", zero.format(fmt1));
  //
  //   Assert.equals("1234", pos.format(fmt2));
  //   Assert.equals("(1234)", neg.format(fmt2));
  //   Assert.equals("**Zero**", zero.format(fmt2));
  // }
  //
  // public function testSectionSeparatorConfusing() {
  //   Assert.raises(function() 1.format(";;;"));
  //   var f = "\\; \\;;\";\"- ;';'*";
  //   Assert.equals("; ;",   1.format(f));
  //   Assert.equals(";- ", (-1).format(f));
  //   Assert.equals(";*",    0.format(f));
  // }
  // public function testCustomRounding() {
  //   Assert.equals("1",   0.99.format("0"));
  //   Assert.equals("1.0", 0.99.format("0.0"));
  //   Assert.equals("0.1", 0.099.format("0.0"));
  //   Assert.equals("10",  9.9.format("0"));
  //   Assert.equals("100",  99.9.format("0"));
  //   Assert.equals("-1",   (-0.99).format("0"));
  //   Assert.equals("-1.0", (-0.99).format("0.0"));
  //   Assert.equals("-0.1", (-0.099).format("0.0"));
  //   Assert.equals("-10",  (-9.9).format("0"));
  //   Assert.equals("-100",  (-99.9).format("0"));
  // }
  //
  // public function testCustomEscapedDecimalSeparator() {
  //   Assert.equals("1.2.3", 12.34.format("0\\.0.0"));
  //   Assert.equals("1.2.3", 12.34.format("0'.'0.0"));
  //   Assert.equals("1.2.3", 12.34.format('0"."0.0'));
  // }
}
