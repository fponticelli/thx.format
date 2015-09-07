package thx.format;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;
import thx.culture.Culture;

class Format {
  @:isVar public static var defaultCulture(get, set) : Culture;

  static function get_defaultCulture()
    return null != defaultCulture ? defaultCulture : Culture.invariant;

  static function set_defaultCulture(culture : Culture) {
    defaultCulture = culture;
    return get_defaultCulture();
  }

/**
Applies the right format according to the type of subject.

```haxe
Date.now().f("D"); // returns the date in long format
12345.f("n", it);  // returns a number formatted using the provided culture
```
*/
  macro public static function f(subject : Expr, pattern : ExprOf<String>, ?culture : ExprOf<thx.culture.Culture>)
    return switch TypeTools.toString(Context.follow(Context.typeof(subject))) {
      case "thx.DateTime", "thx.DateTimeUtc":
        macro thx.format.DateFormat.format($e{subject}, $e{pattern}, $e{culture});
      case "Date":
        macro thx.format.DateFormat.format(($e{subject} : thx.DateTime), $e{pattern}, $e{culture});
      case "thx.BigInt":
        macro thx.format.BigIntFormat.format($e{subject}, $e{pattern}, $e{culture});
      case "thx.Decimal":
        macro thx.format.DecimalFormat.format($e{subject}, $e{pattern}, $e{culture});
      case "Int", "Float":
        macro thx.format.NumberFormat.format($e{subject}, $e{pattern}, $e{culture});
      case t:
        haxe.macro.Context.error('Unsupported type "$t" for formatting', subject.pos);
    };
}
