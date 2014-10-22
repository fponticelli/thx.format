# thx.format

[![Build Status](https://travis-ci.org/fponticelli/thx.format.svg)](https://travis-ci.org/fponticelli/thx.format)

Format library for Haxe.

## usage

`thx.format` adds formatting options on top of common Haxe types. To use  require (`using` or `import`) the right formatter (ex: `thx.format.DateFormat` or `thx.format.DateFormat`).

```haxe
var it = Embed.culture('it-it');
var ch = Embed.culture('it-ch');
var us = Embed.culture('en-us');
var ru = Embed.culture('ru-ru');
var fr = Embed.culture('fr-fr');
var jp = Embed.culture('ja-jp');
var d  = Date.fromString('2009-06-01 13:45:30');

// dates
d.format('U');     // Monday, 01 June 2009 13:45:30
d.format('U', it); // lunedì 1 Giugno 2009 13:45:30
d.format('U', ch); // lunedì, 1. Giugno 2009 13:45:30
d.format('U', us); // Monday, June 1, 2009 1:45:30 PM
d.format('U', ru); // 1 Июнь 2009 г. 13:45:30
d.format('U', fr); // lundi 1 juin 2009 13:45:30
d.format('U', jp); // 2009年6月1日 13:45:30
```

And numbers:

```haxe
(-12345.6789).currency();   // (¤12,345.67)
(-12345.6789).currency(it); // -€ 12.345,67
(-12345.6789).currency(us); // ($12,345.67)
12345.6789.integer();       // 12,345
0.02333.percent();          // 2.33 %
0.02333.percent(it);        // 2,33%
0.02333.permille();         // 23.33 ‰
0.02333.permille(it);       // 23,33‰
23.3333.unit(2, 'kg.');     // 23.33 kg.
23.3333.unit(2, 'kg.', it); // 23,33kg.
```

## install

```bash
haxelib git thx.format https://github.com/fponticelli/thx.format.git
```