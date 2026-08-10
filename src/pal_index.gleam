import gleam/dict.{type Dict}
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string
import markdown_table.{type Table}
import table_format.{type TableFormatter, FormattedCell}
import table_sort

/// Parse Name → Element(s) from the Breeding Sheet "Full list" table.
pub fn parse_elements_index(markdown: String) -> Dict(String, String) {
  markdown
  |> markdown_table.extract_tables
  |> list.find(is_full_list_table)
  |> option.from_result
  |> option.map(index_from_table)
  |> option.unwrap(dict.new())
}

pub fn lookup_elements(
  index: Dict(String, String),
  display_name: String,
) -> Option(String) {
  let normalized = normalize_pal_label(display_name)
  case normalized {
    "" -> None
    _ ->
      case dict.get(index, normalized) {
        Ok(elements) -> Some(elements)
        Error(_) ->
          case dict.get(index, strip_parenthetical(normalized)) {
            Ok(elements) -> Some(elements)
            Error(_) -> None
          }
      }
  }
}

pub fn with_pal_element_tooltips(
  formatter: TableFormatter,
  index: Dict(String, String),
) -> TableFormatter {
  case dict.size(index) {
    0 -> formatter
    _ ->
      table_format.decorate(formatter, fn(ctx, cell) {
        case is_pal_name_header(ctx.header) {
          False -> cell
          True ->
            case lookup_elements(index, ctx.value) {
              Some(elements) ->
                FormattedCell(
                  ..cell,
                  class_name: append_class(cell.class_name, "cell-pal"),
                  title: Some(elements),
                )
              None -> cell
            }
        }
      })
  }
}

pub fn normalize_pal_label(value: String) -> String {
  value
  |> string.trim
  |> strip_markdown_bold
  |> string.trim
}

fn strip_parenthetical(name: String) -> String {
  case string.split(name, " (") {
    [base, suffix] ->
      case string.ends_with(suffix, ")") {
        True -> string.trim(base)
        False -> name
      }
    _ -> name
  }
}

fn strip_markdown_bold(value: String) -> String {
  value
  |> string.replace("**", "")
  |> string.replace("__", "")
}

fn is_full_list_table(table: Table) -> Bool {
  let title = string.lowercase(table.title)
  string.contains(title, "full list")
  || {
    has_header(table, "Name") && has_header(table, "Element(s)")
  }
}

fn has_header(table: Table, wanted: String) -> Bool {
  list.any(table.headers, fn(header) { header == wanted })
}

fn index_from_table(table: Table) -> Dict(String, String) {
  let name_i = column_index(table.headers, "Name")
  let element_i = column_index(table.headers, "Element(s)")
  case name_i, element_i {
    Ok(name_col), Ok(element_col) ->
      list.fold(table.rows, dict.new(), fn(acc, row) {
        let name = normalize_pal_label(cell_at(row, name_col))
        let elements = string.trim(cell_at(row, element_col))
        case name, elements {
          "", _ -> acc
          _, "" -> acc
          _, _ ->
            case table_sort.is_empty_cell(elements) {
              True -> acc
              False -> dict.insert(acc, name, elements)
            }
        }
      })
    _, _ -> dict.new()
  }
}

fn column_index(headers: List(String), wanted: String) -> Result(Int, Nil) {
  column_index_loop(headers, wanted, 0)
}

fn column_index_loop(
  headers: List(String),
  wanted: String,
  index: Int,
) -> Result(Int, Nil) {
  case headers {
    [] -> Error(Nil)
    [header, ..] if header == wanted -> Ok(index)
    [_, ..rest] -> column_index_loop(rest, wanted, index + 1)
  }
}

fn cell_at(row: List(String), column: Int) -> String {
  case list.drop(row, column) {
    [value, ..] -> value
    [] -> ""
  }
}

fn is_pal_name_header(header: String) -> Bool {
  case header {
    "Pal" | "Mount" | "Name" | "Pick" -> True
    _ -> False
  }
}

fn append_class(existing: String, next: String) -> String {
  case existing {
    "" -> next
    _ -> existing <> " " <> next
  }
}
