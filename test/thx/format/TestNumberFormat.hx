package thx.format;

import thx.culture.Culture;
import thx.culture.Embed;
import utest.Assert;
using thx.format.NumberFormat;

class TestNumberFormat {
  static var it : Culture = Embed.culture('it-it');
  static var us : Culture = Embed.culture('en-us');
  public function new() {}

  public function testNumber() {
    Assert.equals('1.00',        1.0.number(2));
    Assert.equals('1.2',         1.2.number(1));
    Assert.equals('1',           1.number(0));
    Assert.equals('10,000',      10000.number(0));
    Assert.equals('12,345.678',  12345.6789.number(3));

    Assert.equals('-1.00',       (-1.0).number(2));
    Assert.equals('-1.2',        (-1.2).number(1));
    Assert.equals('-1',          (-1).number(0));
    Assert.equals('-10,000',     (-10000).number(0));
    Assert.equals('-12,345.678', (-12345.6789).number(3));

    var exp = Math.pow(2, 50);
    #if (neko || cs || cpp)
    // floats in Neko have a different precision
    Assert.equals('1,125,899,906,842,620.00', exp.number(2));
    #else
    Assert.equals('1,125,899,906,842,624.00', exp.number(2));
    #end

    var exp = Math.pow(2, -18);
    Assert.equals('0.00000381469', exp.number(11));
  }

  public function testCurrency() {
    Assert.equals('(¤12,345.67)', (-12345.6789).currency());
  }

  public function testCurrencyIT() {
    Assert.equals('-€ 12.345,67', (-12345.6789).currency(it));
  }

  public function testCurrencyUS() {
    Assert.equals('($12,345.67)', (-12345.6789).currency(us));
  }

  public function testInteger() {
    Assert.equals('12,345',  12345.6789.integer());
  }

  public function testPercent() {
    Assert.equals('2.33 %', 0.02333.percent());
    Assert.equals('2,33%',  0.02333.percent(it));
  }

  public function testPermille() {
    Assert.equals('23.33 ‰', 0.02333.permille());
    Assert.equals('23,33‰',  0.02333.permille(it));
  }

  public function testUnit() {
    Assert.equals('23.33 kg.', 23.3333.unit(2, 'kg.'));
    Assert.equals('23,33kg.',  23.3333.unit(2, 'kg.', it));
  }

  public function testDecimal() {
    Assert.equals( '12',      12.format('d'));
    Assert.equals( '0012',    12.format('d4'));
  }

  public function testFormatHex() {
    Assert.equals('7b',     123.format('x'));
    Assert.equals('7B',     123.format('X'));
    Assert.equals('007b',   123.format('x4'));
    Assert.equals('00007B', 123.format('X6'));
  }

  public function testFormatFixed() {
    Assert.equals('1234.56',   (1234.5678).format('f'));
    Assert.equals('1234,56',   (1234.5678).format('f', it));
    Assert.equals('1234.5678', (1234.5678).format('f4'));
  }

  public function testExponential() {
    Assert.equals('1.000000e+001', (10).exponential());
    Assert.equals('-1.000000e+001', (-10).exponential());
    Assert.equals('1.000000e+000', (1).exponential());
    Assert.equals('-1.000000e+000', (-1).exponential());
    Assert.equals('7.000000e-001', (0.7).exponential());
    Assert.equals('-7.000000e-001', (-0.7).exponential());

    Assert.equals('1.234000e+003', (1.234e3).exponential());
    Assert.equals('1.234000e-003', (1.234e-003).exponential());
    Assert.equals('1.234000e-003', (0.001234).exponential());
    Assert.equals('-1.234000e+003', (-1.234e3).exponential());
    Assert.equals('-1.234000e-003', (-1.234e-003).exponential());

    Assert.equals('1.234000e+050', (1.234e50).exponential());
    Assert.equals('1.234000e-050', (1.234e-50).exponential());
    Assert.equals('-1.234000e+050', (-1.234e50).exponential());
    Assert.equals('-1.234000e-050', (-1.234e-50).exponential());


    Assert.equals('1.23e+003', (1.234e3).exponential(2));
    Assert.equals('1.23e-003', (1.234e-003).exponential(2));
    Assert.equals('-1.23e+003', (-1.234e3).exponential(2));
    Assert.equals('-1.23e-003', (-1.234e-003).exponential(2));


    Assert.equals('1,23e+003', (1.234e3).exponential(2, it));
    Assert.equals('1,23e-003', (1.234e-003).exponential(2, it));
    Assert.equals('-1,23e+003', (-1.234e3).exponential(2, it));
    Assert.equals('-1,23e-003', (-1.234e-003).exponential(2, it));
  }

  public function testOctal() {
    Assert.equals('112', 74.octal());
  }

  public function testHex() {
    Assert.equals('2af3', 10995.hex());
  }

  public function testBinary() {
    Assert.equals('11001',        25.binary());
    Assert.equals('-10000101', (-133).binary());
  }

  public function testPrintfd() {
    var n = 461012;
    Assert.equals('461012',   n.printfTerm("%d"));
    Assert.equals('00461012', n.printfTerm("%08d"));
    Assert.equals(' +461012', n.printfTerm("%+8d"));
    Assert.equals('461012  ', n.printfTerm("%-8d"));
    Assert.equals('+461012 ', n.printfTerm("%-+8d"));
  }

  public function testPrintfb() {
    var n = 10;
    Assert.equals('1010',   n.printfTerm("%b"));
    Assert.equals('b1010',   n.printfTerm("%#b"));
    Assert.equals('B1010',   n.printfTerm("%#B"));
    Assert.equals('     B1010', n.printfTerm("%#10B"));
    Assert.equals('00000B1010', n.printfTerm("%#010B"));
  }
/*
  public function testCustomFormat() {
    Assert.equals( '00012',   12.format('00000'));
    Assert.equals('-00012', (-12).format('00000'));
  }
*/
}