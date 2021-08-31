# Godot-CSS-Theme

Converts CSS to Godot Themes

## Supported Features

Generally all properties of a Godot Theme should be supported. The program uses custom css variables to set values.

The node_type is used like a tag to decide which node to style (e.g. `Button` or `CheckBox`).
The structure for a statement is `--{TYPE}-{PROPERTY}: {VALUE}` 
The only exception is for setting `styles`. They need a special type definition like `--styles-{PROPERTY}-type: {VALUE}`

### Syntax
 - `--{TYPE}-{PROPERTY}: {VALUE}`
    - `{TYPE}` - `colors`, `const`, `fonts`, `styles` 
    - `{PROPERTY}` - anything the node_type supports
 - `--styles-{PROPERTY}-type` values: `Empty`, `Flat`, `Line`, `Texture`
 - external resources are specified with `url()`.
    - `url(res://file.txt)` or `url(/file.txt)` - absolute path
    - `url(file.txt)` - relative path to css file


### Example:
```css
Button {
    --colors-font-color: #000;

    --const-hseparation: 5;

    --fonts-font: url(res://font.tres);

    --styles-normal-type: Flat;
    --styles-normal-bg-color: #FFF;
}
```

## How to use

`godot -s addons/godot-css-theme/convert.gd --input="res://theme.css" --output="res://theme.tres"`

## Problems
 - Colors only works with hex values right now
 - Godot might have to be closed before generating. Otherwise it might rewrite some values