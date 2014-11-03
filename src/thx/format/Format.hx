package thx.format;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.TypeTools;

class Format {
/**
Applies the right format according to the type of subject.

```haxe
Date.now().f("D"); // returns the date in long format
12345.f("n", it);  // returns a number formatted using the provided culture
```
*/
  macro public static function f(subject : Expr, pattern : ExprOf<String>, ?culture : ExprOf<thx.culture.Culture>)
    return switch TypeTools.toString(Context.typeof(subject)) {
      case "Date":
        macro thx.format.DateFormat.format($e{subject}, $e{pattern}, $e{culture});
      case "Int", "Float":
        macro thx.format.NumberFormat.format($e{subject}, $e{pattern}, $e{culture});
      case t:
        haxe.macro.Context.error('Unsupported type "$t" for formatting', subject.pos);
    };
}