package thx.format;

import thx.Time;
import thx.culture.Culture;
import thx.culture.Embed;
import utest.Assert;
using thx.format.TimeFormat;

class TestTimeFormat {
  static var it = Embed.culture('it-it');
  static var ch = Embed.culture('it-ch');
  static var us = Embed.culture('en-us');
  static var ru = Embed.culture('ru-ru');
  static var fr = Embed.culture('fr-fr');
  static var jp = Embed.culture('ja-jp');
  static var t1 : Time = '13:45:30';
  static var t2 : Time = '18:40:20';
  public function new() {}
/*
  public function testFormatU() {
    Assert.equals("Monday, 01 June 2009 13:45:30",   t1.format('U'));
    Assert.equals("lunedì 1 giugno 2009 13:45:30",   t1.format('U', it));
    Assert.equals("lunedì, 1. giugno 2009 13:45:30", t1.format('U', ch));
    Assert.equals("Monday, June 01, 2009 1:45:30 PM", t1.format('U', us));
    Assert.equals("1 Июнь 2009 г. 13:45:30",         t1.format('U', ru));
    Assert.equals("lundi 1 juin 2009 13:45:30",      t1.format('U', fr));
    Assert.equals("2009年6月1日 13:45:30",            t1.format('U', jp));

    Assert.equals("lunedì 1 giugno 2009 13:45:30",   t1.dateTimeFull(it));
  }

  public function testFormatd_() {
    Assert.equals("06/01/2009", t1.format('d'));
    Assert.equals("6/1/2009",   t1.format('d', us));
    Assert.equals("01/06/2009", t1.format('d', fr));
    Assert.equals("2009/06/01",   t1.format('d', jp));

    Assert.equals("01/06/2009", t1.dateShort(it));
  }

  public function testFormatD() {
    Assert.equals("Monday, 01 June 2009", t1.format('D'));
    Assert.equals("Monday, June 01, 2009", t1.format('D', us));
    Assert.equals("lundi 1 juin 2009",    t1.format('D', fr));
    Assert.equals("2009年6月1日",          t1.format('D', jp));

    Assert.equals("lunedì 1 giugno 2009", t1.dateLong(it));
  }

  public function testFormatM() {
    Assert.equals("June 01",  t1.format('M'));
    Assert.equals("June 01",  t1.format('M', us));
    Assert.equals("1 juin",   t1.format('M', fr));
    Assert.equals("6月1日",    t1.format('M', jp));

    Assert.equals("01 giugno", t1.monthDay(it));
  }

  public function testFormatR() {
    Assert.equals("Mon, 01 Jun 2009 13:45:30 GMT",   t1.format('R'));
    Assert.equals("Mon, 01 Jun 2009 13:45:30 GMT",   t1.format('R', us));
    Assert.equals("lun., 01 juin 2009 13:45:30 GMT", t1.format('R', fr));
    Assert.equals("月, 01 6 2009 13:45:30 GMT",      t1.format('R', jp));

    Assert.equals("lun, 01 giu 2009 13:45:30 GMT",   t1.rfc1123(it));
  }

  public function testFormats() {
    Assert.equals("2009-06-01T13:45:30", t1.format('s'));
    Assert.equals("2009-06-01T13:45:30", t1.format('s', us));
    Assert.equals("2009-06-01T13:45:30", t1.format('s', fr));
    Assert.equals("2009-06-01T13:45:30", t1.format('s', jp));

    Assert.equals("2009-06-01T13:45:30", t1.dateTimeSortable(it));
  }

  public function testFormatt_() {
    Assert.equals("13:45", t1.format('t'));
    Assert.equals("1:45 PM", t1.format('t', us));
    Assert.equals("13:45", t1.format('t', fr));
    Assert.equals("13:45", t1.format('t', jp));

    Assert.equals("13:45",   t1.timeShort(it));
  }

  public function testFormatT() {
    Assert.equals("13:45:30", t1.format('T'));
    Assert.equals("1:45:30 PM", t1.format('T', us));
    Assert.equals("13:45:30", t1.format('T', fr));
    Assert.equals("13:45:30", t1.format('T', jp));

    Assert.equals("13:45:30",   t1.timeLong(it));
  }

  public function testFormatu_() {
    Assert.equals("2009-06-01 13:45:30Z", t1.format('u'));
    Assert.equals("2009-06-01 13:45:30Z", t1.format('u', us));
    Assert.equals("2009-06-01 13:45:30Z", t1.format('u', fr));
    Assert.equals("2009-06-01 13:45:30Z", t1.format('u', jp));

    Assert.equals("2009-06-01 13:45:30Z", t1.universalSortable(it));
  }

  public function testFormaty() {
    Assert.equals("2009 June",   t1.format('y'));
    Assert.equals("June, 2009",   t1.format('y', us));
    Assert.equals("juin 2009",   t1.format('y', fr));
    Assert.equals("2009年6月",    t1.format('y', jp));

    Assert.equals("giugno 2009", t1.yearMonth(it));
  }

  public function testd() {
    Assert.equals( "1", t1.formatTerm('d'));
    Assert.equals("15", t2.formatTerm('d'));
  }

  public function testdd() {
    Assert.equals("01", t1.formatTerm('dd'));
    Assert.equals("15", t2.formatTerm('dd'));
  }

  public function testddd() {
    Assert.equals("Mon",  t1.formatTerm('ddd'));
    Assert.equals("lun.", t1.formatTerm('ddd', fr));
    Assert.equals("lun",  t1.formatTerm('ddd', it));
    Assert.equals("Пн",   t1.formatTerm('ddd', ru));
  }

  public function testdddd() {
    Assert.equals("Monday",      t1.formatTerm('dddd'));
    Assert.equals("lundi",       t1.formatTerm('dddd', fr));
    Assert.equals("lunedì",      t1.formatTerm('dddd', it));
    Assert.equals("понедельник", t1.formatTerm('dddd', ru));
  }

  public function testh_() {
    Assert.equals("1", t1.formatTerm('h'));
  }

  public function testhh_() {
    Assert.equals("01", t1.formatTerm('hh'));
  }

  public function testH() {
    Assert.equals("13", t1.formatTerm('H'));
  }

  public function testHH() {
    Assert.equals("13", t1.formatTerm('HH'));
  }

  public function testm_() {
    Assert.equals("45", t1.formatTerm('m'));
    Assert.equals("5", Date.fromString('2009-06-15 13:05:30').formatTerm('m'));
  }

  public function testmm_() {
    Assert.equals("45", t1.formatTerm('mm'));
    Assert.equals("05", Date.fromString('2009-06-15 13:05:30').formatTerm('mm'));
  }

  public function testM() {
    Assert.equals("6", t1.formatTerm('M'));
  }

  public function testMM() {
    Assert.equals("06", t1.formatTerm('MM'));
  }

  public function testMMM() {
    Assert.equals("Jun",  t1.formatTerm('MMM'));
    Assert.equals("juin", t1.formatTerm('MMM', fr));
    Assert.equals("giu",  t1.formatTerm('MMM', it));
    Assert.equals("июн", t1.formatTerm('MMM', ru));
  }

  public function testMMMM() {
    Assert.equals("June",   t1.formatTerm('MMMM'));
    Assert.equals("juin",   t1.formatTerm('MMMM', fr));
    Assert.equals("giugno", t1.formatTerm('MMMM', it));
    Assert.equals("Июнь",   t1.formatTerm('MMMM', ru));
  }

  public function tests() {
    Assert.equals("30", t1.formatTerm('s'));
    Assert.equals("3", Date.fromString('2009-06-15 13:05:03').formatTerm('s'));
  }

  public function testss() {
    Assert.equals("30", t1.formatTerm('ss'));
    Assert.equals("03", Date.fromString('2009-06-15 13:05:03').formatTerm('ss'));
  }

  public function testt() {
    Assert.equals("P",  t1.formatTerm('t'));
    Assert.equals("",  t1.formatTerm('t', fr));
    Assert.equals("",  t1.formatTerm('t', it));
    Assert.equals("午", t1.formatTerm('t', jp));
  }

  public function testtt() {
    Assert.equals("PM",   t1.formatTerm('tt'));
    Assert.equals("",   t1.formatTerm('tt', fr));
    Assert.equals("",   t1.formatTerm('tt', it));
    Assert.equals("午後",  t1.formatTerm('tt', jp));
  }

  public function testy() {
    Assert.equals("9", t1.formatTerm('y'));
    Assert.equals("72", Date.fromString('1972-06-15 13:05:03').formatTerm('y'));
  }

  public function testyy() {
    Assert.equals("09", t1.formatTerm('yy'));
    Assert.equals("72", Date.fromString('1972-06-15 13:05:03').formatTerm('yy'));
  }

  public function testyyyy() {
    Assert.equals("1980", Date.fromString('1980-06-15 13:05:03').formatTerm('yyyy'));
    Assert.equals("2019", Date.fromString('2019-06-15 13:05:03').formatTerm('yyyy'));
  }

  public function testTimeSeprator() {
    Assert.equals(":", t1.formatTerm(':'));
    Assert.equals(":", t1.formatTerm(':', fr));
    Assert.equals(":", t1.formatTerm(':', it));
    Assert.equals(":", t1.formatTerm(':', jp));
  }

  public function testDateSeprator() {
    Assert.equals("/", t1.formatTerm('/'));
    Assert.equals(".", t1.formatTerm('/', ch));
    Assert.equals("/", t1.formatTerm('/', it));
    Assert.equals("/", t1.formatTerm('/', jp));
  }
*/
}
