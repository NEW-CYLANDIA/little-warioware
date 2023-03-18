# Style guide

## Repository structure

- `.gd`, `.tres` and `.tscn` files should use `snake_case`
- There is no hard rules for other assets, but try to keep the repository somewhat clean
- The repository is structured as follows
  ```
  .
  ├── audio/
  ├── docs/
  ├── graphics/
  ├── microgames/
  │   ├── microgame_1/
  │   └── microgame_2/
  ├── src/
  │   ├── core/
  │   ├── menus/
  │   ├── microgames/
  │   └── play_session/
  └── project.godot
  ```
  - Scenes and GDScript files related to the entire game should live under `src/`
  - Other assets related to the entire game should live under the right folder depending on their
    type (`audio/`, `graphics/`, etc.)
  - Everything related to a specific microgame should live in its own directory under `microgames/`

## GDScript

### Formatting rules

- Indent with tabs, not spaces
- Leave two empty lines between methods
- Keep lines under 100 columns
- Vertical space is free, space out your code

### Naming conventions

- Class names should use `PascalCase`, everything else should use `snake_case`
  - When storing a reference to a node, convert its `PascalCase` name to `snake_case`
- Use comprehensive variable names, refrain from single letter ones unless they're obvious (e.g.
  `i` for indexes, `x` and `y` for coordinates, ...)
- Do not prefix methods or class variables with `_`

### Static vs. dynamic typing

- Always prefer static types to dynamic types
  ```gdscript
  # Do this
  func add(n : int, m : int) -> int:
      return n + m

  # Not this
  func add(n, m):
      return n + m
  ```

### Other general considerations

- Try and comment your code
- Write small and targeted method, not long and complicated ones
- Do not leave large blocks of commented code in the codebase
- Do not leave useless or debugging print calls in the codebase
