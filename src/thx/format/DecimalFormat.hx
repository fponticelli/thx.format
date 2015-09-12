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

class DecimalFormat {
/**
Formats a currency value. By default the currency symbol is extracted from the applied culture but it can be optionally
provided using setting the `symbol` argument.
**/
  public static function currency(decimal : Decimal, ?precision : Null<Int>, ?symbol : String, ?culture : Culture) : String {
    decimal = decimal.trim();
    var nf = numberFormat(culture),
        pattern = decimal.isNegative() ? Pattern.currencyNegatives[nf.patternNegativeCurrency] : Pattern.currencyPositives[nf.patternPositiveCurrency],
        formatted = value(decimal, (precision).or(nf.decimalDigitsCurrency), nf.groupSizesCurrency, nf.separatorGroupCurrency, nf.separatorDecimalCurrency);
    return pattern.replace('n', formatted).replace('$', (symbol).or(nf.symbolCurrency));
  }

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
  public static function customFormat(decimal : Decimal, pattern : String, ?culture : Culture) : String {
    decimal = decimal.trim();
    var nf = numberFormat(culture);
    // split on section separator
    var isCurrency = hasSymbols(pattern, '$'),
        isPercent = !isCurrency && (hasSymbols(pattern, '%‰')),
        groups = splitPattern(pattern, ";");
    if(groups.length > 3) throw 'invalid number of sections in "$pattern"';
    return if(decimal.isNegative()) {
      if(null != groups[1]) {
        customFormatDecimal(decimal.negate(), groups[1], nf, isCurrency, isPercent);
      } else {
        customFormatDecimal(decimal.negate(), "-"+groups[0], nf, isCurrency, isPercent);
      }
    } else if(decimal.isZero()) {
      customFormatDecimal(0, (groups[2]).or(groups[0]), nf, isCurrency, isPercent);
    } else {
      customFormatDecimal(decimal, groups[0], nf, isCurrency, isPercent);
    };
  }

/**
Formats a decimal (integer) value.
**/
  public static function decimal(dec : Decimal, ?significantDigits : Int = 1, ?culture : Culture) : String {
    dec = dec.trim();
    var nf = numberFormat(culture);
    var formatted = value(dec, 0, [0], '', '');
    return (dec.isNegative() ? nf.signNegative : '') + formatted.lpad('0', significantDigits);
  }

/**
Formats a number using the exponential (scientific) format.
**/
  public static function exponential(decimal : Decimal, ?precision : Int = 6, ?digits : Int = 3, ?symbol : String = 'e', ?culture : Culture) : String {
    decimal = decimal.trim();
    var nf = numberFormat(culture);
    var info = exponentialInfo(decimal);
    return number(info.f, precision, culture) +
           symbol +
           (info.e < 0 ? nf.signNegative : nf.signPositive) +
           '${Ints.abs(info.e)}'.lpad('0', digits);
  }

/**
Formats a fixed point float number with an assigned precision.
**/
  public static function fixed(decimal : Decimal, ?precision : Null<Int>, ?culture : Culture) : String {
    decimal = decimal.trim();
    var nf = numberFormat(culture),
        pattern = decimal.isNegative() ? Pattern.numberNegatives[nf.patternNegativeNumber] : 'n',
        formatted = value(decimal, (precision).or(nf.decimalDigitsNumber), [0], '', nf.separatorDecimalNumber);
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
  public static function format(decimal : Decimal, pattern : String, ?culture : Culture) : String {
    var specifier = pattern.substring(0, 1),
        param = paramOrNull(pattern.substring(1));
    return switch specifier {
      // currency
      case 'C', 'c': currency(decimal, param, culture);
      // decimal
      case 'D', 'd': DecimalFormat.decimal(decimal, param, culture);
      // exponential E
      case 'E':      exponential(decimal, param, culture);
      // exponential e
      case 'e':      exponential(decimal, param, culture).toLowerCase();
      // fixed point
      case 'F', 'f': fixed(decimal, param, culture);
      // general
      case 'G':      general(decimal, param, culture);
      // general lower case
      case 'g':      general(decimal, param, culture).toLowerCase();
      // number
      case 'N', 'n': number(decimal, param, culture);
      // percent
      case 'P', 'p': percent(decimal, param, culture);
      // round trip
      case 'R', 'r': decimal.toString();
      // hexadecimal X
      case 'X':      BigIntFormat.hex(decimal.toBigInt(), param, culture).toUpperCase();
      // hexadecimal x
      case 'x':      BigIntFormat.hex(decimal.toBigInt(), param, culture);
      // printf
      case "%":      printf(decimal, pattern, culture);
      // custom format
      case _:        customFormat(decimal, pattern, culture);
    };
  }

/**
Formats a number using either the shortest result between `fixed` and `exponential`.
**/
  public static function general(decimal : Decimal, ?significantDigits : Null<Int>, ?culture : Culture) : String {
    decimal = decimal.trim();
    var e = exponential(decimal, significantDigits, culture),
        f = fixed(decimal, significantDigits, culture);
    return e.length < f.length ? e : f;
  }

/**
Formats the integer part of a number.
**/
  public static function integer(decimal : Decimal, ?culture : Culture) : String
    return BigIntFormat.integer(decimal.toBigInt(), culture);

/**
Formats a number with group separators (eg: thousands separators).
**/
  public static function number(decimal : Decimal, ?precision : Null<Int>, ?culture : Culture) : String {
    decimal = decimal.trim();
    var nf = numberFormat(culture),
        pattern = decimal.isNegative() ? Pattern.numberNegatives[nf.patternNegativeNumber] : 'n',
        formatted = value(decimal, (precision).or(nf.decimalDigitsNumber), nf.groupSizesNumber, nf.separatorGroupNumber, nf.separatorDecimalNumber);
    return pattern.replace('n', formatted);
  }

/**
Formats a number to octals.
**/
  public static function octal(decimal : Decimal, ?significantDigits : Int = 1, ?culture : Culture) : String
    return BigIntFormat.octal(decimal.toBigInt(), culture);

/**
Formats a number as a percent value. The output result is multiplied by 100. So `0.1` will result in `10%`.
**/
  public static function percent(decimal : Decimal, ?decimals : Null<Int>, ?culture : Culture) : String {
    decimal = decimal.trim();
    var nf = numberFormat(culture);
    return unit((decimal * 100).trim(), (decimals).or(nf.decimalDigitsPercent), nf.symbolPercent, culture);
  }

/**
Formats a number as a percent value. The output result is multiplied by 1000. So `0.1` will result in `100‰`.
**/
  public static function permille(decimal : Decimal, ?decimals : Null<Int>, ?culture : Culture) : String {
    decimal = decimal.trim();
    var nf = numberFormat(culture);
    return unit((decimal * 1000).trim(), (decimals).or(nf.decimalDigitsPercent), nf.symbolPermille, culture);
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
  public static function printf(decimal : Decimal, pattern : String, ?culture) : String {
    if(!pattern.startsWith('%'))
      throw 'invalid printf term "$pattern"';
    decimal = decimal.trim();
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

    function decorate(s : String, decimal : Decimal, p : String, ns : String, ps : String) {
      if(prefix)
        s = p + s;
      if(decimal.isNegative())
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
      case "b": decorate(decimal.toBigInt().toStringWithBase(2), 1, "b", "", "");
      case "B": decorate(decimal.toBigInt().toStringWithBase(2), 1, "B", "", "");
      case "c": decorate(String.fromCharCode(decimal.toInt()), 1, "", "", "");
      case "d",
           "i": decorate(decimal.toBigInt().toString().lpad('0', (precision).or(0)), decimal, "", nf.signNegative, nf.signPositive);
      case "e": decorate(exponential(decimal.abs(), precision, 0, "e", culture), decimal, "", nf.signNegative, nf.signPositive);
      case "E": decorate(exponential(decimal.abs(), precision, 0, "E", culture), decimal, "", nf.signNegative, nf.signPositive);
      case "f": decorate(fixed(decimal.abs(), precision, culture), decimal, "", nf.signNegative, nf.signPositive);
      case "g":
        var e = printf(decimal, "e", culture),
            f = printf(decimal, "f", culture);
        e.length < f.length ? e : f;
      case "G":
        var e = printf(decimal, "E", culture),
            f = printf(decimal, "f", culture);
        e.length < f.length ? e : f;
      case "u": printf(decimal.abs(), "d", culture);
      case "x": decorate(BigIntFormat.hex(decimal.toBigInt().abs(), precision, culture), decimal, "0x", nf.signNegative, nf.signPositive);
      case "X": decorate(BigIntFormat.hex(decimal.toBigInt().abs(), precision, culture), decimal, "0X", nf.signNegative, nf.signPositive);
      case "o": decorate(BigIntFormat.octal(decimal.toBigInt().abs(), precision, culture), decimal, "0", nf.signNegative, nf.signPositive);
      case "%": decorate("%", 1, "", "", "");
      case _: throw 'invalid pattern "$pattern"';
    };
  }

/**
Transform an `Int` value to a `String` using the specified `base`. A negative sign can be provided optionally.
**/
  public static function toBase(value : Decimal, base : Int, ?culture : Culture) : String
    return BigIntFormat.toBase(value.toBigInt(), base, culture);

/**
Formats a number with a specified `unitSymbol` and a specified number of decimals.
**/
  public static function unit(decimal : Decimal, decimals : Int, unitSymbol : String, ?culture : Culture) : String {
    decimal = decimal.trim();
    var nf = numberFormat(culture);
    var pattern   = decimal.isNegative() ? Pattern.percentNegatives[nf.patternNegativePercent] : Pattern.percentPositives[nf.patternPositivePercent],
        formatted = value(decimal, decimals, nf.groupSizesPercent, nf.separatorGroupPercent, nf.separatorDecimalPercent);
    return pattern.replace('n', formatted).replace('%', unitSymbol);
  }

// PRIVATE
  static function exponentialInfo(decimal : Decimal) {
    var s = decimal.abs().toString(),
        p = s.split('.').concat(['']),
        e = 0;

    if(p[0].length > 1) {
      e = p[0].length - 1;
      p[1] = p[0].substring(1) + p[1];
      p[0] = p[0].substring(0, 1);
    } else if(p[0] == '0') {
      e = -(1 + p[1].length - p[1].trimCharsLeft('0').length);
      p[1] = p[1].substring(-e-1);
      p[0] = p[1].substring(0, 1);
      p[1] = p[1].substring(1);
    }
    return {
      e : e,
      f : (Decimal.fromString(p.slice(0, 2).join(".")) * (decimal.isNegative() ? -1 : 1)).trim()
    };
  }

  static function customFormatDecimalFraction(d : String, pattern : String, nf : NumberFormatInfo) : String {
    var buf = "",
        i = 0,
        quote = 0,
        p = d.toArray(),
        last = 0;
    while(i < pattern.length) {
      switch [pattern.substring(i, i+1), quote] {
        case ["\\", _]:
          i++;
          buf += pattern.substring(i, i+1);
        case ['"', 0]:
          quote = 2;
        case ["'", 0]:
          quote = 1;
        case ['"', 2],
             ["'", 1]:
          quote = 0;
        case [c, 1],
             [c, 2]:
          buf += c;
        case ["0", 0]:
          last = buf.length;
          buf += p.length == 0 ? "0" : p.shift();
        case ["#", 0]:
          last = buf.length;
          buf += p.length == 0 ? "" : p.shift();
        case ["$", 0]:
          buf += nf.symbolCurrency;
        case ["%", 0]:
          buf += nf.symbolPercent;
        case ["‰", 0]:
          buf += nf.symbolPermille;
        case [c, _]:
          buf += c;
      }
      i++;
    }
    return buf;
  }

  static function customFormatDecimal(decimal : Decimal, pattern : String, nf : NumberFormatInfo, isCurrency : Bool, isPercent : Bool) : String {
    if(isPercent)
      decimal = (decimal * (hasSymbols(pattern, "‰") ? 1000 : 100)).trim();

    var exp = splitPattern(pattern, "eE");
    if(exp.length > 1) {
      var info = exponentialInfo(decimal),
          symbol = pattern.substring(exp[0].length, exp[0].length + 1),
          forceSign = exp[1].startsWith("+");
      if(forceSign || exp[1].startsWith("-"))
        exp[1] = exp[1].substring(1);
      return customIntegerAndFraction(info.f, exp[0], nf, isCurrency, isPercent) +
             symbol +
             (info.e < 0 ? nf.signNegative : forceSign ? nf.signPositive : "") +
             customFormatInteger('${Math.abs(info.e)}', exp[1], nf, isCurrency, isPercent);
    } else {
      return customIntegerAndFraction(decimal, pattern, nf, isCurrency, isPercent);
    }
  }

  static function customFormatInteger(v : String, pattern : String, nf : NumberFormatInfo, isCurrency : Bool, isPercent : Bool) : String {
    var buf = [],
        i = 0,
        quote = 0,
        p = v.toArray(),
        lbuf = "",
        first = true,
        useGroups = false,
        zeroes = 0;
    while(i < pattern.length) {
      switch [pattern.substring(i, i+1), quote] {
        case ["\\", _]:
          i++;
          buf.push(Literal(pattern.substring(i, i+1)));
        case ['"', 0]:
          quote = 2;
        case ["'", 0]:
          quote = 1;
        case ['"', 2],
             ["'", 1]:
          quote = 0;
          buf.push(Literal(lbuf));
          lbuf = "";
        case [c, 1],
             [c, 2]:
          lbuf += c;
        case [",", 0]:
          useGroups = true;
        case ["0", 0]:
          buf.push(Zero(first));
          first = false;
          zeroes++;
        case ["#", 0]:
          buf.push(Hash(first));
          first = false;
        case ["$", 0]:
          buf.push(Literal(nf.symbolCurrency));
        case ["%", 0]:
          buf.push(Literal(nf.symbolPercent));
        case ["‰", 0]:
          buf.push(Literal(nf.symbolPermille));
        case [c, _]:
          buf.push(Literal(c));
      }
      i++;
    }
    if(lbuf.length > 0)
      buf.push(Literal(lbuf));


    for(i in p.length...zeroes)
      p.unshift("0");

    if(useGroups) {
      i = p.length - 1;
      var groups = isCurrency ?
            nf.groupSizesCurrency.copy() :
            isPercent ?
              nf.groupSizesPercent.copy() :
              nf.groupSizesNumber.copy(),
          group = groups.shift(),
          pos = 0;
      while(i >= 0) {
        if(group == 0) break;
        if(pos == group) {
          p[i] = p[i] + (isCurrency ?
            nf.separatorGroupCurrency :
            isPercent ?
              nf.separatorGroupPercent :
              nf.separatorGroupNumber);
          pos = 0;
          if(groups.length > 0)
            group = groups.shift();
        } else {
          pos++;
          i--;
        }
      }
    }

    buf.reverse();
    var r = buf.map.fn(switch _ {
      case Literal(s): s;
      case Hash(first): p.length == 0 ? "" : first ? p.join("") : p.pop();
      case Zero(first): first ? p.join("") : p.pop();
    });
    r.reverse();
    return r.join("");
  }

  static function customIntegerAndFraction(decimal : Decimal, pattern : String, nf : NumberFormatInfo, isCurrency : Bool, isPercent : Bool) {
    var p = splitPattern(pattern, "."),
        power = p[0].length - (p[0] = p[0].trimCharsRight(",")).length;
    decimal = (decimal / Math.pow(1000, power)).trim();
    if(p.length == 1) {
      return customFormatInteger(decimal.round().toBigInt().toString(), p[0], nf, isCurrency, isPercent);
    } else {
      decimal = decimal.roundTo(countSymbols(p[1], "#0")).trim();
      var np = splitOnDecimalSeparator(decimal);
      return customFormatInteger(np[0], p[0], nf, isCurrency, isPercent) +
             (isCurrency ?
               nf.separatorDecimalCurrency :
               isPercent ?
                 nf.separatorDecimalPercent :
                 nf.separatorDecimalNumber) +
             customFormatDecimalFraction((np[1]).or("0"), p[1], nf);
    }
  }

  static function hasSymbols(pattern : String, symbols : String) {
    var i = 0,
        quote = 0; // single quote == 1, double quote == 2
    while(i < pattern.length) {
      switch [pattern.substring(i, i+1), quote] {
        case ["\\", _]: i++; // skip next
        case ["'", 1],
             ['"', 2]: quote = 0; // close single or double quote
        case ["'", 0]: quote = 1; // open single quote
        case ['"', 0]: quote = 2; // open double quote
        case [s, 0] if(symbols.contains(s)): return true; // accept only if not in quotes
        case [_, _]:
      }
      i++;
    }
    return false;
  }

  static function intPart(s : String, groupSizes : Array<Int>, groupSeparator : String) : String {
    var buf = [],
        pos = 0,
        sizes = groupSizes.copy(),
        size = sizes.shift(),
        seg;
    while(s.length > 0) {
      if(size == 0) {
        buf.unshift(s);
        s = "";
      } else if(s.length > size) {
        buf.unshift(s.substring(s.length - size));
        s = s.substring(0, s.length - size);
        if(sizes.length > 0)
          size = sizes.shift();
      } else {
        buf.unshift(s);
        s = "";
      }
    }
    return buf.join(groupSeparator);
  }

  static function numberFormat(culture : Culture) : NumberFormatInfo
    return null != culture && null != culture.number ? culture.number : Format.defaultCulture.number;

  static function pad(s : String, len : Int, round : Bool) : String {
    s = (s).or('');
    if(len > 0 && s.length > len) {
      if(round) {
        return s.substring(0, len - 1) + (Std.parseInt(s.substring(len - 1, len)) + (Std.parseInt(s.substring(len, len + 1)) >= 5 ? 1 : 0));
      } else {
        return s.substring(0, len);
      }
    } else {
      return s.rpad('0', len);
    }
  }

  static function paramOrNull(param : String) : Null<Int>
    return param.length == 0 ? null : Std.parseInt(param);

  static function splitOnDecimalSeparator(decimal : Decimal) {
    return decimal.toString().split('.');
  }

  static function splitPattern(pattern : String, separator : String) {
    var pos = [],
        i = 0,
        quote = 0; // single quote == 1, double quote == 2
    while(i < pattern.length) {
      switch [pattern.substring(i, i+1), quote] {
        case ["\\", _]: i++; // skip next
        case ["'", 1],
             ['"', 2]: quote = 0; // close single or double quote
        case ["'", 0]: quote = 1; // open single quote
        case ['"', 0]: quote = 2; // open double quote
        case [s, 0] if(separator.contains(s)):
          pos.push(i); // count only if not in quotes
        case [_, _]:
      }
      i++;
    }
    var buf = [],
        prev = 0;
    for(p in pos) {
      buf.push(pattern.substring(prev, p));
      prev = p + 1;
    }
    buf.push(pattern.substring(prev));
    return buf;
  }

  static function value(decimal : Decimal, precision : Int, groupSizes : Array<Int>, groupSeparator : String, decimalSeparator : String) : String {
    decimal = decimal.abs();
    var p = splitOnDecimalSeparator(decimal);

    if(precision <= 0 && null != p[1]) {
      if(Std.parseFloat('0.${p[1]}') >= 0.5)
        p[0] = p[0].substring(0, p[0].length-1) + (Std.parseFloat(p[0].substring(p[0].length-1)) + 1);
    }

    var buf = [];
    buf.push(intPart(p[0], groupSizes, groupSeparator));

    if(precision > 0)
      buf.push(pad(p[1], precision, true));

    return buf.join(decimalSeparator);
  }

  static function countSymbols(pattern : String, symbols : String) {
    var i = 0,
        quote = 0, // single quote == 1, double quote == 2
        count = 0;
    while(i < pattern.length) {
      switch [pattern.substring(i, i+1), quote] {
        case ["\\", _]: i++; // skip next
        case ["'", 1],
             ['"', 2]: quote = 0; // close single or double quote
        case ["'", 0]: quote = 1; // open single quote
        case ['"', 0]: quote = 2; // open double quote
        case [s, 0] if(symbols.contains(s)): ++count; // accept only if not in quotes
        case [_, _]:
      }
      i++;
    }
    return count;
  }
}

// TODO duplicate, remove
private enum CustomFormat {
  Literal(s : String);
  Hash(first : Bool);
  Zero(first : Bool);
}
