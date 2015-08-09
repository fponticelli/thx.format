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

  public function testCustomFormat() {
    Assert.equals("245 30, 0,12", ("245:30:00.1234567" : Time).format("H m, s.ff", it));
    Assert.equals("10,05 30, 0,123", ("245:30:00.1234567" : Time).format("d.hh m, s.fff", it));
    Assert.equals("245 30, 0 0", ("245:30:00" : Time).format("H m, s.ff f", it));
    Assert.equals("10,05 30 1 0000", ("245:30:01" : Time).format("d.hh m s.fff ffff", it));
    Assert.equals("245 30, 0 ", ("245:30:00" : Time).format("H m, s.FF F", it));
    Assert.equals("10,05 30, 1 ", ("245:30:01" : Time).format("d.hh m, s.FFF FFFF", it));
  }
}
