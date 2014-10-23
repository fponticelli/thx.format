package thx.format;

import thx.culture.Culture;
import thx.culture.NumberFormatInfo;
import thx.culture.Pattern;
using thx.core.Defaults;
using thx.core.Ints;
using thx.core.Strings;
using StringTools;

// TODO
//  - exponential
//  - decimal
//  - general
//  - octal
//  - customFormat
//  - printfTerm

class NumberFormat {
  public static function format(f : Float, pattern : String, ?culture : Culture) : String {
    var specifier = pattern.substring(0, 1),
        param     = pattern.substring(1);
    return switch specifier {
      case 'C', 'c': // currency
        currency(f, paramOrNull(param), culture);
      case 'D', 'd': // decimal
        decimal(f, paramOrNull(param), culture);
      case 'E': // exponential E
        exponential(f, paramOrNull(param), culture);
      case 'e': // exponential e
        exponential(f, paramOrNull(param), culture).toLowerCase();
      case 'F', 'f': // fixed point
        fixed(f, paramOrNull(param), culture);
      case 'G':
        general(f, paramOrNull(param), culture);
      case 'g': // general
        general(f, paramOrNull(param), culture).toLowerCase();
      case 'N', 'n': // number
        number(f, paramOrNull(param), culture);
      case 'P', 'p': // percent
        percent(f, paramOrNull(param), culture);
      case 'R', 'r': // round trip
        '$f';
      case 'X': // hexadecimal X
        StringTools.hex(Std.int(f), paramOrNull(param));
      case 'x': // hexadecimal x
        StringTools.hex(Std.int(f), paramOrNull(param)).toLowerCase();
      case "%":
        printfTerm(f, pattern, culture);
      case _:   // custom format
        customFormat(f, pattern, culture);
    };
  }

  public static function printfTerm(f : Float, pattern : String, ?culture) : String {
/*
%[flags][width][.precision][length]specifier

specifier Output
c Character.
d or i  Signed decimal integer
e Scientific notation (mantissa/exponent) using e character
E Scientific notation (mantissa/exponent) using E character
f Decimal floating point
g Use the shorter of %e or %f.
G Use the shorter of %E or %f
o Signed octal
s String of characters
u Unsigned decimal integer
x Unsigned hexadecimal integer
X Unsigned hexadecimal integer (capital letters)
p Pointer address
n Nothing printed.
% Character.

   %X    like %x, but using upper-case letters
   %E    like %e, but using an upper-case "E"
   %G    like %g, but with an upper-case "E" (if applicable)
   %b    an unsigned integer, in binary
   %B    like %b, but using an upper-case "B" with the # flag
   %p    a pointer (outputs the Perl value's address in hexadecimal)
   %n    special: *stores* the number of characters output so far
         into the next argument in the parameter list

http://perldoc.perl.org/functions/sprintf.html

flags Description
- Left-justify within the given field width; Right justification is the default (see width sub-specifier).
+ Forces to preceed the result with a plus or minus sign (+ or -) even for positive numbers. By default, only negative numbers are preceded with a - sign..
(space) If no sign is going to be written, a blank space is inserted before the value.
# Used with o, x or X specifiers the value is preceeded with 0, 0x or 0X respectively for values different than zero. Used with e, E and f, it forces the written output to contain a decimal point even if no digits would follow. By default, if no digits follow, no decimal point is written. Used with g or G the result is the same as with e or E but trailing zeros are not removed.
0 Left-pads the number with zeroes (0) instead of spaces, where padding is specified (see width sub-specifier).
width Description
(number)  Minimum number of characters to be printed. If the value to be printed is shorter than this number, the result is padded with blank spaces. The value is not truncated even if the result is larger.
* The width is not specified in the format string, but as an additional integer value argument preceding the argument that has to be formatted.
.precision  Description
.number For integer specifiers (d, i, o, u, x, X): precision specifies the minimum number of digits to be written. If the value to be written is shorter than this number, the result is padded with leading zeros. The value is not truncated even if the result is longer. A precision of 0 means that no character is written for the value 0. For e, E and f specifiers: this is the number of digits to be printed after de decimal point. For g and G specifiers: This is the maximum number of significant digits to be printed. For s: this is the maximum number of characters to be printed. By default all characters are printed until the ending null character is encountered. For c type: it has no effect. When no precision is specified, the default is 1. If the period is specified without an explicit value for precision, 0 is assumed.
.*  The precision is not specified in the format string, but as an additional integer value argument preceding the argument that has to be formatted.
length  Description
h The argument is interpreted as a short int or unsigned short int (only applies to integer specifiers: i, d, o, u, x and X).
l The argument is interpreted as a long int or unsigned long int for integer specifiers (i, d, o, u, x and X), and as a wide character or wide character string for specifiers c and s.
L The argument is interpreted as a long double (only applies to floating point specifiers: e, E, f, g and G).

*/
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
    var nf = numberFormat(culture);
    return null;
  }

  public static function exponential(f : Float, ?decimals : Int = 6, ?culture : Culture) : String {
    var nf = numberFormat(culture);
    return null;
  }

  public static function general(f : Float, ?significantDigits : Null<Int>, ?culture : Culture) : String {
    // shorter between fixed and exponential ensuring significantDifits
    var nf = numberFormat(culture);
    return null;
  }

  public static function number(f : Float, ?decimals : Null<Int>, ?culture : Culture) : String {
    var nf        = numberFormat(culture),
        pattern   = f < 0 ? Pattern.numberNegatives[nf.patternNegativeNumber] : 'n',
        formatted = value(f, (decimals).or(nf.decimalDigitsNumber), nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, nf.groupSizesNumber, nf.separatorGroupNumber, nf.separatorDecimalNumber);
    return pattern.replace('n', formatted);
  }

  public static function octal(f : Float, ?significantDigits : Int = 1, ?culture : Culture) : String {
    var nf = numberFormat(culture);
    return null;
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