#!/bin/sh
rm thx.format.zip
zip -r thx.format.zip hxml src test doc/ImportFormat.hx extraParams.hxml haxelib.json LICENSE README.md test test.hxml -x "*/\.*"
haxelib submit thx.format.zip
