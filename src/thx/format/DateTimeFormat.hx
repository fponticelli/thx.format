package thx.format;

import haxe.Utf8;
import thx.core.Error;
import thx.culture.Culture;
import thx.culture.DateTimeFormatInfo;
using thx.core.Defaults;
//using thx.core.Ints;
using StringTools;

class DateTimeFormat {
  public static function format(d : Date, ?format : DTFormat, ?culture : Culture) : String
    return switch format {
      case DateLong:          dateLong(d, culture);
      case DateShort:         dateShort(d, culture);
      case DateTimeFull:      dateTimeFull(d, culture);
      case DateTimeSortable:  dateTimeSortable(d, culture);
      case MonthDay:          monthDay(d, culture);
      case Rfc1123:           rfc1123(d, culture);
      case TimeLong:          timeLong(d, culture);
      case TimeShort:         timeShort(d, culture);
      case UniversalSortable: universalSortable(d, culture);
      case YearMonth:         yearMonth(d, culture);
    };

  public static function dateLong(d : Date, ?culture : Culture)
    return formatPattern(d, dateTime(culture).patternDateLong, culture);

  public static function dateShort(d : Date, ?culture : Culture)
    return formatPattern(d, dateTime(culture).patternDateShort, culture);

  public static function dateTimeFull(d : Date, ?culture : Culture)
    return formatPattern(d, dateTime(culture).patternDateTimeFull, culture);

  public static function dateTimeSortable(d : Date, ?culture : Culture)
    return formatPattern(d, dateTime(culture).patternDateTimeSortable, culture);

  public static function monthDay(d : Date, ?culture : Culture)
    return formatPattern(d, dateTime(culture).patternMonthDay, culture);

  public static function rfc1123(d : Date, ?culture : Culture)
    return formatPattern(d, dateTime(culture).patternRfc1123, culture);

  public static function timeLong(d : Date, ?culture : Culture)
    return formatPattern(d, dateTime(culture).patternTimeLong, culture);

  public static function timeShort(d : Date, ?culture : Culture)
    return formatPattern(d, dateTime(culture).patternTimeShort, culture);

  public static function universalSortable(d : Date, ?culture : Culture)
    return formatPattern(d, dateTime(culture).patternUniversalSortable, culture);

  public static function yearMonth(d : Date, ?culture : Culture)
    return formatPattern(d, dateTime(culture).patternYearMonth, culture);

  static function dateTime(?culture : Culture)
    return null != culture && null != culture.dateTime ? culture.dateTime : Culture.invariant.dateTime;

  public static function formatPattern(d : Date, format : String, ?culture : Culture) : String {
    return null;
  }

  // NOT SUPPORTED
  // f, ff, fff, ffff, fffff, ffffff, fffffff, F, FF, FFF, FFFF, FFFFF, FFFFFF, FFFFFFF, g, gg, K
  public static function formatTerm(d : Date, format : String, ?culture : Culture) : String {
    var dt = dateTime(culture);
    return switch format {
      case "d":     ""+d.getDate();
      case "dd":    (""+d.getDate()).lpad('0', 2);
      case "ddd":   dt.nameDaysAbbreviated[d.getDay()];
      case "dddd":  dt.nameDays[d.getDay()];
      case "h":     switch d.getHours() {
                      case 0: "12";
                      case d if(d <= 12): '$d';
                      case d: '${d - 12}';
                    };
      case "hh":    formatTerm(d, 'h', culture).lpad('0', 2);
      case "H":     '${d.getHours()}';
      case "HH":    '${d.getHours()}'.lpad('0', 2);
      case "m":     '${d.getMinutes()}';
      case "mm":    '${d.getMinutes()}'.lpad('0', 2);
      case "M":     '${d.getMonth()+1}';
      case "MM":    '${d.getMonth()+1}'.lpad('0', 2);
      case "MMM":   dt.nameMonthsAbbreviated[d.getMonth()];
      case "MMMM":  dt.nameMonths[d.getMonth()];
      case "s":     '${d.getSeconds()}';
      case "ss":    '${d.getSeconds()}'.lpad('0', 2);
      case "t":     Utf8.sub(d.getHours() < 12 ? dt.designatorAm : dt.designatorPm, 0, 1);
      case "tt":    d.getHours() < 12 ? dt.designatorAm : dt.designatorPm;
      case "y":     '${d.getFullYear()%100}';
      case "yy":    '${d.getFullYear()%100}'.lpad('0', 2);
      case rest:    rest;
    };
  }
}

enum DTFormat {
  DateLong;
  DateShort;
  DateTimeFull;
  DateTimeSortable;
  MonthDay;
  Rfc1123;
  TimeLong;
  TimeShort;
  UniversalSortable;
  YearMonth;
}