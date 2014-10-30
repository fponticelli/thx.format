package thx.format;

import thx.culture.Culture;
import thx.culture.NumberFormatInfo;
import thx.culture.Pattern;
using thx.core.Floats;
using thx.core.Nulls;
using thx.core.Ints;
using thx.core.Strings;
using StringTools;

// TODO
//  - customFormat
// http://msdn.microsoft.com/en-us/library/0c899ak8(v=vs.110).aspx
// in string format add %s where precision is the maximum number of characters to be printed.
class NumberFormat {
/**
Binary format. The result is prefixed with leading `0` up to `significantDigits`. Default is one.
**/
  public static function binary(f : Float, ?significantDigits : Int = 1, ?culture : Culture) : String
    return significantDigits == 0 && f == 0 ? "" : toBase(Std.int(f), 2, culture).lpad('0', significantDigits);

/**
Formats a currency value. By default the currency symbol is extracted from the applied culture but it can be optionally
provided using setting the `symbol` argument.
**/
  public static function currency(f : Float, ?precision : Null<Int>, ?symbol : String, ?culture : Culture) : String {
    var nf        = numberFormat(culture),
        pattern   = f < 0 ? Pattern.currencyNegatives[nf.patternNegativeCurrency] : Pattern.currencyPositives[nf.patternPositiveCurrency],
        formatted = value(f, (precision).or(nf.decimalDigitsCurrency), nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, nf.groupSizesCurrency, nf.separatorGroupCurrency, nf.separatorDecimalCurrency);
    return pattern.replace('n', formatted).replace('$', (symbol).or(nf.symbolCurrency));
  }

  public static function customFormat(f : Float, pattern : String, ?culture : Culture) : String {
    trace('custom pattern $pattern');
    var nf = numberFormat(culture);
    return null;
  }

/**
Formats a decimal (integer) value.
**/
  public static function decimal(f : Float, ?significantDigits : Int = 1, ?culture : Culture) : String {
    var nf = numberFormat(culture),
        formatted = value(f, 0, nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, [0], '', '');
    return (f < 0 ? nf.signNegative : '') + formatted.lpad('0', significantDigits);
  }

/**
Formats a number using the exponential (scientific) format.
**/
  public static function exponential(f : Float, ?precision : Int = 6, ?digits : Int = 3, ?symbol : String = 'e', ?culture : Culture) : String {
    var nf = numberFormat(culture),
        s  = '${Math.abs(f)}'.toLowerCase(),
        pose = s.indexOf('e');
    if(pose > 0) {
      var p = s.substring(0, pose).split('.'),
          e = Ints.parse(s.substring(pose+1));
      return (f < 0 ? nf.signNegative : '') +
        p[0] +
        nf.separatorDecimalNumber +
        p[1].substring(0, precision).rpad('0', precision) +
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
        p[1].substring(0, precision).rpad('0', precision) +
        symbol +
        (e < 0 ? nf.signNegative : nf.signPositive) +
        '${Ints.abs(e)}'.lpad('0', digits);
    }
    return s;
  }

/**
Formats a fixed point float number with an assigned precision.
**/
  public static function fixed(f : Float, ?precision : Null<Int>, ?culture : Culture) : String {
    var nf        = numberFormat(culture),
        pattern   = f < 0 ? Pattern.numberNegatives[nf.patternNegativeNumber] : 'n',
        formatted = value(f, (precision).or(nf.decimalDigitsNumber), nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, [0], '', nf.separatorDecimalNumber);
    return pattern.replace('n', formatted);
  }

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
      case "%":      printf(f, pattern, culture);
      // custom format
      case _:        customFormat(f, pattern, culture);
    };
  }

/**
Formats a number using either the shortest result between `fixed` and `exponential`.
**/
  public static function general(f : Float, ?significantDigits : Null<Int>, ?culture : Culture) : String {
    var e = exponential(f, significantDigits, culture),
        f = fixed(f, significantDigits, culture);
    return e.length < f.length ? e : f;
  }

/**
Formats a number to hexadecimal format.
**/
  public static function hex(f : Float, ?significantDigits : Int = 1, ?culture : Culture) : String
    return significantDigits == 0 && f == 0 ? "" : toBase(Std.int(f), 16, culture).lpad('0', significantDigits);

/**
Formats the integer part of a number.
**/
  public static function integer(f : Float, ?culture : Culture) : String
    return number(f, 0, culture);

