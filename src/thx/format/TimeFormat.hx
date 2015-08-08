package thx.format;

import haxe.Utf8; // remove?
import thx.Time;
import thx.culture.Culture;
import thx.culture.DateFormatInfo;
using thx.Ints;
using thx.Nulls;
using thx.Strings;

import thx.format.DateFormat.dateTime;

@:access(thx.format.DateFormat)
class TimeFormat {
  /**
  Custom time format.
  */
  public static function customFormat(t : Time, pattern : String, ?culture : Culture) : String {
    culture = (culture).or(Format.defaultCulture);
    var ereg = getPattern(),
        escape = false,
        buf = [];
    while(pattern.length > 0) {
      if(escape) {
        escape = false;
        buf.push(pattern.substring(0, 1));
        pattern = pattern.substring(1);
      } else if(ereg.match(pattern)) {
        var left = ereg.matchedLeft();
        if(left.substring(-1) == "\\") {
          escape = true;
          pattern = pattern.substring(left.length);
          buf.push(left.substring(0, left.length - 1));
          continue;
        }
        buf.push(left);
        buf.push(formatTerm(t, ereg.matched(0), culture));
        pattern = ereg.matchedRight();
      } else {
        buf.push(pattern);
        pattern = '';
      }
    }
    if(escape)
      buf.push('\\');
    return buf.join('');
  }

/**
Formats the time using a one letter formatting option or using a custom pattern.

pattern   | description
--------- | ------------------------------------
`c`       | constant format (not culture specific)
`g` | `t` | short time pattern
`G` | `T` | long time pattern
          |   [-]d’:’hh’:’mm’:’ss.fffffff
...       | custom pattern. It splits the pattern into pattern terms and apply them individually

See `formatTerm` for all the possible formatting options to use for custom patterns.
*/
public static function format(t : Time, pattern : String, ?culture : Culture) : String
  return switch pattern {
    case "c": invariantTimeLong(t);
    case "g", "t": timeShort(t, culture);
    case "G", "T": timeLong(t, culture);
    case pattern:  customFormat(t, pattern, culture);
  };

