package thx.format;

import haxe.Utf8;
using thx.Ints;
using thx.Strings;
import thx.DateTime;
import thx.culture.Culture;
import thx.culture.DateFormatInfo;
using thx.Nulls;
using StringTools;

class LocalDateFormat {
/**
Custom date format.
*/
  public static function customFormat(d : LocalDate, pattern : String, ?culture : Culture) : String {
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
        var term = ereg.matched(0);
        pattern = ereg.matchedRight();
        buf.push(formatTerm(d, term, culture));
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
Formats the date using a one letter formatting option or using a custom pattern.

pattern   | description
--------- | ------------------------------------
`d`       | short date pattern
`D`       | long date pattern
`M`, `m`  | month/day pattern
`O`, `o`  | roundtrip format
`R`, `r`  | RFC1123 pattern
`u`       | universal sortable date pattern
`Y`, `y`  | year/month pattern
...       | custom pattern. It splits the pattern into pattern terms and apply them individually

See `formatTerm` for all the possible formatting options to use for custom patterns.
*/
  public static function format(d : LocalDate, pattern : String, ?culture : Culture) : String
    return switch pattern {
      case "d": dateShort(d, culture);
      case "D": dateLong(d, culture);
      case "M",
           "m": monthDay(d, culture);
      case "O",
           "o": iso8601(d, culture);
      case "R",
           "r": rfc1123(d, culture);
      case "u": universalSortable(d, culture);
      case "y",
           "Y": yearMonth(d, culture);
      case pattern:
                customFormat(d, pattern, culture);
    };

// NOT SUPPORTED YET
// g, gg (period ERA, still not supported - requires calendar)
// Z (TZ abbreviation - requires time zones)
/**
Returns a formatted date according to the passed term and culture. The pattern
parameter accepts the following modifiers in either Microsoft format or strftime format.

format   | description                                                          | example
:------- | -------------------------------------------------------------------- | ------------:
ddd      | The abbreviated weekday name according to the current locale.        | Wed
dddd     | The full weekday name according to the current locale.               | Wednesday
MMM      | The abbreviated month name according to the current locale.          | Jan
MMMM     | The full month name according to the current locale.                 | January
dd       | The day of the month as a decimal number (range 01 to 31).           | 07
MMM      | Equivalent to %b.                                                    | Jan
MM       | The month as a decimal number (range 01 to 12).                      | 04
y        | The year as a decimal number without a century (range 00 to 99).     | 04
d        | The day of the month (1 to 31).                                      | 7
M        | Same as `m` but `0` padded (00 to 59).                               | 07
yy       | Year from 00 to 99.                                                  | 99
yyy      | Year with at least 3 digits.                                         | 1999
yyyy     | Four digits year.                                                    | 1999
yyyyy    | Five digits year.                                                    | 19999
:        | Time separator.                                                      | %
/        | Date separator.                                                      | /
'...'    | Single quoted text is not processed (except for removing the quotes) | ...
"..."    | Double quoted text is not processed (except for removing the quotes) | ...
%?       | Delegates to `strftime`                                              | %d
*/

  public static function formatTerm(d : LocalDate, pattern : String, ?culture : Culture) : String
    return switch pattern {
      case "d":       '${d.day}';
      case "dd":      '${d.day}'.lpad('0', 2);
      case "ddd":     var dt = dateTime(culture);
                      dt.nameDaysAbbreviated[d.dayOfWeek];
      case "dddd":    var dt = dateTime(culture);
                      dt.nameDays[d.dayOfWeek];
      case "M":       '${d.month}';
      case "MM":      '${d.month}'.lpad('0', 2);
      case "MMM":     var dt = dateTime(culture);
                      dt.nameMonthsAbbreviated[d.month-1];
      case "MMMM":    var dt = dateTime(culture);
                      dt.nameMonths[d.month-1];
      case "y":       '${d.year % 100}';
      case "yy":      (d.year % 100).lpad('0', 2);
      case "yyy":     d.year.lpad('0', 3);
      case "yyyy":    d.year.lpad('0', 4);
      case "yyyyy":   d.year.lpad('0', 5);
      case ":":       dateTime(culture).separatorTime;
      case ".":       culture.number.separatorDecimalNumber;
      case "/":       dateTime(culture).separatorDate;
      case q if(q.substring(0, 1) == "%"):
                      strftime(d, pattern, culture);
      case q if(q != null && q.length > 1 &&
        (q.substring(0, 1) == "'" && q.substring(q.length - 1) == "'") ||
        (q.substring(0, 1) == '"' && q.substring(q.length - 1) == '"')):
                      q.substring(1, q.length - 1);
      case rest:      rest;
    };

/**
Format a date using a `strftime` term.

strftime | description                                                        | example
:------: | -------------------------------------------------------------------| ------------:
%a       | The abbreviated weekday name according to the current locale.      | Wed
%A       | The full weekday name according to the current locale.             | Wednesday
%b       | The abbreviated month name according to the current locale.        | Jan
%B       | The full month name according to the current locale.               | January
%C       | The century number (year/100) as a 2-digit integer.                | 19
%d       | The day of the month as a decimal number (range 01 to 31).         | 07
%D       | Equivalent to %m/%d/%y. (This is the USA date format. In many countries %d/%m/%y is the standard date format. Thus, in an international context, both of these formats are ambiguous and should be avoided). | 06/25/04
%e       | Like %d, the day of the month as a decimal number, but a leading zero may be replaced by a leadingspace. | " 7"
%f       | The month. Single-digit months may be prefixed by leadingspace.*   | " 6"
%h       | Equivalent to %b.                                                  | Jan
%m       | The month as a decimal number (range 01 to 12).                    | 04
%n       | A newline character.                                               |
%s       | The number of seconds since the Epoch, i.e., since 1970-01-01 00:00:00 UTC. | 1099928130
%t       | A tab character.                                                   |
%u       | The day of the week as a decimal, range 1 to 7, Monday being 1. See also %w. |
%w       | The day of the week as a decimal, range 0 to 6, Sunday being 0. See also %u. |
%x       | The preferred date representation for the current locale without the time. |
%y       | The year as a decimal number without a century (range 00 to 99).   | 04
%Y       | The year as a decimal number including the century.                | 2004
%%       | A literal '%' character.                                           | %

*customs for missing features
*/
/*
%Z  Replaced by the timezone name or abbreviation (requires time-zones)
*/
  public static function strftime(d : LocalDate, pattern : String, ?culture : Culture) : String
    return switch pattern {
      case "%d":    formatTerm(d, "dd", culture);
      case "%a":    formatTerm(d, "ddd", culture);
      case "%A":    formatTerm(d, "dddd", culture);
      case "%m":    formatTerm(d, "MM", culture);
      case "%b",
           "%h":    formatTerm(d, "MMM", culture);
      case "%B":    formatTerm(d, "MMMM", culture);
      case "%S":    formatTerm(d, "ss", culture);
      case "%y":    formatTerm(d, "y", culture);
      case "%C":    '${Math.floor(d.year/100)}';
      case "%e":    '${d.day}'.lpad(' ', 2);
      case "%D":    format(d, "%m/%d/%y", culture);
      case "%f":    '${d.month}'.lpad(' ', 2);
      case "%n":    "\n";
      case "%s":    '${Std.int(d.toDateTimeUtc().toTime()/1000)}';
      case "%t":    "\t";
      case "%u":    var day = d.dayOfWeek;
                    day == 0 ? '7' : '$day';
      case "%Y":    '${d.year}';
      case "%x":    dateLong(d, culture);
      case "%w":    '${d.dayOfWeek}';
      case "%%":    "%";
      case rest:    rest;
    };

/**
Long Date/Time format.
*/
  public static function dateLong(d : LocalDate, ?culture : Culture)
    return customFormat(d, dateTime(culture).patternDateLong, culture);

/**
Short Date/Time format.
*/
  public static function dateShort(d : LocalDate, ?culture : Culture)
    return customFormat(d, dateTime(culture).patternDateShort, culture);

/**
Month/Day format.
*/
  public static function monthDay(d : LocalDate, ?culture : Culture)
    return customFormat(d, dateTime(culture).patternMonthDay, culture);

/**
Rfc1123 date/time format.
*/
  public static function rfc1123(d : LocalDate, ?culture : Culture)
    return DateFormat.customFormat(d.toDateTimeUtc().toDateTime(), dateTime(culture).patternRfc1123, culture);

/**
Format a date in way that it can be correctly ordered alphabetically.
*/
  public static function universalSortable(d : LocalDate, ?culture : Culture)
    return DateFormat.customFormat(d.toDateTimeUtc().toDateTime(), dateTime(culture).patternUniversalSortable, culture);

/**
Format a date in way that is compatible with the iso8601 specification.
*/
  public static function iso8601(d : LocalDate, ?culture : Culture)
    return customFormat(d, "yyyy'-'MM'-'dd", culture);

/**
Format for year and month.
*/
  public static function yearMonth(d : LocalDate, ?culture : Culture)
    return customFormat(d, dateTime(culture).patternYearMonth, culture);

// PRIVATE
  static function getDecimalsPadded(decimals : Int)
    return decimals.lpad("0", 7);

  static function getDecimalsString(decimals : Int)
    return getDecimalsPadded(decimals).trimCharsRight("0");

  static function getDecimalsUpTo(decimals : Int, to : Int)
    return getDecimalsString(decimals).substring(0, to);

  static function getDecimalsPaddedUpTo(decimals : Int, to : Int)
    return getDecimalsPadded(decimals).substring(0, to);

  static function dateTime(?culture : Culture)
    return null != culture && null != culture.dateTime ? culture.dateTime : Format.defaultCulture.dateTime;

  static inline function getPattern() return ~/(d|M){1,4}|(z){1,3}|(y){1,5}|K|[:]|[\/]|'[^']*'|"[^"]*"|[%][daAmbhByCeDfnstuYxw%]/;
}
