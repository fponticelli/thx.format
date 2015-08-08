package thx.format;

import thx.Time;
import thx.culture.Culture;
import thx.culture.Embed;
import utest.Assert;
using thx.format.TimeFormat;

class TestTimeFormat {
  static var it = Embed.culture('it-it');
  static var bn = Embed.culture('bn-in');
  static var us = Embed.culture('en-us');
  static var t1 : Time = '13:45:30';
  static var t2 : Time = '-18:40:20';
  public function new() {}

  public function testFormat_c() {
    Assert.equals("00:30:00", ("00:30:00" : Time).format("c"));
    Assert.equals("3.17:25:30.0050000", ("3.17:25:30.005" : Time).format("c", it)); // culture should be irrelevant
    Assert.equals("-3.17:25:30.0050000", ("-3.17:25:30.005" : Time).format("c", it)); // culture should be irrelevant
  }

  public function testFormat_g() {
    Assert.equals("00:30:00", ("00:30:00" : Time).format("g", it));
    Assert.equals("3.17.25.30.05", ("3.17:25:30.05" : Time).format("g", bn));
    Assert.equals("-3.17.25.30.05", ("-3.17:25:30.05" : Time).format("g", bn));
  }

  public function testFormat_G() {
    Assert.equals("00:30:00", ("00:30:00" : Time).format("G", it));
    Assert.equals("3.17.25.30.5000000", ("3.17:25:30.5000000" : Time).format("G", bn));
    Assert.equals("-3.17.25.30.5000000", ("-3.17:25:30.5000000" : Time).format("G", bn));
  }
}
