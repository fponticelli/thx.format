package thx.format;

import haxe.macro.Expr;

class Format {
  macro public static function f(subject : Expr, pattern : ExprOf<String>, ?culture : ExprOf<thx.culture.Culture>) {
    trace(haxe.macro.ExprTools.toString(subject));

    var t = haxe.macro.Context.typeof(subject);
    trace(t);


    return switch haxe.macro.TypeTools.toString(t) {
      case "Date":
        macro thx.format.DateFormat.format($e{subject}, $e{pattern}, $e{culture});
      case "Int", "Float":
        macro thx.format.NumberFormat.format($e{subject}, $e{pattern}, $e{culture});
      case t:
        haxe.macro.Context.error('Unsupported type "$t" for formatting', subject.pos);
    };

    haxe.macro.ExprTools.map(subject, function(e) {
      trace(e);
      return e;
    });
    return pattern;
  }
}