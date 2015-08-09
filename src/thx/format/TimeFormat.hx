package thx.format;

import thx.Time;
using thx.Ints;
using haxe.Int64;
import thx.culture.Culture;
import thx.culture.DateFormatInfo;
using thx.Nulls;
using thx.Strings;

import thx.format.DateFormat.*;

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
        var term = ereg.matched(0),
            right = ereg.matchedRight();
        pattern = right;
        if(term == "." && right.substring(0, 1).toLowerCase() == "f") {
          if(t.ticksInSecond == thx.Int64s.zero) {
            ereg.match(pattern);
            pattern = ereg.matchedRight();
            continue;
          }
        }
        buf.push(formatTerm(t, term, culture));
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
...       | custom pattern. It splits the pattern into pattern terms and apply them individually

See `formatTerm` for all the possible formatting options to use for custom patterns.
*/
public static function format(t : Time, pattern : String, ?culture : Culture) : String
  return switch pattern {
    case "c":      invariantTimeLong(t);
    case "g", "t": timeShort(t, culture);
    case "G", "T": timeLong(t, culture);
    case pattern:  customFormat(t, pattern, culture);
  };

/**
Returns a formatted date according to the passed term and culture. The pattern
parameter accepts the following modifiers in either Microsoft format or strftime format.

format   | description                                                          | example
:------- | -------------------------------------------------------------------- | ------------:
d        | The number of days                                                   | 7
dd       | Left padded number of days (between 2 and 8 characters)              | 07
dddddddd | The number of days padded left with zeroes up to 8.                  | 00000007
h        | The number of whole hours in the time interval that are not counted  |
         | as part of days.                                                     | 11
hh       | The number of whole hours in the time interval that are not counted  |
         | as part of days. Single-digit hours have a leading zero.             | 07
H        | The number of whole hours in the time interval.                      | 11
HHHHHHHH | The number of whole hours in the time interval. Left padded with 0   | 00000007
m        | Minutes (0 to 59).                                                   | 7
mm       | The number of whole minutes in the time interval that are not        | 07
         | included as part of hours or days. Single-digit seconds have a       |
         | leading zero.                                                        |
s        | Seconds (0 to 59).                                                   | 7
ss       | The number of whole seconds in the time interval that are not        | 07
         | included as part of hours, days, or minutes. Single-digit seconds    |
         | have a leading zero.                                                 |
f        | Outputs the tenth of a second.                                       |
fffffff  | Outputs up to the tenth of a microsecond. the tenth of a second.     |                                 |
F        | Outputs the tenth of a second.                                       |
FFFFFFF  |                                                                      |
:        | Time separator.                                                      | %
'...'    | Single quoted text is not processed (except for removing the quotes) | ...
"..."    | Double quoted text is not processed (except for removing the quotes) | ...

*/
  public static function formatTerm(t : Time, pattern : String, ?culture : Culture) : String
    return switch pattern {
      case "d":        '${t.days}';
      case "dd":       '${t.days}'.lpad('0', 2);
      case "ddd":      '${t.days}'.lpad('0', 3);
      case "dddd":     '${t.days}'.lpad('0', 4);
      case "ddddd":    '${t.days}'.lpad('0', 5);
      case "dddddd":   '${t.days}'.lpad('0', 6);
      case "ddddddd":  '${t.days}'.lpad('0', 7);
      case "dddddddd": '${t.days}'.lpad('0', 8);
      case "h":        '${t.hours}';
      case "hh":        t.hours.lpad('0', 2);
      case "H":        '${t.totalHours}';
      case "HH":       '${t.totalHours}'.lpad('0', 2);
      case "HHH":      '${t.totalHours}'.lpad('0', 3);
      case "HHHH":     '${t.totalHours}'.lpad('0', 4);
      case "HHHHH":    '${t.totalHours}'.lpad('0', 5);
      case "HHHHHH":   '${t.totalHours}'.lpad('0', 6);
      case "HHHHHHH":  '${t.totalHours}'.lpad('0', 7);
      case "HHHHHHHH": '${t.totalHours}'.lpad('0', 8);
      case "m":        '${t.minutes}';
      case "mm":       '${t.minutes}'.lpad('0', 2);
      case "s":        '${t.seconds}';
      case "ss":       '${t.seconds}'.lpad('0', 2);
      case "f":        getDecimalsPaddedUpTo(t.ticksInSecond, 1);
      case "ff":       getDecimalsPaddedUpTo(t.ticksInSecond, 2);
      case "fff":      getDecimalsPaddedUpTo(t.ticksInSecond, 3);
      case "ffff":     getDecimalsPaddedUpTo(t.ticksInSecond, 4);
      case "fffff":    getDecimalsPaddedUpTo(t.ticksInSecond, 5);
      case "ffffff":   getDecimalsPaddedUpTo(t.ticksInSecond, 6);
      case "fffffff":  getDecimalsPadded(t.ticksInSecond);
      case "F":        getDecimalsUpTo(t.ticksInSecond, 1);
      case "FF":       getDecimalsUpTo(t.ticksInSecond, 2);
      case "FFF":      getDecimalsUpTo(t.ticksInSecond, 3);
      case "FFFF":     getDecimalsUpTo(t.ticksInSecond, 4);
      case "FFFFF":    getDecimalsUpTo(t.ticksInSecond, 5);
      case "FFFFFF":   getDecimalsUpTo(t.ticksInSecond, 6);
      case "FFFFFFF":  getDecimalsString(t.ticksInSecond);
      case ".":        culture.number.separatorDecimalNumber;
      case ":":        dateTime(culture).separatorTime;
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
    var abs = time.abs(),
        dt = dateTime(culture),
        n = (null == culture ? Format.defaultCulture : culture).number,
        days = abs.days,
        hours = abs.hours,
        minutes = abs.minutes,
        seconds = abs.seconds,
        buf = '';
    if(time.isNegative)
      buf += n.signNegative;
    if(days != 0)
      buf += days + n.separatorDecimalNumber;
    buf += hours.lpad("0", 2);
    buf += dt.separatorTime;
    buf += minutes.lpad("0", 2);
    buf += dt.separatorTime;
    buf += seconds.lpad("0", 2);
    var t = abs.ticksInSecond;
    if(t != 0)
      buf += n.separatorDecimalNumber + getDecimalsPadded(t);
    return buf;
  }

