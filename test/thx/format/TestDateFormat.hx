package thx.format;

import thx.culture.Culture;
import thx.culture.Embed;
import utest.Assert;
using thx.format.DateFormat;

class TestDateFormat {
  static var it : Culture = Embed.culture('it-it');
  static var ch : Culture = Embed.culture('it-ch');
  static var us : Culture = Embed.culture('en-us');
  static var ru : Culture = Embed.culture('ru-ru');
  static var fr : Culture = Embed.culture('fr-fr');
  static var jp : Culture = Embed.culture('ja-jp');
  static var d1 : Date = Date.fromString('2009-06-01 13:45:30');
  static var d2 : Date = Date.fromString('2009-06-15 13:45:30');
  public function new() {}

  public function testFormat() {
    Assert.equals("Monday, 01 June 2009 13:45:30",   d1.format('U'));
    Assert.equals("lunedì 1 Giugno 2009 13:45:30",   d1.format('U', it));
    Assert.equals("lunedì, 1. Giugno 2009 13:45:30", d1.format('U', ch));
    Assert.equals("Monday, June 1, 2009 1:45:30 PM", d1.format('U', us));
    Assert.equals("1 Июнь 2009 г. 13:45:30",         d1.format('U', ru));
    Assert.equals("lundi 1 juin 2009 13:45:30",      d1.format('U', fr));
    Assert.equals("2009年6月1日 13:45:30",            d1.format('U', jp));
  }

  public function testd() {
    Assert.equals( "1", d1.formatTerm('d'));
    Assert.equals("15", d2.formatTerm('d'));
  }

  public function testdd() {
    Assert.equals("01", d1.formatTerm('dd'));
    Assert.equals("15", d2.formatTerm('dd'));
  }

  public function testddd() {
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

  public function testm() {
    Assert.equals("45", d1.formatTerm('m'));
    Assert.equals("5", Date.fromString('2009-06-15 13:05:30').formatTerm('m'));
  }

  public function testmm() {
    Assert.equals("45", d1.formatTerm('mm'));
    Assert.equals("05", Date.fromString('2009-06-15 13:05:30').formatTerm('mm'));
  }

  public function testM() {
    Assert.equals("6", d1.formatTerm('M'));
  }

  public function testMM() {
    Assert.equals("06", d1.formatTerm('MM'));
  }

  public function testMMM() {
    Assert.equals("Jun",  d1.formatTerm('MMM'));
    Assert.equals("juin", d1.formatTerm('MMM', fr));
    Assert.equals("giu",  d1.formatTerm('MMM', it));
    Assert.equals("Июнь", d1.formatTerm('MMM', ru));
  }

  public function testMMMM() {
    Assert.equals("June",   d1.formatTerm('MMMM'));
    Assert.equals("juin",   d1.formatTerm('MMMM', fr));
    Assert.equals("Giugno", d1.formatTerm('MMMM', it));
    Assert.equals("Июнь",   d1.formatTerm('MMMM', ru));
  }

  public function tests() {
    Assert.equals("30", d1.formatTerm('s'));
    Assert.equals("3", Date.fromString('2009-06-15 13:05:03').formatTerm('s'));
  }

  public function testss() {
    Assert.equals("30", d1.formatTerm('ss'));
    Assert.equals("03", Date.fromString('2009-06-15 13:05:03').formatTerm('ss'));
  }

  public function testt() {
    Assert.equals("P",  d1.formatTerm('t'));
    Assert.equals("P",  d1.formatTerm('t', fr));
    Assert.equals("P",  d1.formatTerm('t', it));
    Assert.equals("午", d1.formatTerm('t', jp));
  }

  public function testtt() {
    Assert.equals("PM",   d1.formatTerm('tt'));
    Assert.equals("PM",   d1.formatTerm('tt', fr));
    Assert.equals("PM",   d1.formatTerm('tt', it));
    Assert.equals("午後",  d1.formatTerm('tt', jp));
  }

  public function testy() {
    Assert.equals("9", d1.formatTerm('y'));
    Assert.equals("72", Date.fromString('1972-06-15 13:05:03').formatTerm('y'));
  }

  public function testyy() {
    Assert.equals("09", d1.formatTerm('yy'));
    Assert.equals("72", Date.fromString('1972-06-15 13:05:03').formatTerm('yy'));
  }

  public function testyyyy() {
    Assert.equals("1980", Date.fromString('1980-06-15 13:05:03').formatTerm('yyyy'));
    Assert.equals("2019", Date.fromString('2019-06-15 13:05:03').formatTerm('yyyy'));
  }

  public function testTimeSeprator() {
    Assert.equals(":", d1.formatTerm(':'));
    Assert.equals(":", d1.formatTerm(':', fr));
    Assert.equals(":", d1.formatTerm(':', it));
    Assert.equals(":", d1.formatTerm(':', jp));
  }

  public function testDateSeprator() {
    Assert.equals("/", d1.formatTerm('/'));
    Assert.equals(".", d1.formatTerm('/', ch));
    Assert.equals("/", d1.formatTerm('/', it));
    Assert.equals("/", d1.formatTerm('/', jp));
  }
}