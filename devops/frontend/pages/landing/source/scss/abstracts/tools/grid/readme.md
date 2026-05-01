# Grid

## Unit

- the basic `unit` of te grid is the `8px` square unit;
- multiples of mini units compose the dimensions of columns, rows, boxes, along with their margins and padding
- margins and paddings are always in fixed mini unit multiples

## Fundamentals

### Columns and rows

- Columns and rows create key lines that are essential for visual rhythm, especially for typography
- Construct columns by either dividing a space into a fluid grid, or by tiling fixed boxes in multiples.

#### Fluid grid

- A fluid grid divides space by twos.
- Within a breakpoint, the column count is constant, and unit size scales with screen size.
- Choose a column count by starting with one, then divide by two as needed.

#### Fixed grid

- A fixed grid starts with a fixed unit size from the sizing scale, then tiles and wraps as needed, like text.
- Multiply box sizes by two and mix them together.

- When tiling fixed boxes, the column count is not known in advance, but a grid emerges visually due to the use of a consistent sizing scale.
- On breakpoint boundaries, fixed sizing scales match column sizes.

#### Hybrid grid

- Hybrid grids are also frequent in practice, and hybrid boxes have properties of both.

### Margins

### Paddings

### Gutters

### Breakpoints
