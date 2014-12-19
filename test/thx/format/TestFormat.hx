package thx.format;

import thx.culture.Culture;
import thx.culture.Embed;
import utest.Assert;
import sys.db.Types;
using thx.format.Format;

class TestFormat {
  static var it = Embed.culture('it-it');

  public function new() {}

  public function testF() {
    var date = Date.fromString("2014-01-01");
    var sDate:SDate = date;
    Assert.equals("Wednesday, 01 January 2014", date.f("D"));
    Assert.equals("Wednesday, 01 January 2014", sDate.f("D"));
    Assert.equals("1,000.00", 1000.f("n"));

    Assert.equals("mercoledì 1 gennaio 2014", Date.fromString("2014-01-01").f("D", it));
    Assert.equals("1.000,00", 1000.f("n", it));
  }
}