/**
Formats a number with group separators (eg: thousands separators).
**/
  public static function number(f : Float, ?precision : Null<Int>, ?culture : Culture) : String {
    var nf        = numberFormat(culture),
        pattern   = f < 0 ? Pattern.numberNegatives[nf.patternNegativeNumber] : 'n',
        formatted = value(f, (precision).or(nf.decimalDigitsNumber), nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, nf.groupSizesNumber, nf.separatorGroupNumber, nf.separatorDecimalNumber);
    return pattern.replace('n', formatted);
  }

/**
Formats a number to octals.
**/
  public static function octal(f : Float, ?significantDigits : Int = 1, ?culture : Culture) : String
    return significantDigits == 0 && f == 0 ? "" : toBase(Std.int(f), 8, culture).lpad('0', significantDigits);

/**
Formats a number as a percent value. The output result is multiplied by 100. So `0.1` will result in `10%`.
**/
  public static function percent(f : Float, ?decimals : Null<Int>, ?culture : Culture) : String {
    var nf = numberFormat(culture);
    return unit(f * 100, (decimals).or(nf.decimalDigitsPercent), nf.symbolPercent, culture);
  }

/**
Formats a number as a percent value. The output result is multiplied by 1000. So `0.1` will result in `100‰`.
**/
  public static function permille(f : Float, ?decimals : Null<Int>, ?culture : Culture) : String {
    var nf = numberFormat(culture);
    return unit(f * 1000, (decimals).or(nf.decimalDigitsPercent), nf.symbolPermille, culture);
  }

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
  public static function printf(f : Float, pattern : String, ?culture) : String {
    if(!pattern.startsWith('%'))
      throw 'invalid printf term "$pattern"';
    var specifier = pattern.substring(pattern.length-1),
        p = pattern.substring(1, pattern.length - 1).split('.'),
        precision : Null<Int> = null == p[1] || "" == p[1] ? null : Std.parseInt(p[1]),
        justifyRight = true,
        negativeSignOnly = true,
        emptySpaceForSign = false,
        prefix = false,
        padding = " ",
        width = 0,
        flags = p[0];

    while(flags.length > 0) {
      switch flags.substring(0, 1) {
        case "-":
          justifyRight = false;
        case "+":
          negativeSignOnly = false;
        case " ":
          emptySpaceForSign = true;
        case "#":
          prefix = true;
        case "0":
          padding = "0";
        case d if(Ints.canParse(d)):
          width = Ints.parse(flags);
          flags = "";
          continue;
        case _:
          throw 'invalid flags $flags';
      }
      flags = flags.substring(1);
    }

    function decorate(s : String, f : Float, p : String, ns : String, ps : String) {
      if(prefix)
        s = p + s;
      if(f < 0)
        s = ns + s;
      else if(!negativeSignOnly)
        s = ps + s;
      else if(emptySpaceForSign)
        s = " " + s;

      if(justifyRight)
        return s.lpad(padding, width);
      else
        return s.rpad(padding, width);
    }

    var nf = numberFormat(culture);
    return switch specifier {
      case "b": decorate(Ints.toString(Ints.abs(Std.int(f)), 2), 1, "b", "", "");
      case "B": decorate(Ints.toString(Ints.abs(Std.int(f)), 2), 1, "B", "", "");
      case "c": decorate(String.fromCharCode(Ints.abs(Std.int(f))), 1, "", "", "");
      case "d",
           "i": decorate('${Math.round(f)}'.lpad('0', (precision).or(0)), f, "", nf.signNegative, nf.signPositive);
      case "e": decorate(exponential(Math.abs(f), precision, 0, "e", culture), f, "", nf.signNegative, nf.signPositive);
      case "E": decorate(exponential(Math.abs(f), precision, 0, "E", culture), f, "", nf.signNegative, nf.signPositive);
      case "f": decorate(fixed(Math.abs(f), precision, culture), f, "", nf.signNegative, nf.signPositive);
      case "g":
        var e = printf(f, "e", culture),
            f = printf(f, "f", culture);
        e.length < f.length ? e : f;
      case "G":
        var e = printf(f, "E", culture),
            f = printf(f, "f", culture);
        e.length < f.length ? e : f;
      case "u": printf(Math.abs(f), "d", culture);
      case "x": decorate(hex(Math.abs(f), precision, culture), f, "0x", nf.signNegative, nf.signPositive);
      case "X": decorate(hex(Math.abs(f), precision, culture), f, "0X", nf.signNegative, nf.signPositive);
      case "o": decorate(octal(Math.abs(f), precision, culture), f, "0", nf.signNegative, nf.signPositive);
      case "%": decorate("%", 1, "", "", "");
      case _: throw 'invalid pattern "$pattern"';
    };
  }