  // NOT SUPPORTED
  // f, ff, fff, ffff, fffff, ffffff, fffffff, F, FF, FFF, FFFF, FFFFF, FFFFFF, FFFFFFF, g, gg, K, yyyyy, z, zz, zzz
  /**
  Returns a formatted date according to the passed term and culture. The pattern
  parameter accepts the following modifiers in either Microsoft format or strftime format.

  format   | description                                                          | example
  :------- | -------------------------------------------------------------------- | ------------:
  d        | The number of days.                                                  | 7
  dd-dddddddd
           | The number of days padded left with zeroes up to 8.                  | 7
  h        | The number of whole hours in the time interval that are not counted
             as part of days.                                                     | 11
  hh       | The number of whole hours in the time interval that are not counted
             as part of days. Single-digit hours have a leading zero.             | 07
  s        | Seconds (0 to 59).                                                   | 7
  ss       | The number of whole seconds in the time interval that are not
             included as part of hours, days, or minutes. Single-digit seconds
             have a leading zero.                                                 | 7
  f-fffffff |
  F-FFFFFFF |

  ??? H-HHHHHHHH



  ddd      | The abbreviated weekday name according to the current locale.        | Wed
  dddd     | The full weekday name according to the current locale.               | Wednesday
  MMM      | The abbreviated month name according to the current locale.          | Jan
  MMMM     | The full month name according to the current locale.                 | January
  dd       | The day of the month as a decimal number (range 01 to 31).           | 07
  MMM      | Equivalent to %b.                                                    | Jan
  HH       | The hour as a decimal number using a 24-hour clock (range 00 to 23). | 22
  hh       | The hour as a decimal number using a 12-hour clock (range 01 to 12). | 07
  MM       | The month as a decimal number (range 01 to 12).                      | 04
  mm       | The minute as a decimal number (range 00 to 59).                     | 08
  tt       | Either 'AM' or 'PM' according to the given time value, or the corresponding strings for the current locale. Noon is treated as 'pm' and midnight as 'am'. | AM
  ss       | The second as a decimal number (range 00 to 61). the upper level of the range 61 rather than 59 to allow for the occasional leap second and even more occasional double leap second. | 07
  y        | The year as a decimal number without a century (range 00 to 99).     | 04
  d        | The day of the month (1 to 31).                                      | 7
  h        | The hour on a 12-hour clock (1 to 12).                               | 11
  H        | Same as `h` but `0` padded (01 to 12).                               | 07
  m        | Minute (0 to 59).                                                    | 7
  M        | Same as `m` but `0` padded (00 to 59).                               | 07
  s        | Seconds (0 to 59).                                                   | 7
  t        | Same as `s` but `0` padded (00 to 59).                               | 07
  yy       | Year from 00 to 99.                                                  | 99
  yyy      | Year with at least 3 digits.                                         | 1999
  yyyy     | Four digits year.                                                    | 1999
  :        | Time separator.                                                      | %
  /        | Date separator.                                                      | /
  '...'    | Single quoted text is not processed (except for removing the quotes) | ...
  "..."    | Double quoted text is not processed (except for removing the quotes) | ...
  %?       | Delegates to `strftime`                                              | %d

  */
  public static function formatTerm(t : Time, pattern : String, ?culture : Culture) : String
    return switch pattern {
      case "d":     '${t.days}';
      case "dd":    '${t.days}'.lpad('0', 2);
      //case "ddd":   var dt = dateTime(culture);
      //              dt.nameDaysAbbreviated[t.dayOfWeek];
      //case "dddd":  var dt = dateTime(culture);
      //              dt.nameDays[t.dayOfWeek];
      case "h":     switch t.hours {
                      case 0:             "12";
                      case d if(d <= 12): '$d';
                      case d:             '${d - 12}';
                    };
      case "hh":    formatTerm(t, 'h', culture).lpad('0', 2);
      case "H":     '${t.hours}';
      case "HH":    '${t.hours}'.lpad('0', 2);
      case "m":     '${t.minutes}';
      case "mm":    '${t.minutes}'.lpad('0', 2);
      //case "M":     '${t.month}';
      //case "MM":    '${t.month}'.lpad('0', 2);
      //case "MMM":   var dt = dateTime(culture);
      //              dt.nameMonthsAbbreviated[t.month-1];
      //case "MMMM":  var dt = dateTime(culture);
      //              dt.nameMonths[t.month-1];
      case "s":     '${t.seconds}';
      case "ss":    '${t.seconds}'.lpad('0', 2);
      case "t":     var dt = dateTime(culture);
                    Utf8.sub(t.hours < 12 ? dt.designatorAm : dt.designatorPm, 0, 1);
      case "tt":    var dt = dateTime(culture);
                    t.hours < 12 ? dt.designatorAm : dt.designatorPm;
      //case "y":     '${t.year%100}';
      //case "yy":    '${t.year%100}'.lpad('0', 2);
      //case "yyy":   '${t.year}'.lpad('0', 3);
      //case "yyyy":  '${t.year}'.lpad('0', 4);
      case ":":     dateTime(culture).separatorTime;
      //case "/":     dateTime(culture).separatorDate;
      case q if(q.substring(0, 1) == "%"):
                    strftime(t, pattern, culture);
      case q if(q != null && q.length > 1 &&
        (q.substring(0, 1) == "'" && q.substring(q.length - 1) == "'") ||
        (q.substring(0, 1) == '"' && q.substring(q.length - 1) == '"')):
                    q.substring(1, q.length - 1);
      case rest:    rest;
    };

/**
Long time format.
*/
  public static function timeLong(time : Time, ?culture : Culture) {
    var dt = dateTime(culture),
        n = (null == culture ? Format.defaultCulture : culture).number;
    var days = time.days,
        hours = time.hours,
        minutes = time.minutes,
        seconds = time.seconds,
        buf = '';
    if(time.isNegative)
      buf += n.signNegative;
    if(days != 0)
      buf += days + n.separatorDecimalNumber;
    buf += hours.lpad(2, '0');
    buf += dt.separatorTime;
    buf += minutes.lpad(2, '0');
    buf += dt.separatorTime;
    buf += seconds.lpad(2, '0');
    var t = time.ticksInSecond;
    if(t != 0)
      buf += n.separatorDecimalNumber + t.lpad(7, '0');
    return buf;
  }

/**
Short time format.
*/
  public static function timeShort(time : Time, ?culture : Culture) {
    var dt = dateTime(culture),
        n = (null == culture ? Format.defaultCulture : culture).number;
    var days = time.days,
        hours = time.hours,
        minutes = time.minutes,
        seconds = time.seconds,
        buf = '';
    if(time.isNegative)
      buf += n.signNegative;
    if(days != 0)
      buf += days + dt.separatorTime;
    buf += hours.lpad(2, '0');
    buf += dt.separatorTime;
    buf += minutes.lpad(2, '0');
    buf += dt.separatorTime;
    buf += seconds.lpad(2, '0');
    var t = time.ticksInSecond;
    if(t != 0) {
      buf += n.separatorDecimalNumber + t.lpad(7, '0');
      buf = buf.trimCharsRight('0');
    }
    return buf;
  }

  public static function invariantTimeLong(t : Time)
    return timeLong(t, Culture.invariant);

  static inline function getPattern() return ~/(d|M|y){1,4}|(h|H|m|s|t){1,2}|[:]|[\/]|'[^']*'|"[^"]*"|[%][daAIHMmbhBSpycCeDfiklnPqrRstTuYxXw%]/;
}
