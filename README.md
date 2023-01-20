# Godot-CSS-Theme

Converts CSS to Godot Themes.

The goal is to make theme creating easier and more reusable. Using CSS you also have the advantage to use preprocessors
like [SASS](https://sass-lang.com/).

## How to use

Create a `css` file and run one of the following commands to create the themes.

```sh
# Output defaults to same folder with .tres extension
godot -s addons/godot-css-theme/convert.gd --input="res://themes/themes.css"

# To output in a different file
godot -s addons/godot-css-theme/convert.gd --input="res://themes/themes.css" --output="res://output/themes.tres"

```

Then set the default theme and font in the Project Settings in `gui/theme/custom` and `gui/theme/custom_font`;

## Supported Features

Generally all properties of a Godot Theme should be supported. The program uses custom css variables to set values.

The node_type is used like a tag to decide which node to style (e.g. `Button` or `CheckBox`).
The `body` tag has a special meaning. It is used to set global styles where possible.

The structure for a statement is `--{TYPE}-{PROPERTY}: {VALUE}`
The only exception is for setting `styles`. They need a special type definition like
`--styles-{PROPERTY}-type: {VALUE}`. See [syntax](#syntax)

Classes for `node_types` are supported and they will be generated as a separate theme in the same output directory.

For a list of all supported features see [FEATURES.md](./FEATURES.md)

### Syntax Overview

- `--{TYPE}-{PROPERTY}: {VALUE}`
  - `{TYPE}` - `colors`, `const`, `fonts`, `styles`
  - `{PROPERTY}` - anything the node_type supports
  - `{VALUE}` - anything `str2var()` supports, hex values, `url()`
- `--styles-{PROPERTY}-type` values: `Empty`, `Flat`, `Line`, `Texture`
- external resources are specified with `url()`.
  - `url(res://file.txt)` or `url(/file.txt)` - absolute path
  - `url(file.txt)` - relative path to css file

### Example:

```css
Button {
  --colors-font-color: #000;
  --colors-font-color-disabled: Color(0, 0, 0, 0.5);

  --const-hseparation: 5;

  --fonts-font: url(res://font.tres);

  --styles-normal-type: Flat;
  --styles-normal-bg-color: #fff;
}
```

## Contribute

If you see any problems or have any ideas for new features feel free to create an issue or a PR

Just make sure that the features are documented in `FEATURES.md` and that there is some kind of test for it.

- `base-syntax.css` - should contain all possible styles that can be set
- `simple-syntax.css` - should contain all simplified syntax that is supported

## Problems

- Using colors with words like `red` or `blue` does not work. Either use hex `#000` or
  native gdscript `Color(0, 0, 0, 1)`
- Godot might have to be closed before generating. Otherwise it might rewrite some values
