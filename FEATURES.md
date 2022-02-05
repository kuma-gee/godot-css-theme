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

## Special Syntax
