# thx.format

[![Build Status](https://travis-ci.org/fponticelli/thx.format.svg)](https://travis-ci.org/fponticelli/thx.format)

Format library for Haxe.

## Usage

`thx.format` adds formatting options on top of common Haxe types. To use  require (`using` or `import`) the right formatter (ex: `thx.format.DateFormat` or `thx.format.DateFormat`).

```haxe
var it = Embed.culture('it-it');
var ch = Embed.culture('it-ch');
var us = Embed.culture('en-us');
var ru = Embed.culture('ru-ru');
var fr = Embed.culture('fr-fr');
var jp = Embed.culture('ja-jp');
var d  = Date.fromString('2009-06-01 13:45:30');

// dates
d.format('U');     // Monday, 01 June 2009 13:45:30
d.format('U', it); // lunedì 1 Giugno 2009 13:45:30
d.format('U', ch); // lunedì, 1. Giugno 2009 13:45:30
d.format('U', us); // Monday, June 1, 2009 1:45:30 PM
d.format('U', ru); // 1 Июнь 2009 г. 13:45:30
d.format('U', fr); // lundi 1 juin 2009 13:45:30
d.format('U', jp); // 2009年6月1日 13:45:30
```

And numbers:

```haxe
(-12345.6789).currency();   // (¤12,345.67)
(-12345.6789).currency(it); // -€ 12.345,67
(-12345.6789).currency(us); // ($12,345.67)
12345.6789.integer();       // 12,345
0.02333.percent();          // 2.33 %
0.02333.percent(it);        // 2,33%
0.02333.permille();         // 23.33 ‰
0.02333.permille(it);       // 23,33‰
23.3333.unit(2, 'kg.');     // 23.33 kg.
23.3333.unit(2, 'kg.', it); // 23,33kg.
```

## Date Formats

### One Letter Format (`Date.format`)

pattern   | description
--------- | ------------------------------------
`d`       | short date pattern
`D`       | long date pattern
`f`       | long date + short time pattern
`F`       | long date + long time pattern
`g`       | short date + short time pattern
`G`       | short date + long time pattern
`M`, `m`  | month/day pattern
`R`, `r`  | RFC1123 pattern
`s`       | sortable date/time pattern
`t`       | short time pattern
`T`       | long time pattern
`u`       | universal sortable date/time pattern
`U`       | universal full date/time pattern
`Y`, `y`  | year/month pattern
...       | custom pattern.

### Custom Patterns (`Date.customFormat` or `Date.strftime`)

MS      | strftime   | description                                                                  | example
:------ | :--------: | ---------------------------------------------------------------------------- | ------------:
`ddd`   | `%a`       | The abbreviated weekday name according to the current locale.                | Wed
`dddd`  | `%A`       | The full weekday name according to the current locale.                       | Wednesday
`MMM`   | `%b`       | The abbreviated month name according to the current locale.                  | Jan
`MMMM`  | `%B`       | The full month name according to the current locale.                         | January
        | `%c`       | The preferred date and time representation for the current locale.           |
        | `%C`       | The century number (year/100) as a 2-digit integer.                          | 19
`dd`    | `%d`       | The day of the month as a decimal number (range 01 to 31).                   | 07
        | `%D`       | Equivalent to %m/%d/%y. (This is the USA date format. In many countries %d/%m/%y is the standard date format. Thus, in an international context, both of these formats are ambiguous and should be avoided). | 06/25/04
        | `%e`       | Like %d, the day of the month as a decimal number, but a leading zero may be replaced by a leadingspace. | " 7"
        | `%f`       | The month. Single-digit months may be prefixed by leadingspace.*             | " 6"
`MMM`   | `%h`       | Equivalent to %b.                                                            | Jan
`HH`    | `%H`       | The hour as a decimal number using a 24-hour clock (range 00 to 23).         | 22
        | `%i`       | The minute. Single-digit minutes may be prefixed by leadingspace.*           | " 8"
`hh`    | `%I`       | The hour as a decimal number using a 12-hour clock (range 01 to 12).         | 07
        | `%k`       | The hour (24-hour clock) as a decimal number (range 0 to 23); single-digits are optionally prefixed by leadingspace. (See also %H). | 7
        | `%l`       | The hour (12-hour clock) as a decimal number (range 1 to 12); single-digits are optionally prefixed by leadingspace. (See also %I). | 7
`MM`    | `%m`       | The month as a decimal number (range 01 to 12).                              | 04
`mm`    | `%M`       | The minute as a decimal number (range 00 to 59).                             | 08
        | `%n`       | A newline character.                                                         |
`tt`    | `%p`       | Either 'AM' or 'PM' according to the given time value, or the corresponding strings for the current locale. Noon is treated as 'pm' and midnight as 'am'. | AM
        | `%P`       | Like %p but in lowercase: 'am' or 'pm' or a corresponding string for the current locale. | AM
        | `%q`       | The second. Single-digit seconds may be prefixed by leadingspace.*           | " 9"
        | `%r`       | The time in a.m. or p.m. notation. In the POSIX locale this is equivalent to '%I:%M:%S %p'. | 07:08:09 am
        | `%R`       | The time in 24-hour notation (%H:%M). For a version including the seconds, see %T below. | 07:08
        | `%s`       | The number of seconds since the Epoch, i.e., since 1970-01-01 00:00:00 UTC.  | 1099928130
`ss`    | `%S`       | The second as a decimal number (range 00 to 61). the upper level of the range 61 rather than 59 to allow for the occasional leap second and even more occasional double leap second. | 07
        | `%t`       | A tab character.                                                             |
        | `%T`       | The time in 24-hour notation (%H:%M:%S).                                     | 17:08:09
        | `%u`       | The day of the week as a decimal, range 1 to 7, Monday being 1. See also %w. |
        | `%w`       | The day of the week as a decimal, range 0 to 6, Sunday being 0. See also %u. |
        | `%x`       | The preferred date representation for the current locale without the time.   |
        | `%X`       | The preferred time representation for the current locale without the date.   |
`y`     | `%y`       | The year as a decimal number without a century (range 00 to 99).             | 04
        | `%Y`       | The year as a decimal number including the century.                          | 2004
        | `%%`       | A literal '%' character.                                                     | %
`d`     |            | The day of the month (1 to 31).                                              | 7
`h`     |            | The hour on a 12-hour clock (1 to 12).                                       | 11
`H`     |            | Same as `h` but `0` padded (01 to 12).                                       | 07
`m`     |            | Minute (0 to 59).                                                            | 7
`M`     |            | Same as `m` but `0` padded (00 to 59).                                       | 07
`s`     |            | Seconds (0 to 59).                                                           | 7
`t`     |            | Same as `s` but `0` padded (00 to 59).                                       | 07
`yy`    |            | Year from 00 to 99.                                                          | 99
`yyy`   |            | Year with at least 3 digits.                                                 | 1999
`yyyy`  |            | Four digits year.                                                            | 1999
`:`     |            | Time separator.                                                              | %
`/`     |            | Date separator.                                                              | /
`'...'` |            | Single quoted text is not processed (except for removing the quotes)         | ...
`"..."` |            | Double quoted text is not processed (except for removing the quotes)         | ...

*customs for missing features

## Number Formats

### One Letter Format (`NumberFormat.format`)

Formats a number using the specified pattern.

A `printf` format is formatted using the rules described for `NumberFormat.printf`.

A multi character format uses the formatting rules described for `NumberFormat.customFormat`.

A single character format adopts the following options:

format     | description
---------- | ---------------------------------------
`C` or `c` | Currency format.
`D` or `d` | Decimal format.
`e`        | Exponential (scientific) format.
`E`        | Like `e` but with capitalized `E` symbol
`F` or `f` | Fixed decimal format (no thousand separators).
`g`        | General format (shortest between `e` and `f`).
`G`        | Like `g` but if format is exponential uses the upper case `E` symbol
`N` or `n` | Number format (uses thousand separators if required).
`P` or `p` | Percent format.
`R` or `r` | Roundtrip format.
`x`        | Hexadecimal format.
`X`        | Same as `x` but prefixed with `0X`.
`%`...     | Delegates to `printf`
...        | Delegates to `customFormat`

### Printf Formats (`NumberFormat.printf`)

The `printf` format uses the following pattern:

```
%[flags][width][.precision]specifier
```

specifier   | Output
----------- | ---------------------------------------------------------
`b`         | an unsigned integer, in binary
`B`         | like %b, but using an upper-case "B" with the # flag
`c`         | Character.
`d`         | Signed decimal integer
`e`         | Scientific notation (mantissa/exponent) using e character
`E`         | Like %e, but using an upper-case "E"
`f`         | Decimal floating point
`g`         | Use the shorter of %e or %f.
`G`         | Like %g, but with an upper-case "E" (if applicable)
`i`         | Same as `d`
`o`         | Signed octal
`u`         | Unsigned decimal integer
`x`         | Unsigned hexadecimal integer
`X`         | Like %x, but using upper-case letters
`%`         | `%` Character

http://perldoc.perl.org/functions/sprintf.html

flags         | Description
------------- | ------------------------------------------------------------------------------------------------------
`-`           | Left-justify within the given field width; Right justification is the default (see width sub-specifier).
`+`           | Forces to preceed the result with a plus or minus sign (+ or -) even for positive numbers. By default, only negative numbers are preceded with a - sign..
` ` (space)   | If no sign is going to be written, a blank space is inserted before the value.
`#`           | Used with o, x or X specifiers the value is preceeded with 0, 0x or 0X respectively for values different than zero. If b or B prefixes the output with either.
`0`           | Left-pads the number with zeroes (0) instead of spaces, where padding is specified (see width sub-specifier).

width       | Description
----------- | ------------------------------------------------------------------------------------------------------
(number)    | Minimum number of characters to be printed. If the value to be printed is shorter than this number, the result is padded with blank spaces. The value is not truncated even if the result is larger.

.precision  | Description
----------- | ------------------------------------------------------------------------------------------------------
.number     | For integer specifiers (d, i, o, u, x, X): precision specifies the minimum number of digits to be written. If the value to be written is shorter than this number, the result is padded with leading zeros. The value is not truncated even if the result is longer. A precision of 0 means that no character is written for the value 0. For e, E and f specifiers: this is the number of digits to be printed after de decimal point. For g and G specifiers: This is the maximum number of significant digits to be printed. By default all characters are printed until the ending null character is encountered. For c type: it has no effect. When no precision is specified, the default is 1. If the period is specified without an explicit value for precision, 0 is assumed.

Differences with classic printf:

  * `length` parameter is not supported to set the type of the integer argument (eg. short or unsigned)
  * `*` width is not supported
  * `.*` precision is not supported
  * `%p` pointer address is not supported
  * `%n` is not supported
  * `%s` is not supported since this function is to format numeric values only

### Custom Formats (`NumberFormat.customFormat`)

Custom format uses a pattern composed of the format options described below.

format    | description
--------- | ------------------------
`0`       | Zero placeholder is replaced with a corresponding digits if present, otherwise a `0` is printed.
`#`       | Digit placeholder is replaced with a corresponding digits if present or nothing.
`.`       | Localized decimal separator.
`,`       | Localized group separator. If added to the end of the pattern it multiplies the number by 1000 for every comma.
`%`       | Includes the percentage symbol and multiplies the number by 100.
`‰`       | Includes the permille symbol and multiplies the number by 1000.
`E0`, `E+0`, `E-0`, `e0`, `e+0`, `e-0` | Exponential notation.
`\`       | Escapes the following character.
`'...'`, `"..."` | Escape an entire sequence of characters.
`;`       | Section separator. There are three possible sections (positive, negative, zero). If two are specified zero numbers use the format from the first section.
`...`     | Anything else is left untouched and put in the output as it is.

## Install

```bash
haxelib install thx.format
```