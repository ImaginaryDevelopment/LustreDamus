import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import table_sort

/// Context passed to cell formatting delegates at render time.
/// Sort and filter always use the raw `value`; formatting never changes data.
pub type FormatContext {
  FormatContext(
    table_title: String,
    headers: List(String),
    column: Int,
    header: String,
    row_index: Int,
    row: List(String),
    value: String,
  )
}

pub type FormattedCell {
  FormattedCell(text: String, class_name: String, title: Option(String))
}

pub type CellFormatter =
  fn(FormatContext) -> FormattedCell

/// Transform an already-formatted cell. Useful for stacking plug-ins.
pub type CellDecorator =
  fn(FormatContext, FormattedCell) -> FormattedCell

pub type TableFormatter {
  TableFormatter(format_cell: CellFormatter)
}

pub fn plain() -> TableFormatter {
  TableFormatter(format_cell: identity)
}

pub fn identity(ctx: FormatContext) -> FormattedCell {
  FormattedCell(text: ctx.value, class_name: "", title: None)
}

/// Replace the cell formatter entirely.
pub fn with_cell(
  _formatter: TableFormatter,
  format_cell: CellFormatter,
) -> TableFormatter {
  TableFormatter(format_cell:)
}

/// Stack a decorator on top of the current cell formatter.
pub fn decorate(
  formatter: TableFormatter,
  decorator: CellDecorator,
) -> TableFormatter {
  let base = formatter.format_cell
  TableFormatter(format_cell: fn(ctx) { decorator(ctx, base(ctx)) })
}

/// Apply several decorators left-to-right.
pub fn decorate_all(
  formatter: TableFormatter,
  decorators: List(CellDecorator),
) -> TableFormatter {
  list.fold(decorators, formatter, decorate)
}

pub fn format_cell(
  formatter: TableFormatter,
  ctx: FormatContext,
) -> FormattedCell {
  formatter.format_cell(ctx)
}

pub fn make_context(
  table_title: String,
  headers: List(String),
  column: Int,
  row_index: Int,
  row: List(String),
) -> FormatContext {
  let header = case list.drop(headers, column) {
    [name, ..] -> name
    [] -> ""
  }
  let value = case list.drop(row, column) {
    [cell, ..] -> cell
    [] -> ""
  }
  FormatContext(
    table_title:,
    headers:,
    column:,
    header:,
    row_index:,
    row:,
    value:,
  )
}

/// Marks empty fillers (`-`, `—`, blank, …) with `cell-empty`.
pub fn style_empty_cells(
  ctx: FormatContext,
  cell: FormattedCell,
) -> FormattedCell {
  case table_sort.is_empty_cell(ctx.value) {
    True ->
      FormattedCell(
        ..cell,
        class_name: append_class(cell.class_name, "cell-empty"),
        title: case cell.title {
          Some(_) -> cell.title
          None -> Some("Empty / unknown")
        },
      )
    False -> cell
  }
}

/// Marks values with a leading or embedded `~` number as approximate.
pub fn style_approximate_numbers(
  ctx: FormatContext,
  cell: FormattedCell,
) -> FormattedCell {
  case string.contains(ctx.value, "~") {
    True ->
      FormattedCell(
        ..cell,
        class_name: append_class(cell.class_name, "cell-approx"),
        title: case cell.title {
          Some(_) -> cell.title
          None -> Some("Approximate value")
        },
      )
    False -> cell
  }
}

fn append_class(existing: String, next: String) -> String {
  case existing {
    "" -> next
    _ -> existing <> " " <> next
  }
}
