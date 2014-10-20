#!/bin/sh
rm thx.format.zip
zip -r thx.format.zip hxml src test doc/ImportFormat.hx extraParams.hxml haxelib.json README.md test test.hxml
haxelib submit thx.format.zip