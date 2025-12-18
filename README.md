# Godot-CSS-Theme

Converts CSS to Godot Themes.

The goal is to make theme creating easier and more reusable. Using CSS you also have the advantage to use preprocessors
like [SASS](https://sass-lang.com/).

- `master` branch for godot 4
- `godot-3.x` branch for godot 3 (might be out-dated)

## How to use

- Download the plugin from the asset store
- Enable the plugin `Godot-CSS-Theme` in the Project Settings
- Create a `css` file and open it in the CSS tab (or some external tool)
- Write your styles in css. See syntax below.
- Saving it automatically creates a theme that can be used

### General Syntax

```css
/* Base syntax */
Button {
  --colors-font-color: #000;
  --colors-font-color-disabled: Color(0, 0, 0, 0.5);

  --const-hseparation: 5;

  --fonts-font: url(res://font.tres);

  --styles-normal-type: Flat;
  --styles-normal-bg-color: #fff;
}

/* Simplified syntax */
Button {
  color: #000;
  backgroud: #fff;
}
Button:disabled {
  color: Color(0, 0, 0, 0.5);
}
```

See [FEATURES](./FEATURES.md) for all supported features

## Contribute

If you see any problems or have any ideas for new features feel free to create an issue or a PR

Just make sure that new features are documented in `FEATURES.md` and that there is some kind of test for it.

- `base-syntax.css` - should contain all possible styles that can be set
- `simple-syntax.css` - should contain all simplified syntax that is supported

## Known Limitations / Problems

- Using colors with words like `red` or `blue` does not work. Either use hex `#000` or
  native gdscript `Color(0, 0, 0, 1)`
- Only plain numbers are allowed, no `px`, `rem` etc. supported
- Numbers cannot be shorted to e.g `.5`, must be `0.5`
