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
Format a date using a `strftime` term.

strftime | description                                                        | example
:------: | -------------------------------------------------------------------| ------------:
%H       | The hour as a decimal number using a 24-hour clock (range 00 to 23). | 22
%i       | The minute. Single-digit minutes may be prefixed by leadingspace.* | " 8"
%k       | The hour (24-hour clock) as a decimal number (range 0 to 23); single-digits are optionally prefixed by leadingspace. (See also %H). | 7
%M       | The minute as a decimal number (range 00 to 59).                   | 08
%n       | A newline character.                                               |
%q       | The second. Single-digit seconds may be prefixed by leadingspace.* | " 9"
%R       | The time in 24-hour notation (%H:%M). For a version including the seconds, see %T below. | 07:08
%S       | The second as a decimal number (range 00 to 61). the upper level of the range 61 rather than 59 to allow for the occasional leap second and even more occasional double leap second. | 07
%t       | A tab character.                                                   |
%T       | The time in 24-hour notation (%H:%M:%S).                           | 17:08:09
%%       | A literal '%' character.                                           | %



%M - Minute of the hour (00..59)

%S - Second of the minute (00..60)

%L - Millisecond of the second (000..999)
%N - Fractional seconds digits, default is 9 digits (nanosecond)
        %3N  millisecond (3 digits)
        %6N  microsecond (6 digits)
        %9N  nanosecond (9 digits)
        %12N picosecond (12 digits)


%a       | The abbreviated weekday name according to the current locale.      | Wed
%A       | The full weekday name according to the current locale.             | Wednesday
%b       | The abbreviated month name according to the current locale.        | Jan
%B       | The full month name according to the current locale.               | January
%c       | The preferred date and time representation for the current locale. |
%C       | The century number (year/100) as a 2-digit integer.                | 19
%d       | The day of the month as a decimal number (range 01 to 31).         | 07
%D       | Equivalent to %m/%d/%y. (This is the USA date format. In many countries %d/%m/%y is the standard date format. Thus, in an international context, both of these formats are ambiguous and should be avoided). | 06/25/04
%e       | Like %d, the day of the month as a decimal number, but a leading zero may be replaced by a leadingspace. | " 7"
%f       | The month. Single-digit months may be prefixed by leadingspace.*   | " 6"
%h       | Equivalent to %b.                                                  | Jan
%H       | The hour as a decimal number using a 24-hour clock (range 00 to 23). | 22
%i       | The minute. Single-digit minutes may be prefixed by leadingspace.* | " 8"
%I       | The hour as a decimal number using a 12-hour clock (range 01 to 12).| 07
%k       | The hour (24-hour clock) as a decimal number (range 0 to 23); single-digits are optionally prefixed by leadingspace. (See also %H). | 7
%l       | The hour (12-hour clock) as a decimal number (range 1 to 12); single-digits are optionally prefixed by leadingspace. (See also %I). | 7
%m       | The month as a decimal number (range 01 to 12).                    | 04
%M       | The minute as a decimal number (range 00 to 59).                   | 08
%n       | A newline character.                                               |
%p       | Either 'AM' or 'PM' according to the given time value, or the corresponding strings for the current locale. Noon is treated as 'pm' and midnight as 'am'. | AM
%P       | Like %p but in lowercase: 'am' or 'pm' or a corresponding string for the current locale. | AM
%q       | The second. Single-digit seconds may be prefixed by leadingspace.* | " 9"
%r       | The time in a.m. or p.m. notation. In the POSIX locale this is equivalent to '%I:%M:%S %p'. | 07:08:09 am
%R       | The time in 24-hour notation (%H:%M). For a version including the seconds, see %T below. | 07:08
%s       | The number of seconds since the Epoch, i.e., since 1970-01-01 00:00:00 UTC. | 1099928130
%S       | The second as a decimal number (range 00 to 61). the upper level of the range 61 rather than 59 to allow for the occasional leap second and even more occasional double leap second. | 07
%t       | A tab character.                                                   |
%T       | The time in 24-hour notation (%H:%M:%S).                           | 17:08:09
%u       | The day of the week as a decimal, range 1 to 7, Monday being 1. See also %w. |
%w       | The day of the week as a decimal, range 0 to 6, Sunday being 0. See also %u. |
%x       | The preferred date representation for the current locale without the time. |
%X       | The preferred time representation for the current locale without the date. |
%y       | The year as a decimal number without a century (range 00 to 99).   | 04
%Y       | The year as a decimal number including the century.                | 2004
%%       | A literal '%' character.                                           | %

