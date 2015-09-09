package thx.format;

import thx.culture.Culture;
import thx.culture.Embed;
import utest.Assert;
using thx.format.DateFormat;

class TestDateFormat {
  static var it = Embed.culture('it-it');
  static var ch = Embed.culture('it-ch');
  static var us = Embed.culture('en-us');
  static var ru = Embed.culture('ru-ru');
  static var fr = Embed.culture('fr-fr');
  static var jp = Embed.culture('ja-jp');
  static var d1 = DateTime.fromString('2009-06-01 13:45:30-06:00');
  static var d2 = DateTime.fromString('2009-06-15 13:45:30-06:00');
  public function new() {}

  public function testFormatU() {
    Assert.equals("Monday, 01 June 2009 13:45:30",   d1.format('U'));
    Assert.equals("lunedì 1 giugno 2009 13:45:30",   d1.format('U', it));
    Assert.equals("lunedì, 1. giugno 2009 13:45:30", d1.format('U', ch));
    Assert.equals("Monday, June 01, 2009 1:45:30 PM", d1.format('U', us));
    Assert.equals("1 Июнь 2009 г. 13:45:30",         d1.format('U', ru));
    Assert.equals("lundi 1 juin 2009 13:45:30",      d1.format('U', fr));
    Assert.equals("2009年6月1日 13:45:30",            d1.format('U', jp));

    Assert.equals("lunedì 1 giugno 2009 13:45:30",   d1.dateTimeFull(it));
  }

  public function testFormatd_() {
    Assert.equals("06/01/2009", d1.format('d'));
    Assert.equals("6/1/2009",   d1.format('d', us));
    Assert.equals("01/06/2009", d1.format('d', fr));
    Assert.equals("2009/06/01",   d1.format('d', jp));

    Assert.equals("01/06/2009", d1.dateShort(it));
  }

  public function testFormatD() {
    Assert.equals("Monday, 01 June 2009", d1.format('D'));
    Assert.equals("Monday, June 01, 2009", d1.format('D', us));
    Assert.equals("lundi 1 juin 2009",    d1.format('D', fr));
    Assert.equals("2009年6月1日",          d1.format('D', jp));

    Assert.equals("lunedì 1 giugno 2009", d1.dateLong(it));
  }

  public function testFormatM() {
    Assert.equals("June 01",  d1.format('M'));
    Assert.equals("June 01",  d1.format('M', us));
    Assert.equals("1 juin",   d1.format('M', fr));
    Assert.equals("6月1日",    d1.format('M', jp));

    Assert.equals("01 giugno", d1.monthDay(it));
  }

  public function testFormatR() {
    Assert.equals("Mon, 01 Jun 2009 19:45:30 GMT",   d1.format('R'));
    Assert.equals("Mon, 01 Jun 2009 19:45:30 GMT",   d1.format('R', us));
    Assert.equals("lun., 01 juin 2009 19:45:30 GMT", d1.format('R', fr));
    Assert.equals("月, 01 6 2009 19:45:30 GMT",      d1.format('R', jp));
    Assert.equals("lun, 01 giu 2009 19:45:30 GMT",   d1.rfc1123(it));
  }

  public function testFormats() {
    Assert.equals("2009-06-01T13:45:30", d1.format('s'));
    Assert.equals("2009-06-01T13:45:30", d1.format('s', us));
    Assert.equals("2009-06-01T13:45:30", d1.format('s', fr));
    Assert.equals("2009-06-01T13:45:30", d1.format('s', jp));

    Assert.equals("2009-06-01T13:45:30", d1.dateTimeSortable(it));
  }

  public function testFormatt_() {
    Assert.equals("13:45", d1.format('t'));
    Assert.equals("1:45 PM", d1.format('t', us));
    Assert.equals("13:45", d1.format('t', fr));
    Assert.equals("13:45", d1.format('t', jp));

    Assert.equals("13:45",   d1.timeShort(it));
  }

  public function testFormatT() {
    Assert.equals("13:45:30", d1.format('T'));
    Assert.equals("1:45:30 PM", d1.format('T', us));
    Assert.equals("13:45:30", d1.format('T', fr));
    Assert.equals("13:45:30", d1.format('T', jp));

    Assert.equals("13:45:30",   d1.timeLong(it));
  }

