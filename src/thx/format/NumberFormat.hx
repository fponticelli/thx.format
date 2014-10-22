package thx.format;

import thx.culture.Culture;
import thx.culture.NumberFormatInfo;
import thx.culture.Pattern;
using thx.core.Defaults;
using thx.core.Ints;
using StringTools;

class NumberFormat {
  public static function format(f : Float, ?nformat : NFormat, ?culture : Culture) : String
    return switch nformat {
      case Decimal(decimals): formatDecimal(f, decimals, culture);
      case Integer: formatInteger(f, culture);
      case Currency(decimals, symbol): formatCurrency(f, decimals, symbol, culture);
      case Percent(decimals): formatPercent(f, decimals, culture);
      case Permille(decimals): formatPermille(f, decimals, culture);
      case Unit(decimals, symbol): formatUnit(f, decimals, symbol, culture);
    };

  public static function formatCurrency(f : Float, ?decimals : Null<Int>, ?symbol : String, ?culture : Culture) : String {
    var nf        = number(culture),
        pattern   = f < 0 ? Pattern.currencyNegatives[nf.patternNegativeCurrency] : Pattern.currencyPositives[nf.patternPositiveCurrency],
        formatted = value(f, (decimals).or(nf.decimalDigitsCurrency), nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, nf.groupSizesCurrency, nf.separatorGroupCurrency, nf.separatorDecimalCurrency);
    return pattern.replace('n', formatted).replace('$', (symbol).or(nf.symbolCurrency));
  }

  public static function formatDecimal(f : Float, ?decimals : Null<Int>, ?culture : Culture) : String {
    var nf        = number(culture),
        pattern   = f < 0 ? Pattern.numberNegatives[nf.patternNegativeNumber] : 'n',
        formatted = value(f, (decimals).or(nf.decimalDigitsNumber), nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, nf.groupSizesNumber, nf.separatorGroupNumber, nf.separatorDecimalNumber);
    return pattern.replace('n', formatted);
  }

  public static function formatInteger(f : Float, ?culture : Culture) : String
    return formatDecimal(f, 0, culture);

  public static function formatPercent(f : Float, ?decimals : Null<Int>, ?culture : Culture) : String {
    var nf = number(culture);
    return formatUnit(f * 100, (decimals).or(nf.decimalDigitsPercent), nf.symbolPercent, culture);
  }

  public static function formatPermille(f : Float, ?decimals : Null<Int>, ?culture : Culture) : String {
    var nf = number(culture);
    return formatUnit(f * 1000, (decimals).or(nf.decimalDigitsPercent), nf.symbolPermille, culture);
  }

  public static function formatUnit(f : Float, decimals : Int, symbol : String, ?culture : Culture) : String {
    var nf        = number(culture),
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

  static function pad(s : String, len : Int) : String {
    return (s).or('').substr(0, len).rpad('0', len);
  }

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

  static function number(culture : Culture) : NumberFormatInfo
    return null != culture && null != culture.number ? culture.number : Culture.invariant.number;
}

enum NFormat {
  Decimal(?decimals : Int);
  Integer;
  Currency(?decimals : Int, ?symbols : String);
  Percent(?decimals : Int);
  Permille(?decimals : Int);
  Unit(decimals : Int, symbol : String);
}