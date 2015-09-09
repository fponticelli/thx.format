package thx.format;

import thx.culture.Culture;
import thx.culture.NumberFormatInfo;
import thx.culture.Pattern;
using thx.Arrays;
using thx.Floats;
using thx.Functions;
using thx.Nulls;
using thx.Ints;
using thx.Strings;
using StringTools;

class BigIntFormat {
/**
Binary format. The result is prefixed with leading `0` up to `significantDigits`. Default is one.
**/
  public static function binary(i : BigInt, ?significantDigits : Int = 1) : String
    return significantDigits == 0 && i.isZero() ? "" : i.toStringWithBase(2).lpad('0', significantDigits);

/**
Formats a currency value. By default the currency symbol is extracted from the applied culture but it can be optionally
provided using setting the `symbol` argument.
**/
  public static function currency(i : BigInt, ?precision : Null<Int>, ?symbol : String, ?culture : Culture) : String
    return DecimalFormat.currency(Decimal.fromBigInt(i), precision, symbol, culture);

/**
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
*/
  public static function customFormat(i : BigInt, pattern : String, ?culture : Culture) : String
    return DecimalFormat.customFormat(Decimal.fromBigInt(i), pattern, culture);

/**
Formats a decimal (integer) value.
**/
  public static function decimal(i : BigInt, ?significantDigits : Int = 1, ?culture : Culture) : String
    return DecimalFormat.decimal(Decimal.fromBigInt(i), significantDigits, culture);

/**
Formats a number using the exponential (scientific) format.
**/
  public static function exponential(i : BigInt, ?precision : Int = 6, ?digits : Int = 3, ?symbol : String = 'e', ?culture : Culture) : String
    return DecimalFormat.exponential(Decimal.fromBigInt(i), precision, digits, symbol, culture);

/**
Formats a fixed point float number with an assigned precision.
**/
  public static function fixed(i : BigInt, ?precision : Null<Int>, ?culture : Culture) : String
    return DecimalFormat.fixed(Decimal.fromBigInt(i), precision, culture);

/**
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
**/
  public static function format(i : BigInt, pattern : String, ?culture : Culture) : String
    return DecimalFormat.format(Decimal.fromBigInt(i), pattern, culture);

/**
Formats a number using either the shortest result between `fixed` and `exponential`.
**/
  public static function general(i : BigInt, ?significantDigits : Null<Int>, ?culture : Culture) : String
    return DecimalFormat.general(Decimal.fromBigInt(i), significantDigits, culture);

/**
Formats a number to hexadecimal format.
**/
  public static function hex(i : BigInt, ?significantDigits : Int = 1, ?culture : Culture) : String {
    var nf = numberFormat(culture);
    return significantDigits == 0 && i.isZero() ? "" : toBase(i, 16, culture).lpad('0', significantDigits);
  }

/**
Formats the integer part of a number.
**/
  public static function integer(i : BigInt, ?culture : Culture) : String {
    return number(i, 0, culture);
  }

/**
Formats a number with group separators (eg: thousands separators).
**/
  public static function number(i : BigInt, ?precision : Null<Int>, ?culture : Culture) : String
    return DecimalFormat.number(Decimal.fromBigInt(i), precision, culture);

/**
Formats a number to octals.
**/
  public static function octal(i : BigInt, ?significantDigits : Int = 1, ?culture : Culture) : String
    return significantDigits == 0 && i.isZero() ? "" : toBase(i, 8, culture).lpad('0', significantDigits);

/**
Formats a number as a percent value. The output result is multiplied by 100. So `0.1` will result in `10%`.
**/
  public static function percent(i : BigInt, ?decimals : Null<Int>, ?culture : Culture) : String
    return DecimalFormat.percent(Decimal.fromBigInt(i), decimals, culture);

/**
Formats a number as a percent value. The output result is multiplied by 1000. So `0.1` will result in `100‰`.
**/
  public static function permille(i : BigInt, ?decimals : Null<Int>, ?culture : Culture) : String
    return DecimalFormat.permille(Decimal.fromBigInt(i), decimals, culture);

/**
Formats a single number in a `String` using the `printf` conventions.

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
**/
  public static function printf(i : BigInt, pattern : String, ?culture) : String
    return DecimalFormat.printf(Decimal.fromBigInt(i), pattern, culture);

/**
Transform an `Int` value to a `String` using the specified `base`. A negative sign can be provided optionally.
**/
  public static function toBase(value : BigInt, base : Int, ?culture : Culture) : String {
    var s = value.toStringWithBase(base);
    if(!value.isNegative())
      return s;
    return numberFormat(culture).signNegative + s.substring(1);
  }

/**
Formats a number with a specified `unitSymbol` and a specified number of decimals.
**/
  public static function unit(i : BigInt, decimals : Int, unitSymbol : String, ?culture : Culture) : String
    return DecimalFormat.unit(Decimal.fromBigInt(i), decimals, unitSymbol, culture);

// PRIVATE
// TODO duplicate, remove
  static function numberFormat(culture : Culture) : NumberFormatInfo
    return null != culture && null != culture.number ? culture.number : Format.defaultCulture.number;
}
