package thx.format;

import thx.culture.Culture;
import thx.culture.Embed;
import utest.Assert;
import thx.LocalDate;
using thx.format.LocalDateFormat;

class TestLocalDateFormat {
  static var it = Embed.culture('it-it');
  static var ch = Embed.culture('it-ch');
  static var us = Embed.culture('en-us');
  static var ru = Embed.culture('ru-ru');
  static var fr = Embed.culture('fr-fr');
  static var jp = Embed.culture('ja-jp');
  static var d1 = LocalDate.fromString('2009-06-01');
  static var d2 = LocalDate.fromString('2009-06-15');
  public function new() {}

  public function testFormatd_() {
    Assert.equals("06/01/2009", d1.format('d'));
    Assert.equals("6/1/2009",   d1.format('d', us));
    Assert.equals("01/06/2009", d1.format('d', fr));
    Assert.equals("2009/06/01", d1.format('d', jp));

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

  public function testFormatu_() {
    Assert.equals("2009-06-01 00:00:00Z", d1.format('u'));
    Assert.equals("2009-06-01 00:00:00Z", d1.format('u', us));
    Assert.equals("2009-06-01 00:00:00Z", d1.format('u', fr));
    Assert.equals("2009-06-01 00:00:00Z", d1.format('u', jp));
    Assert.equals("2009-06-01 00:00:00Z", d1.universalSortable(it));
  }

  public function testFormatO() {
    Assert.equals("2009-06-01", d1.format('O'));
    Assert.equals("2009-06-01", d1.format('o', fr));
    Assert.equals("2009-06-01", d1.format('O', jp));
    Assert.equals("2009-06-01", d1.iso8601(it));
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

  public function testy() {
    Assert.equals("72", LocalDate.fromString('1972-06-15').formatTerm('y'));
  }

  public function testyy() {
    Assert.equals("09", d1.formatTerm('yy'));
    Assert.equals("72", LocalDate.fromString('1972-06-15').formatTerm('yy'));
  }

  public function testyyyy() {
    Assert.equals("1980", LocalDate.fromString('1980-06-15').formatTerm('yyyy'));
    Assert.equals("2019", LocalDate.fromString('2019-06-15').formatTerm('yyyy'));
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