*customs for missing features
*/
/*
%z	The time zone offset. Not implemented as described on Windows. See below for more information.	Example: -0500 for US Eastern Time
%Z	The time zone abbreviation. Not implemented as described on Windows. See below for more information.	Example: EST for Eastern Time
*/
  public static function strftime(t : Time, pattern : String, ?culture : Culture) : String
    return switch pattern {
      case "%d":    formatTerm(t, "dd", culture);
      case "%a":    formatTerm(t, "ddd", culture);
      case "%A":    formatTerm(t, "dddd", culture);
      case "%I":    formatTerm(t, "hh", culture);
      case "%H":    formatTerm(t, "HH", culture);
      case "%M":    formatTerm(t, "mm", culture);
      case "%m":    formatTerm(t, "MM", culture);
      case "%b",
           "%h":    formatTerm(t, "MMM", culture);
      case "%B":    formatTerm(t, "MMMM", culture);
      case "%S":    formatTerm(t, "ss", culture);
      case "%p":    formatTerm(t, "tt", culture);
      case "%y":    formatTerm(t, "y", culture);
      //case "%c":    dateTimeFull(t, culture);
      //case "%C":    '${Math.floor(t.year/100)}';
      case "%e":    '${t.days}'.lpad(' ', 2);
      case "%D":    format(t, "%m/%d/%y", culture);
      //case "%f":    '${t.month}'.lpad(' ', 2);
      case "%i":    '${t.minutes}'.lpad(' ', 2);
      case "%k":    '${t.hours}'.lpad(' ', 2);
      case "%l":    formatTerm(t, 'h', culture).lpad(' ', 2);
      case "%n":    "\n";
      case "%P":    var dt = dateTime(culture);
                    (t.hours < 12 ? dt.designatorAm : dt.designatorPm).toLowerCase();
      case "%q":    '${t.seconds}'.lpad(' ', 2);
      case "%r":    format(t, "%I:%M:%S %p", culture);
      case "%R":    format(t, "%H:%M", culture);
      //case "%s":    '${Std.int(t.utc.toTime()/1000)}';
      case "%t":    "\t";
      case "%T":    format(t, "%H:%M:%S", culture);
      //case "%u":    var day = t.dayOfWeek;
      //              day == 0 ? '7' : '$day';
      //case "%Y":    '${t.year}';
      //case "%x":    dateLong(t, culture);
      case "%X":    timeLong(t, culture);
      //case "%w":    '${t.dayOfWeek}';
      case "%%":    "%";
      case rest:    rest;
    };

/**
Long time format.
*/
  public static function timeLong(t : Time, ?culture : Culture) {
    var dt = dateTime(culture),
        n = (null == culture ? Format.defaultCulture : culture).number;
    // TODO fffffffff
    // [-][d’.’]hh’:’mm’:’ss[‘.’fffffff]
    var days = t.days,
        hours = t.hours,
        minutes = t.minutes,
        seconds = t.seconds,
        buf = '';
    if(t.isNegative)
      buf += n.signNegative;
    if(days != 0)
      buf += days + n.separatorDecimalNumber;
    buf += hours.lpad(2, '0');
    buf += dt.separatorTime;
    buf += minutes.lpad(2, '0');
    buf += dt.separatorTime;
    buf += seconds.lpad(2, '0');

    return buf;
  }

/**
Sort time format.
*/
  public static function timeShort(t : Time, ?culture : Culture) {
    // TODO FFFFFFF
    // [-][d’:’]h’:’mm’:’ss[.FFFFFFF]
      var dt = dateTime(culture),
          n = (null == culture ? Format.defaultCulture : culture).number;
      var days = t.days,
          hours = t.hours,
          minutes = t.minutes,
          seconds = t.seconds,
          buf = '';
      if(t.isNegative)
        buf += n.signNegative;
      if(days != 0)
        buf += days + dt.separatorTime;
      buf += hours.lpad(2, '0');
      buf += dt.separatorTime;
      buf += minutes.lpad(2, '0');
      buf += dt.separatorTime;
      buf += seconds.lpad(2, '0');

    return buf;
  }

  public static function invariantTimeLong(t : Time)
    return timeLong(t, Culture.invariant);

  static inline function getPattern() return ~/(d|M|y){1,4}|(h|H|m|s|t){1,2}|[:]|[\/]|'[^']*'|"[^"]*"|[%][daAIHMmbhBSpycCeDfiklnPqrRstTuYxXw%]/;
}
