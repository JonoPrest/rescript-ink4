# ReScript Bindings for Ink (version 4)

## Installation

1. Install all necessary packages according to the official "Ink" docs: https://github.com/vadimdemedes/ink
2. Install `rescript-ink4`

```sh
npm install rescript-ink4
```

3. Add it to `dependencies` in your `rescript.json`:

```json
{
  "bs-dependencies": [
    "rescript-ink4",
    ...
  ]
}
```

This library provides [ReScript](https://rescript-lang.org/) bindings for [Ink version 4](https://github.com/vadimdemedes/ink).

These bindings will only work with ReScript 11 (uncurried mode) and JSX version 4, as it enables us to utilize [untagged variants](https://rescript-lang.org/blog/improving-interop#untagged-variants), optional record fields and optional labelled arguments.

## Ink 4 and ESM

Ink 4 uses ESM and so in order to run with node you need the following settings in your rescript.json

```json
  "package-specs": {
    "module": "es6",
    "in-source": true,
    "suffix": ".res.mjs"
  },
  "jsx": {
    "version": 4
  },
  "bs-dependencies": [
    "rescript-ink4",
    "@rescript/react"
  ],
  ...
```

1. package-specs need to specify `es6` (Not `commonjs`) to use import/export syntax
2. suffix needs end in .mjs so that all files can be run as esm modules in node js
3. use jsx version 4 with rescript react
4. specify `"type": "module"` in your package.json to run

## Using your own theme

You can construct your own bindings with a theme. By default, components will just use a string for color eg:

```res
open Ink
<Text color={"#9860E5"}>{"Hello World"->React.string}</Text>
```

Colors in ink simply use chalk under the hood so hex-codes/rgb and color keywords are supported.

Often it's nicer to specify your own theme and interop like this:

```res
module InkWithTheme = Ink.MakeInkWithTheme({
type theme =
| @as("#9860E5") Primary
| @as("#FFBB2F") Secondary
| @as("#6CBFEE") Info
| @as("#FF8269") Danger
| @as("#3B8C3D") Success
})
```

Now anywhere that uses a color will take your themed variant instead of a string

```res
open InkWithTheme
<Text color={Primary}>{"Hello World"->React.string}</Text>
```
