package thx.format;

import thx.culture.Culture;
import thx.culture.Embed;
import utest.Assert;
using thx.format.DateTimeFormat;

class TestDateTimeFormat {
  static var it : Culture = Embed.culture('it-it');
  static var us : Culture = Embed.culture('en-us');
  static var ru : Culture = Embed.culture('ru-RU');
  static var fr : Culture = Embed.culture('fr-fr');
  static var d1 : Date = Date.fromString('2009-06-01 13:45:30');
  static var d2 : Date = Date.fromString('2009-06-15 13:45:30');
  public function new() {}

  public function testd() {
    Assert.equals( "1", d1.formatTerm('d'));
    Assert.equals("15", d2.formatTerm('d'));
  }

  public function testdd() {
    Assert.equals("01", d1.formatTerm('dd'));
    Assert.equals("15", d2.formatTerm('dd'));
  }

  public function testddd() {
    trace(Date.fromString('2009-05-31 13:45:30').getDay());
    trace(d1.getDay());
    Assert.equals("Mon",  d1.formatTerm('ddd'));
    Assert.equals("lun.", d1.formatTerm('ddd', fr));
    Assert.equals("lun",  d1.formatTerm('ddd', it));
    Assert.equals("Пн",   d1.formatTerm('ddd', ru));
  }

  public function testdddd() {
    Assert.equals("Monday",      d1.formatTerm('dddd'));
    Assert.equals("lundi",       d1.formatTerm('dddd', fr));
    Assert.equals("lunedì",      d1.formatTerm('dddd', it));
    Assert.equals("понедельник", d1.formatTerm('dddd', ru));
  }

  public function testh() {
    Assert.equals("1", d1.formatTerm('h'));
  }

  public function testhh() {
    Assert.equals("01", d1.formatTerm('hh'));
  }

  public function testH() {
    Assert.equals("13", d1.formatTerm('H'));
  }

  public function testHH() {
    Assert.equals("13", d1.formatTerm('HH'));
  }
}