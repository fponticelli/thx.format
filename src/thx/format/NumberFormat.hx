package thx.format;

import thx.culture.Culture;
import thx.culture.NumberFormatInfo;
import thx.culture.Pattern;
using thx.core.Nulls;
using thx.core.Ints;
using thx.core.Strings;
using StringTools;

// TODO
//  - customFormat
//  - printfTerm
//  - move here culture specific Ints.toString (and parse?)
//  - use UTF8 for substring
// http://msdn.microsoft.com/en-us/library/dwhawy9k(v=vs.110).aspx
// http://msdn.microsoft.com/en-us/library/0c899ak8(v=vs.110).aspx
// in string format add %s where precision is the maximum number of characters to be printed.
class NumberFormat {
  public static function format(f : Float, pattern : String, ?culture : Culture) : String {
    var specifier = pattern.substring(0, 1),
        param     = paramOrNull(pattern.substring(1));
    return switch specifier {
    // currency
      case 'C', 'c': currency(f, param, culture);
      // decimal
      case 'D', 'd': decimal(f, param, culture);
      // exponential E
      case 'E':      exponential(f, param, culture);
      // exponential e
      case 'e':      exponential(f, param, culture).toLowerCase();
      // fixed point
      case 'F', 'f': fixed(f, param, culture);
      // general
      case 'G':      general(f, param, culture);
      // general lower case
      case 'g':      general(f, param, culture).toLowerCase();
      // number
      case 'N', 'n': number(f, param, culture);
      // percent
      case 'P', 'p': percent(f, param, culture);
      // round trip
      case 'R', 'r': '$f';
      // hexadecimal X
      case 'X':      hex(f, param, culture).toUpperCase();
      // hexadecimal x
      case 'x':      hex(f, param, culture);
      // printf
      case "%":      printfTerm(f, pattern, culture);
      // custom format
      case _:        customFormat(f, pattern, culture);
    };
  }

/**
Formats a single number in a `String` using the `printf` conventions.

The `printf` format uses the following pattern:

```
%[flags][width][.precision]specifier
```

specifier | Output
--------- | ---------------------------------------------------------
b         | an unsigned integer, in binary
B         | like %b, but using an upper-case "B" with the # flag
c         | Character.
d         | Signed decimal integer
e         | Scientific notation (mantissa/exponent) using e character
E         | Like %e, but using an upper-case "E"
f         | Decimal floating point
g         | Use the shorter of %e or %f.
G         | Like %g, but with an upper-case "E" (if applicable)
i         | Same as `d`
o         | Signed octal
u         | Unsigned decimal integer
x         | Unsigned hexadecimal integer
X         | Like %x, but using upper-case letters
n         | Nothing printed.
%         | `%` Character

http://perldoc.perl.org/functions/sprintf.html

flags       | Description
----------- | ------------------------------------------------------------------------------------------------------
-           | Left-justify within the given field width; Right justification is the default (see width sub-specifier).
+           | Forces to preceed the result with a plus or minus sign (+ or -) even for positive numbers. By default, only negative numbers are preceded with a - sign..
(space)     | If no sign is going to be written, a blank space is inserted before the value.
#           | Used with o, x or X specifiers the value is preceeded with 0, 0x or 0X respectively for values different than zero. Used with e, E and f, it forces the written output to contain a decimal point even if no digits would follow. By default, if no digits follow, no decimal point is written. Used with g or G the result is the same as with e or E but trailing zeros are not removed. If b or B prefixes the output with either.
0           | Left-pads the number with zeroes (0) instead of spaces, where padding is specified (see width sub-specifier).

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
  public static function printfTerm(f : Float, pattern : String, ?culture) : String {
    if(!pattern.startsWith('%'))
      throw 'invalid printf term "$pattern"';
    var nf = numberFormat(culture),
        specifier = pattern.substring(-1);
    pattern = pattern.substring(0, pattern.length - 1);
    var p = pattern.split('.'),
        precision : Null<Int> = null == p[1] || "" == p[1] ? null : Std.parseInt(p[1]);
/*
      switch param {
          case "%": // a percent sign

          case "c": // a character with the given number
            String.fromCharCode(Std.int(f));
          case "s": // a string

          case "d": // a signed integer, in decimal
            decimal(f, culture);
          case "u": // an unsigned integer, in decimal
            decimal(Math.abs(f), culture);
          case "o": // an unsigned integer, in octal
            octal(f, culture);
          case "x": // an unsigned integer, in hexadecimal
            format(f, 'x', culture);
          case "e": // a floating-point number, in scientific notation
            format(f, 'e', culture);
          case "f": // a floating-point number, in fixed decimal notation
            format(f, 'f', culture);
          case "g": // a floating-point number, in %e or %f notation
            format(f, 'g', culture);
          case _:

        }
*/
    return null;
  }

  public static function customFormat(f : Float, pattern : String, ?culture : Culture) : String {
    trace('custom pattern $pattern');
    var nf = numberFormat(culture);
    return null;
  }

  static function paramOrNull(param : String) : Null<Int>
    return param.length == 0 ? null : Std.parseInt(param);

  public static function currency(f : Float, ?decimals : Null<Int>, ?symbol : String, ?culture : Culture) : String {
    var nf        = numberFormat(culture),
        pattern   = f < 0 ? Pattern.currencyNegatives[nf.patternNegativeCurrency] : Pattern.currencyPositives[nf.patternPositiveCurrency],
        formatted = value(f, (decimals).or(nf.decimalDigitsCurrency), nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, nf.groupSizesCurrency, nf.separatorGroupCurrency, nf.separatorDecimalCurrency);
    return pattern.replace('n', formatted).replace('$', (symbol).or(nf.symbolCurrency));
  }

  public static function decimal(f : Float, ?significantDigits : Int = 1, ?culture : Culture) : String {
    var nf = numberFormat(culture),
        formatted = value(f, 0, nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, [0], '', '');
    return (f < 0 ? nf.signNegative : '') + formatted.lpad('0', significantDigits);
  }

  public static function exponential(f : Float, ?decimals : Int = 6, ?digits : Int = 3, ?symbol : String = 'e', ?culture : Culture) : String {
    var nf = numberFormat(culture),
        s  = '${Math.abs(f)}'.toLowerCase(),
        pose = s.indexOf('e');
    if(pose > 0) {
      var p = s.substring(0, pose).split('.'),
          e = Ints.parse(s.substring(pose+1));
      return (f < 0 ? nf.signNegative : '') +
        p[0] +
        nf.separatorDecimalNumber +
        p[1].substring(0, decimals).rpad('0', decimals) +
        symbol +
        (e < 0 ? nf.signNegative : nf.signPositive) +
        '${Ints.abs(e)}'.lpad('0', digits);
    } else {
      var p = s.split('.').concat(['']),
          e = 0;
      if(p[0].length > 1) {
        e = p[0].length - 1;
        p[1] = p[0].substring(1) + p[1];
        p[0] = p[0].substring(0, 1);
      } else if(p[0] == '0') {
        e = -(1 + p[1].length - p[1].trimLeft('0').length);
        p[1] = p[1].substring(-e-1);
        p[0] = p[1].substring(0, 1);
        p[1] = p[1].substring(1);
      }

      return (f < 0 ? nf.signNegative : '') +
        p[0] +
        nf.separatorDecimalNumber +
        p[1].substring(0, decimals).rpad('0', decimals) +
        symbol +
        (e < 0 ? nf.signNegative : nf.signPositive) +
        '${Ints.abs(e)}'.lpad('0', digits);
    }
    return s;
  }

  public static function general(f : Float, ?significantDigits : Null<Int>, ?culture : Culture) : String {
    // shorter between fixed and exponential ensuring significantDifits
    var e = exponential(f, significantDigits, culture),
        f = fixed(f, significantDigits, culture);
    return e.length < f.length ? e : f;
  }

  public static function number(f : Float, ?decimals : Null<Int>, ?culture : Culture) : String {
    var nf        = numberFormat(culture),
        pattern   = f < 0 ? Pattern.numberNegatives[nf.patternNegativeNumber] : 'n',
        formatted = value(f, (decimals).or(nf.decimalDigitsNumber), nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, nf.groupSizesNumber, nf.separatorGroupNumber, nf.separatorDecimalNumber);
    return pattern.replace('n', formatted);
  }

  public static function binary(f : Float, ?significantDigits : Int = 1, ?culture : Culture) : String {
    var nf = numberFormat(culture);
    return Ints.toString(Std.int(f), 2, nf.signNegative).lpad('0', significantDigits);
  }

  public static function hex(f : Float, ?significantDigits : Int = 1, ?culture : Culture) : String {
    var nf = numberFormat(culture);
    return Ints.toString(Std.int(f), 16, nf.signNegative).lpad('0', significantDigits);
  }

  public static function octal(f : Float, ?significantDigits : Int = 1, ?culture : Culture) : String {
    var nf = numberFormat(culture);
    return Ints.toString(Std.int(f), 8, nf.signNegative).lpad('0', significantDigits);
  }

  public static function fixed(f : Float, ?decimals : Null<Int>, ?culture : Culture) : String {
    var nf        = numberFormat(culture),
        pattern   = f < 0 ? Pattern.numberNegatives[nf.patternNegativeNumber] : 'n',
        formatted = value(f, (decimals).or(nf.decimalDigitsNumber), nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, [0], '', nf.separatorDecimalNumber);
    return pattern.replace('n', formatted);
  }

  public static function integer(f : Float, ?culture : Culture) : String
    return number(f, 0, culture);

  public static function percent(f : Float, ?decimals : Null<Int>, ?culture : Culture) : String {
    var nf = numberFormat(culture);
    return unit(f * 100, (decimals).or(nf.decimalDigitsPercent), nf.symbolPercent, culture);
  }

  public static function permille(f : Float, ?decimals : Null<Int>, ?culture : Culture) : String {
    var nf = numberFormat(culture);
    return unit(f * 1000, (decimals).or(nf.decimalDigitsPercent), nf.symbolPermille, culture);
  }

  public static function unit(f : Float, decimals : Int, symbol : String, ?culture : Culture) : String {
    var nf        = numberFormat(culture),
        pattern   = f < 0 ? Pattern.percentNegatives[nf.patternNegativePercent] : Pattern.percentPositives[nf.patternPositivePercent],
        formatted = value(f, decimals, nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, nf.groupSizesPercent, nf.separatorGroupPercent, nf.separatorDecimalPercent);
    return pattern.replace('n', formatted).replace('%', symbol);
  }

  public static function value(f : Float, decimals : Int, symbolNaN : String, symbolNegativeInfinity : String, symbolPositiveInfinity : String, groupSizes : Array<Int>, groupSeparator : String, decimalSeparator : String) : String {
    if(Math.isNaN(f))
      return symbolNaN;
    if(!Math.isFinite(f))
      return f < 0 ? symbolNegativeInfinity : symbolPositiveInfinity;

    f = Math.abs(f);
    var s = '$f',
        p = s.split('.'),
        i = p[0],
        d = p[1],
        buf = [];

    if((d = (d).or('').toLowerCase()).indexOf('e') > 0) {
      p = d.split('e');
      d = p[0];
      var e = Ints.parse(p[1]);
      if(e < 0) {
        d = ''.rpad('0', -e-1) + i + d;
        i = '0';
      } else {
        i = pad(i + d, e + 1);
        d = '';
      }
    }

    buf.push(intPart(i, groupSizes, groupSeparator));

    if(decimals > 0)
      buf.push(pad(d, decimals));

    return buf.join(decimalSeparator);
  }

  static function pad(s : String, len : Int) : String
    return (s).or('').substr(0, len).rpad('0', len);

  static function intPart(s : String, groupSizes : Array<Int>, groupSeparator : String) : String {
    var buf = [],
        pos = 0,
        len = groupSizes.length,
        size,
        seg;
    while(s.length > 0) {
      size = groupSizes[pos++ % len];
      if(size == 0) {
        buf.unshift(s);
        s = '';
      } else {
        seg = s.length > size ? s.substr(s.length - size) : s;
        buf.unshift(seg);
        s = s.substr(0, s.length - seg.length);
      }
    }
    return buf.join(groupSeparator);
  }

  static function numberFormat(culture : Culture) : NumberFormatInfo
    return null != culture && null != culture.number ? culture.number : Culture.invariant.number;
}