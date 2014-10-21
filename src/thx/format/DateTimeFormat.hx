package thx.format;

import haxe.Utf8;
import thx.culture.Culture;
import thx.culture.DateTimeFormatInfo;
using thx.core.Defaults;
using StringTools;

//O, o    | 
/**
Formats the date using a one letter formatting option or using a custom pattern.

pattern | description                          | example
------- | ------------------------------------ | -------
d       | short date pattern                   |
D       | long date pattern                    |
f       | long date + short time pattern       |
F       | long date + long time pattern        |
g       | short date + short time pattern      |
G       | short date + long time pattern       |
M, m    | month/day pattern                    |
R, r    | RFC1123 pattern                      |
s       | sortable date/time pattern           |
t       | short time pattern                   |
T       | long time pattern                    |
u       | universal sortable date/time pattern |
U       | universal full date/time pattern     |
Y, y    | year/month pattern                   |
...     | custom pattern. It splits the pattern into pattern terms and apply them individually

See `formatTerm` for all the possible formatting options to use for custom patterns.
*/
class DateTimeFormat {
  public static function format(d : Date, format : String, ?culture : Culture) : String
    return switch format {
      case "d": dateShort(d, culture);
      case "D": dateLong(d, culture);
      case "f": dateLong(d, culture) + ' ' + timeShort(d, culture);
      case "F": dateLong(d, culture) + ' ' + timeLong(d, culture);
      case "g": dateShort(d, culture) + ' ' + timeShort(d, culture);
      case "G": dateShort(d, culture) + ' ' + timeLong(d, culture);
      case "M",
           "m": monthDay(d, culture);
      case "R",
           "r": rfc1123(d, culture);
      case "s": dateTimeSortable(d, culture);
      case "t": timeShort(d, culture);
      case "T": timeLong(d, culture);
      case "u": universalSortable(d, culture);
      case "U": dateTimeFull(d, culture);
      case "y",
           "Y": yearMonth(d, culture);
      case pattern:
        formatPattern(d, pattern, culture);
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
    culture = (culture).or(Culture.invariant);
    var escape = false,
        buf = [];
    while(format.length > 0) {
      if(escape) {
        escape = false;
        buf.push(format.substr(0, 1));
        format = format.substr(1);
      } else if(PATTERN.match(format)) {
        var left = PATTERN.matchedLeft();
        if(left.substr(-1) == "\\") {
          escape = true;
          format = format.substr(left.length);
          buf.push(left.substr(0, left.length - 1));
          continue;
        }
        buf.push(left);
        buf.push(formatTerm(d, PATTERN.matched(0), culture));
        format = PATTERN.matchedRight();
      } else {
        buf.push(format);
        format = '';
      }
    }
    if(escape)
      buf.push('\\');
    return buf.join('');
  }

// NOT SUPPORTED
// f, ff, fff, ffff, fffff, ffffff, fffffff, F, FF, FFF, FFFF, FFFFF, FFFFFF, FFFFFFF, g, gg, K, yyyyy, z, zz, zzz
//      | %z | The time-zone as hour offset from GMT. Required to emit RFC822-conformant dates (using "%a, %d %b %Y %H:%M:%S %z"). | -2
//      | %Z | The time zone or name or abbreviation.                             | GMT
//      | %G | The ISO 8601 year with century as a decimal number. The 4-digit year corresponding to the ISO week number (see %V). This has the same format and value as %y, except that if the ISO week number belongs to the previous or next year, that year is used instead. | 2004
//      | %g | Like %G, but without century, i.e., with a 2-digit year (00-99).   | 04
//      | %j | The day of the year as a decimal number (range 001 to 366).        | 008
//      | %U | The week number of the current year as a decimal number, range 00 to 53, starting with the first Sunday as the first day of week 01. See also %V and %W. | 26
//      | %V | The ISO 8601:1988 week number of the current year as a decimal number, range 01 to 53, where week 1 is the first week that has at least 4 days in the current year, and with Monday as the first day of the week. See also %U and %W. | 26
//      | %W | The week number of the current year as a decimal number, range 00 to 53, starting with the first Monday as the first day of week 01. |
/**
Returns a formatted date according to the passed term and culture. The pattern
paramter accepts the following modifiers in either Microsoft format or strftime format.

MS    | strftime | description                                                        | example
:---- | :------: | -------------------------------------------------------------------| ------------:
ddd   | %a       | The abbreviated weekday name according to the current locale.      | Wed
dddd  | %A       | The full weekday name according to the current locale.             | Wednesday
MMM   | %b       | The abbreviated month name according to the current locale.        | Jan
MMMM  | %B       | The full month name according to the current locale.               | January
      | %c       | The preferred date and time representation for the current locale. |
      | %C       | The century number (year/100) as a 2-digit integer.                | 19
dd    | %d       | The day of the month as a decimal number (range 01 to 31).         | 07
      | %D       | Equivalent to %m/%d/%y. (This is the USA date format. In many countries %d/%m/%y is the standard date format. Thus, in an international context, both of these formats are ambiguous and should be avoided). | 06/25/04
      | %e       | Like %d, the day of the month as a decimal number, but a leading zero may be replaced by a leadingspace. | " 7"
      | %f       | The month. Single-digit months may be prefixed by leadingspace.*   | " 6"
MMM   | %h       | Equivalent to %b.                                                  | Jan
HH    | %H       | The hour as a decimal number using a 24-hour clock (range 00 to 23). | 22
      | %i       | The minute. Single-digit minutes may be prefixed by leadingspace.* | " 8"
hh    | %I       | The hour as a decimal number using a 12-hour clock (range 01 to 12).| 07
      | %k       | The hour (24-hour clock) as a decimal number (range 0 to 23); single-digits are optionally prefixed by leadingspace. (See also %H). | 7
      | %l       | The hour (12-hour clock) as a decimal number (range 1 to 12); single-digits are optionally prefixed by leadingspace. (See also %I). | 7
MM    | %m       | The month as a decimal number (range 01 to 12).                    | 04
mm    | %M       | The minute as a decimal number (range 00 to 59).                   | 08
      | %n       | A newline character.                                               |
tt    | %p       | Either 'AM' or 'PM' according to the given time value, or the corresponding strings for the current locale. Noon is treated as 'pm' and midnight as 'am'. | AM
      | %P       | Like %p but in lowercase: 'am' or 'pm' or a corresponding string for the current locale. | AM
      | %q       | The second. Single-digit seconds may be prefixed by leadingspace.* | " 9"
      | %r       | The time in a.m. or p.m. notation. In the POSIX locale this is equivalent to '%I:%M:%S %p'. | 07:08:09 am
      | %R       | The time in 24-hour notation (%H:%M). For a version including the seconds, see %T below. | 07:08
      | %s       | The number of seconds since the Epoch, i.e., since 1970-01-01 00:00:00 UTC. | 1099928130
ss    | %S       | The second as a decimal number (range 00 to 61). the upper level of the range 61 rather than 59 to allow for the occasional leap second and even more occasional double leap second. | 07
      | %t       | A tab character.                                                   |
      | %T       | The time in 24-hour notation (%H:%M:%S).                           | 17:08:09
      | %u       | The day of the week as a decimal, range 1 to 7, Monday being 1. See also %w. |
      | %w       | The day of the week as a decimal, range 0 to 6, Sunday being 0. See also %u. |
      | %x       | The preferred date representation for the current locale without the time. |
      | %X       | The preferred time representation for the current locale without the date. |
y     | %y       | The year as a decimal number without a century (range 00 to 99).   | 04
      | %Y       | The year as a decimal number including the century.                | 2004
      | %%       | A literal '%' character.                                           | %
d     |          | The day of the month (1 to 31).                                    | 7
h     |          | The hour on a 12-hour clock (1 to 12).                             | 11
H     |          | Same as `h` but `0` padded (01 to 12).                             | 07
m     |          | Minute (0 to 59).                                                  | 7
M     |          | Same as `m` but `0` padded (00 to 59).                             | 07
s     |          | Seconds (0 to 59).                                                 | 7
t     |          | Same as `s` but `0` padded (00 to 59).                             | 07
yy    |          | Year from 00 to 99.                                                | 99
yyy   |          | Year with at least 3 digits.                                       | 1999
yyyy  |          | Four digits year.                                                  | 1999
:     |          | Time separator.                                                    | %
/     |          | Date separator.                                                    | /
'...' |          | Single quoted text is not processed (except for removing the quotes) | ...
"..." |          | Double quoted text is not processed (except for removing the quotes) | ...

*customs for missing features
*/
  public static function formatTerm(d : Date, format : String, ?culture : Culture) : String {
    var dt = dateTime(culture);
    //trace(format);
    return switch format {
      case "d":     '${d.getDate()}';
      case "%d",
           "dd":    '${d.getDate()}'.lpad('0', 2);
      case "%a",
           "ddd":   dt.nameDaysAbbreviated[d.getDay()];
      case "%A",
           "dddd":  dt.nameDays[d.getDay()];
      case "h":     switch d.getHours() {
                      case 0:             "12";
                      case d if(d <= 12): '$d';
                      case d:             '${d - 12}';
                    };
      case "%I",
           "hh":    formatTerm(d, 'h', culture).lpad('0', 2);
      case "H":     '${d.getHours()}';
      case "%H",
           "HH":    '${d.getHours()}'.lpad('0', 2);
      case "m":     '${d.getMinutes()}';
      case "%M",
           "mm":    '${d.getMinutes()}'.lpad('0', 2);
      case "M":     '${d.getMonth()+1}';
      case "%m",
           "MM":    '${d.getMonth()+1}'.lpad('0', 2);
      case "%b",
           "%h",
           "MMM":   dt.nameMonthsAbbreviated[d.getMonth()];
      case "%B",
           "MMMM":  dt.nameMonths[d.getMonth()];
      case "s":     '${d.getSeconds()}';
      case "%S",
           "ss":    '${d.getSeconds()}'.lpad('0', 2);
      case "t":     Utf8.sub(d.getHours() < 12 ? dt.designatorAm : dt.designatorPm, 0, 1);
      case "%p",
           "tt":    d.getHours() < 12 ? dt.designatorAm : dt.designatorPm;
      case "%y",
           "y":     '${d.getFullYear()%100}';
      case "yy":    '${d.getFullYear()%100}'.lpad('0', 2);
      case "yyy":   '${d.getFullYear()}'.lpad('0', 3);
      case "yyyy":  '${d.getFullYear()}'.lpad('0', 4);
      case ":":     dt.separatorTime;
      case "/":     dt.separatorDate;
      case "%c":    dateTimeFull(d, culture);
      case "%C":    '${Math.floor(d.getFullYear()/100)}';
      case "%e":    '${d.getDate()}'.lpad(' ', 2);
      case "%D":    DateTimeFormat.format(d, "%m/%d/%y", culture);
      case "%f":    '${d.getMonth()+1}'.lpad(' ', 2);
      case "%i":    '${d.getMinutes()}'.lpad(' ', 2);
      case "%k":    '${d.getHours()}'.lpad(' ', 2);
      case "%l":    formatTerm(d, 'h', culture).lpad(' ', 2);
      case "%n":    "\n";
      case "%P":    (d.getHours() < 12 ? dt.designatorAm : dt.designatorPm).toLowerCase();
      case "%q":    '${d.getSeconds()}'.lpad(' ', 2);
      case "%r":    DateTimeFormat.format(d, "%I:%M:%S %p", culture);
      case "%R":    DateTimeFormat.format(d, "%H:%M", culture);
      case "%s":    '${Std.int(d.getTime()/1000)}';
      case "%t":    "\t";
      case "%T":    DateTimeFormat.format(d, "%H:%M:%S", culture);
      case "%u":    var day = d.getDay();
                    day == 0 ? '7' : '$day';
      case "%Y":    '${d.getFullYear()}';
      case "%x":    dateLong(d, culture);
      case "%X":    timeLong(d, culture);
      case "%w":    '${d.getDay()}';
      case "%%":    "%";
      case q if(q != null && q.length > 1 &&
        (q.substr(0, 1) == "'" && q.substr(-1) == "'") ||
        (q.substr(0, 1) == '"' && q.substr(-1) == '"')):
                    q.substr(1, q.length - 2);
      case rest:    rest;
    };
  }
  static var PATTERN = ~/(d|M|y){1,4}|(h|H|m|s|t){1,2}|[:]|[\/]|'[^']*'|"[^"]*"|[%][daAIHMmbhBSpycCeDfiklnPqrRstTuYxXw%]/;
}