package thx.format;

import thx.culture.Culture;
import thx.culture.Embed;
import utest.Assert;
import thx.BigInt;
using thx.format.BigIntFormat;

class TestBigIntFormat {
  static var it : Culture = Embed.culture('it-it');
  static var us : Culture = Embed.culture('en-us');
  static var asIn : Culture = Embed.culture('as-in');
  static var baRu : Culture = Embed.culture('ba-ru');
  public function new() {}

  public function testInteger() {
    Assert.equals('12,345',  (12345 : BigInt).integer());
  }

  public function testFormatHex() {
    Assert.equals('7b',     (123 : BigInt).format('x'));
    Assert.equals('7B',     (123 : BigInt).format('X'));
    Assert.equals('007b',   (123 : BigInt).format('x4'));
    Assert.equals('00007B', (123 : BigInt).format('X6'));
  }

  public function testOctal() {
    Assert.equals('112', (74 : BigInt).octal());
  }

  public function testHex() {
    Assert.equals('2af3', (10995 : BigInt).hex());
  }

  public function testBinary() {
    Assert.equals('11001',        (25 : BigInt).binary());
    Assert.equals('-10000101', (-133 : BigInt).binary());
  }
}
