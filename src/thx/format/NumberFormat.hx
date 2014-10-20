package thx.format;

import thx.culture.Culture;
import thx.culture.NumberFormatInfo;
import thx.culture.Pattern;
using thx.core.Defaults;
using thx.core.Ints;
using StringTools;

class NumberFormat {
  public static function format(f : Float, ?format : NFormat, ?culture : Culture)
    return switch format {
      case Decimal(decimals): decimal(f, decimals, culture);
      case Integer: integer(f, culture);
    }
/*
  public static function format(num : Float, ?format : NFormat, ?culture : Culture)
    return switch format {
      case 'C':
        var s = params.length > 1 ? params[1] : null;
        return function(v) return FormatNumber.currency(v, s, decimals, culture);
      case 'P':
        return function(v) return FormatNumber.percent(v, decimals, culture);
      case 'M':
        return function(v) return FormatNumber.permille(v, decimals, culture);
    };
*/

  public static function decimal(f : Float, ?decimals : Int, ?culture : Culture) {
    var nf        = (culture).or(Culture.invariant).number,
        pattern   = f < 0 ? Pattern.numberNegatives[nf.patternNegativeNumber] : 'n',
        formatted = value(f, (decimals).or(nf.decimalDigitsNumber), nf.symbolNaN, nf.symbolNegativeInfinity, nf.symbolPositiveInfinity, nf.groupSizesNumber, nf.separatorGroupNumber, nf.separatorDecimalNumber);
    return pattern.replace('n', formatted);
  }

  public static function integer(f : Float, ?culture : Culture)
    return decimal(f, 0, culture);

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

    if((d).or('').indexOf('e') > 0) {
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

  static function pad(s : String, len : Int) {
    return (s).or('').substr(0, len).rpad('0', len);
  }

  static function intPart(s : String, groupSizes : Array<Int>, groupSeparator : String) {
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
}

enum NFormat {
  Decimal(?decimals : Int);
  Integer;
  /*
  Currency;
  Percent(decimals : Int);
  Permille(decimals : Int);
  */
}