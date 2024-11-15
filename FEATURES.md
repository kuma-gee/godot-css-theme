# Features

For a full list of examples see the css files in `tests/e2e`.

## Classes

Note: currently only works using the command cli (see issue #6)

You can use classes in the css files but they need to be associated with a `node_type` (e.g `Button.cool-button`).
They cannot be used standalone. Classes will be grouped together and will be generated as a separate theme.

For example the following will generate two separate themes. In the same directory where the default one is created,
there will be another theme called `dark-mode.tres`

```css
Button {
  color: #000;
}

Button.dark-mode {
  color: #fff;
}
```

## Base Syntax

This syntax should theoretically support every property in godot.

The `node_type` is used like a tag to decide which node to style (e.g. `Button` or `CheckBox`).

Properties are set with:

- `--{TYPE}-{PROPERTY}: {VALUE}`
  - `{TYPE}` - `colors`, `const`, `fonts`, `styles`
  - `{PROPERTY}` - anything the node_type supports
  - `{VALUE}` - anything `str2var()` supports, hex values, `url()`

Styles have a special syntax. First a type has to be specified:

- `--styles-{PROPERTY}-type: {VALUE}`
  - `{VALUE}` - `Empty`, `Flat`, `Line`, `Texture`
  - e.g `--styles-normal-type: Flat`

Then values of the style can be set with a `--styles` prefix:

- `--styles-{PROPERTY}-{INNER_PROPERTY}: {VALUE}`
  - e.g for a flat type: `--stypes-normal-border-width-left: 5`

External resources are specified with `url()`:

- `url(res://file.txt)` or `url(/file.txt)` - absolute path
- `url(file.txt)` - relative path to css file

`body` styles are treated as global and currently support:

- `font-family`: font `.tres` or `.ttf` file
- `font-size`: set font size of the default font (bug: does not get saved)

## Simplified Syntax

See [`tests/e2e/simple-syntax.css`](./tests/e2e/simple-syntax.css) for an example.

States can be selected with pseudo selectors like `Button:disabled` where `disabled` could be any state.
Right now only simplified syntax works with this selector.
If you use the base syntax like `--colors-font-color`, it will only apply to the normal state.

| CSS Property       | Godot Attribute    | Parameters/Type |
|--------------------|--------------------|------------|
| anti-aliasing      | anti_aliasing      | bool |
| anti-aliasing-size | anti_aliasing_size | float |
| background         | bg_color           | Color |
| border-blend       | border_blend       | bool |
| border-color       | border_color       | Color |
| border-radius      | corner_radius_*    | ints: `<top-left> <top-right> <bottom-right> <bottom-left>` |
| border-width       | border_width_*     | floats: `<top> <right> <bottom> <left>` |StyleBoxFlat
| color              | font_color         | Color |
| corner-detail      | corner_detail      | int |
| draw-center        | draw_center        | bool |
| expand-margin      | expand_margin      | floats: `<top> <right> <bottom> <left>` |StyleBoxFlat
| font-family        | font               | url: `url(res://path/to/font.ttf)` |
| gap                | separation         | int |
| padding            | content_margin_*   | floats: `<top> <right> <bottom> <left>` |
| shadow-color       | shadow_color       | Color |
| shadow-offset      | shadow_offset      | `<x> <y>` |
| shadow-size        | shadow_size        | int |
| skew               | skew               | `<x> <y>` |

See
[StyleBox](https://docs.godotengine.org/en/stable/classes/class_stylebox.html),
[StyleBoxFlat](https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html),
and [BoxContainer](https://docs.godotengine.org/en/stable/classes/class_boxcontainer.html),
for further reference on Godot attribute names.

## SCSS

See [this file](./themes/theme.scss) for an example with SCSS