/**
Short time format.
*/
  public static function timeShort(time : Time, ?culture : Culture) {
    var abs = time.abs(),
        dt = dateTime(culture),
        n = (null == culture ? Format.defaultCulture : culture).number,
        days = abs.days,
        hours = abs.hours,
        minutes = abs.minutes,
        seconds = abs.seconds,
        buf = '';
    if(time.isNegative)
      buf += n.signNegative;
    if(days != 0)
      buf += days + dt.separatorTime;
    buf += hours.lpad("0", 2);
    buf += dt.separatorTime;
    buf += minutes.lpad("0", 2);
    buf += dt.separatorTime;
    buf += seconds.lpad("0", 2);
    var t = abs.ticksInSecond;
    if(t != 0) {
      buf += n.separatorDecimalNumber + getDecimalsString(t);
    }
    return buf;
  }

  public static function invariantTimeLong(time : Time)
    return timeLong(time, Culture.invariant);

  public static function offsetHoursShort(offset : Time, ?culture : Culture) {
    var n = (null == culture ? Format.defaultCulture : culture).number,
        abs = offset.abs();
    return (offset.isNegative ? n.signNegative : n.signPositive) +
      abs.totalHours;
  }

  public static function offsetHoursLong(offset : Time, ?culture : Culture) {
    var n = (null == culture ? Format.defaultCulture : culture).number,
        abs = offset.abs();
    return (offset.isNegative ? n.signNegative : n.signPositive) +
      abs.totalHours.toStr().lpad("0", 2);
  }

  public static function offsetLong(offset : Time, ?culture : Culture) {
    var dt = dateTime(culture),
        n = (null == culture ? Format.defaultCulture : culture).number,
            abs = offset.abs();
    return (offset.isNegative ? n.signNegative : n.signPositive) +
      abs.totalHours.toStr().lpad("0", 2) +
      dt.separatorTime +
      abs.minutes.lpad("0", 2);
  }

  public static function iso8601OffsetShort(offset : Time) {
    var abs = offset.abs();
    return (offset.isNegative ? "-" : "+") +
      abs.totalHours.toStr().lpad("0", 2) +
      abs.minutes.lpad("0", 2);
  }

  static inline function getPattern() return ~/(d|H){1,8}|(f|F){1,7}|(h|m|s){1,2}|[:.]|'[^']*'|"[^"]*"/;
}
