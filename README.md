# GreaseMonkey helper library

This is just at the very beginning.

## Rationale

CoffeeScript makes it easy to use Object Orientation for GreaseMonkey user scripts.

This here tries to combine some reusable parts for those scripts.

## Example how to get started

```bash
mkdir my-userscript
cd my-userscript
git init
git submodule add https://github.com/hilbix/gmlib.git gmlib
cp gmlib/Makefile .
vim Makefile
```
```
TARG=my-userscript.user.js
SUBS=gmlib
```
```
vim my-userscript.user.coffee
```
```
#// ==UserScript==
#// @name        my-userscript
#// @description My little userscript
#// @version     0.{{{VERSION}}}
#// @downloadURL https://gm.example.com/my-userscript/my-userscript.user.js
#// @namespace   https://gm.example.com/my-userscript/
#// @include     https://gm.example.com/my-userscript/*
#// @grant       GM_info
#// @grant       GM_getValue
#// @grant       GM_setValue
#// @grant       GM_xmlhttpRequest
#// @require     gmlib/libgm.js
#// @require     gmlib/libcoffee.js
#//
#// Include supported pages here:
#//
#// @include     /^http://www\.example\.net//
#// @include     /^http://example\.org/somesite//
#// ==/UserScript==
#//
#// DO NOT MODIFY!  Instead modify: {{{FILENAME}}}

# Hack for remote script development (do not use coffee -b):
`if (GM_evilUpdateHack('https://gm.example.com/my-userscript/update.html')) return`

# put your nifty script here
```

To compile everything, just type `make`.  And be sure to have `coffee` installed, of course.


## Hack for remote script development

The trouble with GreaseMonkey is, that you cannot edit user scripts properly.  There is the builtin editor, but what if you cannot use this (perhaps because the user script is part of some bigger remote solution)?  GreaseMonkey does not catch the updates in any reasonable time then.  And always uninstalling and resinstalling the script is a pain in the ass.

The solution to this problem is twofold:

- Provide a special development page, which pulls together alls the changed bits and store them in the global config store
- Change the script in a way, that a small "development wrapper" can check if there is the global config and execute the script from there using the big evil `eval`.

You can accomplish that as follows:
- Invent a URL (called `UPDATEURL`) with arbitrary content.  The content is not of any interest.
- The URL of the page must be `@include`d in the user script, so the user script must run on this page.
- If you want to reload the script, then just reload this `UPDATEURL`.
- In the console, you then can see what happened.

At the very beginning of the script, add following:

```
`if (GM_evilUpdateHack('UPDATEURL')) return`
```

Be sure to replace `UPDATEURL` with the URL chosen by you.

> Note that this only works for scripts which have the `@grant` option set as shown above.
> Also there might be some other user scripts where this hack simply does not work (for example if you use `coffee -b`).
> This is bejond the scope of this solution.  If you have that case, you need to invent your own solution, sorry.


## License

This Works is placed under the terms of the Copyright Less License,
see file COPYRIGHT.CLL.  USE AT OWN RISK, ABSOLUTELY NO WARRANTY.

Read:  This is CC0 (Public Domain) as long as not covered by any Copyright.