/**
Transform an `Int` value to a `String` using the specified `base`. A negative sign can be provided optionally.
**/
  public static function toBase(value : Int, base : Int, ?culture : Culture) : String {
    var nf = numberFormat(culture);
    #if(js || flash)
    return untyped value.toString(base).replace('-', nf.signNegative);
    #else

    if(base < 2 || base > BASE.length)
      return throw 'invalid base $base, it must be between 2 and ${BASE.length}';
    if(base == 10 || value == 0)
      return '$value';

    var buf = "",
        abs = Ints.abs(value);
    while(abs > 0) {
      buf = BASE.charAt(abs % base) + buf;
      abs = Std.int(abs / base);
    }

    return (value < 0 ? nf.signNegative : '') + buf;
    #end
  }

/**
Formats a number with a specified `unitSymbol` and a specified number of decimals.
**/
  public static function unit(f : Float, decimals : Int, unitSymbol : String, ?culture : Culture) : String {
    var nf        = numberFormat(culture),
        pattern   = f < 0 ? Pattern.percentNegatives[nf.patternNegativePercent] : Pattern.percentPositives[nf.patternPositivePercent],
        formatted = value(f, decimals, nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, nf.groupSizesPercent, nf.separatorGroupPercent, nf.separatorDecimalPercent);
    return pattern.replace('n', formatted).replace('%', unitSymbol);
  }

// PRIVATE
  static var BASE = "0123456789abcdefghijklmnopqrstuvwxyz";

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
        seg = s.length > size ? s.substring(s.length - size) : s;
        buf.unshift(seg);
        s = s.substring(0, s.length - seg.length);
      }
    }
    return buf.join(groupSeparator);
  }

  static function numberFormat(culture : Culture) : NumberFormatInfo
    return null != culture && null != culture.number ? culture.number : Culture.invariant.number;

  static function pad(s : String, len : Int) : String
    return (s).or('').substring(0, len).rpad('0', len);

  static function paramOrNull(param : String) : Null<Int>
    return param.length == 0 ? null : Std.parseInt(param);

  static function value(f : Float, precision : Int, symbolNaN : String, symbolNegativeInfinity : String, symbolPositiveInfinity : String, groupSizes : Array<Int>, groupSeparator : String, decimalSeparator : String) : String {
    if(Math.isNaN(f))
      return symbolNaN;
    if(!Math.isFinite(f))
      return f < 0 ? symbolNegativeInfinity : symbolPositiveInfinity;

    f = Math.abs(f);
    if(precision >= 0)
      f = Floats.round(f, precision);
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

    if(precision > 0)
      buf.push(pad(d, precision));

    return buf.join(decimalSeparator);
  }
}

/**
Parses a string into an Int value using the provided base. Default base is 16 for strings that begin with
0x (after optional sign) or 10 otherwise.

It is also possible to provide an optiona `negativeSign` and/or `positiveSign`.
**/
/*
  public static function parse(s : String, ?base : Int, ?negativeSign = "-", ?positiveSign = "+") : Null<Int> {
    #if js
    var v : Int = untyped __js__("parseInt")(s, base);
    return Math.isNaN(v) ? null : v;
    #elseif flash9
    if(base == null) base = 0;
    var v : Int = untyped __global__["parseInt"](s, base);
    return Math.isNaN(v) ? null : v;
    #else

    if(base != null && (base < 2 || base > BASE.length))
      return throw 'invalid base $base, it must be between 2 and ${BASE.length}';

    if(s.substring(0, positiveSign.length) == positiveSign)
      s = s.substring(positiveSign.length);

    var negative = s.substring(0, negativeSign.length) == negativeSign;

    if(negative)
      s = s.substring(negativeSign.length);

    if(s.length == 0)
      return null;

    s = s.trim().toLowerCase();

    if(s.startsWith('0x')) {
      if(null != base && 16 != base)
        return null; // attempting at converting a hex using a different base
      base = 16;
      s = s.substring(2);
    } else if(null == base) {
      base = 10;
    }

    return try ((negative ? -1 : 1) * s.toArray().reduce(function(acc, c) {
      var i = BASE.indexOf(c);
      if(i < 0 || i >= base) throw 'invalid';
      return (acc * base) + i;
    }, 0) : Null<Int>) catch(e : Dynamic) null;
    #end
  }
*/