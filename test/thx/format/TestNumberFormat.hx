package thx.format;

import thx.culture.Culture;
import thx.culture.Embed;
import utest.Assert;
using thx.format.NumberFormat;

class TestNumberFormat {
  static var it : Culture = Embed.culture('it-it');
  static var us : Culture = Embed.culture('en-us');
  public function new() {}

  public function testDecimal() {
    Assert.equals('1.00',        1.0.formatDecimal(2));
    Assert.equals('1.2',         1.2.formatDecimal(1));
    Assert.equals('1',           1.formatDecimal(0));
    Assert.equals('10,000',      10000.formatDecimal(0));
    Assert.equals('12,345.678',  12345.6789.formatDecimal(3));

    Assert.equals('-1.00',       (-1.0).formatDecimal(2));
    Assert.equals('-1.2',        (-1.2).formatDecimal(1));
    Assert.equals('-1',          (-1).formatDecimal(0));
    Assert.equals('-10,000',     (-10000).formatDecimal(0));
    Assert.equals('-12,345.678', (-12345.6789).formatDecimal(3));

    var exp = Math.pow(2, 50);
    #if (neko || cs)
    // floats in Neko have a different precision
    Assert.equals('1,125,899,906,842,620.00', exp.formatDecimal(2));
    #else
    Assert.equals('1,125,899,906,842,624.00', exp.formatDecimal(2));
    #end

    var exp = Math.pow(2, -18);
    Assert.equals('0.00000381469', exp.formatDecimal(11));
  }

  public function testCurrency() {
    Assert.equals('(¤12,345.67)', (-12345.6789).formatCurrency());
  }

  public function testCurrencyIT() {
    Assert.equals('-€ 12.345,67', (-12345.6789).formatCurrency(it));
  }

  public function testCurrencyUS() {
    Assert.equals('($12,345.67)', (-12345.6789).formatCurrency(us));
  }

  public function testInteger() {
    Assert.equals('12,345',  12345.6789.formatInteger());
  }

  public function testPercent() {
    Assert.equals('2.33 %', 0.02333.formatPercent());
    Assert.equals('2,33%',  0.02333.formatPercent(it));
  }

  public function testPermille() {
    Assert.equals('23.33 ‰', 0.02333.formatPermille());
    Assert.equals('23,33‰',  0.02333.formatPermille(it));
  }

  public function testUnit() {
    Assert.equals('23.33 kg.', 23.3333.formatUnit(2, 'kg.'));
    Assert.equals('23,33kg.',  23.3333.formatUnit(2, 'kg.', it));
  }
}