  public function testFormatu_() {
    Assert.equals("2009-06-01 19:45:30Z", d1.format('u'));
    Assert.equals("2009-06-01 19:45:30Z", d1.format('u', us));
    Assert.equals("2009-06-01 19:45:30Z", d1.format('u', fr));
    Assert.equals("2009-06-01 19:45:30Z", d1.format('u', jp));
    Assert.equals("2009-06-01 19:45:30Z", d1.universalSortable(it));
  }

  public function testFormatO() {
    Assert.equals("2009-06-01T13:45:30.0000000-06:00", d1.format('O'));
    Assert.equals("2009-06-01T13:45:30.0000000-06:00", d1.format('o', fr));
    Assert.equals("2009-06-01T13:45:30.0000000-06:00", d1.format('O', jp));
    Assert.equals("2009-06-01T13:45:30.0000000-06:00", d1.iso8601(it));
  }

  public function testFormaty() {
    Assert.equals("2009 June",   d1.format('y'));
    Assert.equals("June, 2009",   d1.format('y', us));
    Assert.equals("juin 2009",   d1.format('y', fr));
    Assert.equals("2009年6月",    d1.format('y', jp));

    Assert.equals("giugno 2009", d1.yearMonth(it));
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

  public function testh_() {
    Assert.equals("1", d1.formatTerm('h'));
  }

  public function testhh_() {
    Assert.equals("01", d1.formatTerm('hh'));
  }

  public function testH() {
    Assert.equals("13", d1.formatTerm('H'));
  }

  public function testHH() {
    Assert.equals("13", d1.formatTerm('HH'));
  }

  public function testm_() {
    Assert.equals("45", d1.formatTerm('m'));
    Assert.equals("5", DateTime.fromString('2009-06-15 13:05:30').formatTerm('m'));
  }

  public function testmm_() {
    Assert.equals("45", d1.formatTerm('mm'));
    Assert.equals("05", DateTime.fromString('2009-06-15 13:05:30').formatTerm('mm'));
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
    Assert.equals("июн", d1.formatTerm('MMM', ru));
  }

  public function testMMMM() {
    Assert.equals("June",   d1.formatTerm('MMMM'));
    Assert.equals("juin",   d1.formatTerm('MMMM', fr));
    Assert.equals("giugno", d1.formatTerm('MMMM', it));
    Assert.equals("Июнь",   d1.formatTerm('MMMM', ru));
  }

  public function tests() {
    Assert.equals("30", d1.formatTerm('s'));
    Assert.equals("3", DateTime.fromString('2009-06-15 13:05:03').formatTerm('s'));
  }

  public function testss() {
    Assert.equals("30", d1.formatTerm('ss'));
    Assert.equals("03", DateTime.fromString('2009-06-15 13:05:03').formatTerm('ss'));
  }

  public function testt() {
    Assert.equals("P",  d1.formatTerm('t'));
    Assert.equals("",  d1.formatTerm('t', fr));
    Assert.equals("",  d1.formatTerm('t', it));
    Assert.equals("午", d1.formatTerm('t', jp));
  }

  public function testtt() {
    Assert.equals("PM",   d1.formatTerm('tt'));
    Assert.equals("",   d1.formatTerm('tt', fr));
    Assert.equals("",   d1.formatTerm('tt', it));
    Assert.equals("午後",  d1.formatTerm('tt', jp));
  }

  public function testy() {
    Assert.equals("72", DateTime.fromString('1972-06-15 13:05:03').formatTerm('y'));
  }

  public function testyy() {
    Assert.equals("09", d1.formatTerm('yy'));
    Assert.equals("72", DateTime.fromString('1972-06-15 13:05:03').formatTerm('yy'));
  }

  public function testyyyy() {
    Assert.equals("1980", DateTime.fromString('1980-06-15 13:05:03').formatTerm('yyyy'));
    Assert.equals("2019", DateTime.fromString('2019-06-15 13:05:03').formatTerm('yyyy'));
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
