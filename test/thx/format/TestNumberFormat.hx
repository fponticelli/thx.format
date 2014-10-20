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
    Assert.equals('1.00',        1.0.decimal(2));
    Assert.equals('1.2',         1.2.decimal(1));
    Assert.equals('1',           1.decimal(0));
    Assert.equals('10,000',      10000.decimal(0));
    Assert.equals('12,345.678',  12345.6789.decimal(3));

    Assert.equals('-1.00',       (-1.0).decimal(2));
    Assert.equals('-1.2',        (-1.2).decimal(1));
    Assert.equals('-1',          (-1).decimal(0));
    Assert.equals('-10,000',     (-10000).decimal(0));
    Assert.equals('-12,345.678', (-12345.6789).decimal(3));

    var exp = Math.pow(2, 50);
    // without rounding is '1,125,899,906,842,624.00'
    Assert.equals('1,125,899,906,842,620.00', exp.decimal(2));

    var exp = Math.pow(2, -18);
    Assert.equals('0.00000381469', exp.decimal(11));
  }

  public function testCurrency() {
    var exp = Math.pow(2, 50);
    Assert.equals('¤1,125,899,906,842,620.00', exp.currency());
  }

  public function testCurrencyIT() {
    var exp = Math.pow(2, 50);
    Assert.equals('€ 1.125.899.906.842.620,00', exp.currency(it));
  }

  public function testCurrencyUS() {
    var exp = Math.pow(2, 50);
    Assert.equals('$1,125,899,906,842,620.00', exp.currency(us));
  }

  public function testInteger() {
    Assert.equals('12,345',  12345.6789.integer());
    Assert.equals('1,125,899,906,842,620', Math.pow(2, 50).integer());
  }
}