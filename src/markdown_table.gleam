import gleam/list
import gleam/string

pub type Table {
  Table(title: String, headers: List(String), rows: List(List(String)))
}

/// Pull GFM-style pipe tables out of mixed Markdown, ignoring surrounding prose.
pub fn extract_tables(markdown: String) -> List(Table) {
  markdown
  |> string.split("\n")
  |> walk([], "", [])
  |> list.reverse
}

pub fn filter_tables(tables: List(Table), query: String) -> List(Table) {
  let needle = string.lowercase(string.trim(query))
  case needle {
    "" -> tables
    _ ->
      list.filter_map(tables, fn(table) {
        let rows =
          list.filter(table.rows, fn(row) {
            list.any(row, fn(cell) {
              string.contains(string.lowercase(cell), needle)
            })
          })
        case rows {
          [] -> Error(Nil)
          _ -> Ok(Table(..table, rows:))
        }
      })
  }
}

fn walk(
  lines: List(String),
  tables: List(Table),
  heading: String,
  block: List(String),
) -> List(Table) {
  case lines {
    [] ->
      case parse_block(heading, list.reverse(block)) {
        Ok(table) -> [table, ..tables]
        Error(_) -> tables
      }

    [line, ..rest] ->
      case is_table_line(line) {
        True -> walk(rest, tables, heading, [line, ..block])
        False -> {
          let tables = case parse_block(heading, list.reverse(block)) {
            Ok(table) -> [table, ..tables]
            Error(_) -> tables
          }
          walk(rest, tables, update_heading(heading, line), [])
        }
      }
  }
}

fn update_heading(current: String, line: String) -> String {
  let trimmed = string.trim(line)
  case trimmed {
    "## " <> title -> string.trim(title)
    "# " <> title -> string.trim(title)
    "### " <> title -> string.trim(title)
    _ -> current
  }
}

fn is_table_line(line: String) -> Bool {
  let trimmed = string.trim(line)
  string.starts_with(trimmed, "|")
}

fn parse_block(title: String, lines: List(String)) -> Result(Table, Nil) {
  case list.map(lines, parse_row) {
    [headers, second, ..rest] -> {
      let rows = case is_separator_row(second) {
        True -> rest
        False -> [second, ..rest]
      }
      let rows = list.filter(rows, fn(row) { !is_separator_row(row) })
      case headers {
        [] -> Error(Nil)
        _ ->
          Ok(Table(
            title: fallback_title(title, headers),
            headers:,
            rows:,
          ))
      }
    }
    [headers] ->
      case headers {
        [] -> Error(Nil)
        _ -> Ok(Table(title: fallback_title(title, headers), headers:, rows: []))
      }
    [] -> Error(Nil)
  }
}

fn fallback_title(title: String, headers: List(String)) -> String {
  case title {
    "" ->
      case headers {
        [first, ..] -> first
        [] -> "Table"
      }
    _ -> title
  }
}

fn parse_row(line: String) -> List(String) {
  let trimmed = string.trim(line)
  let without_ends = trim_edge_pipes(trimmed)
  without_ends
  |> string.split("|")
  |> list.map(string.trim)
}

fn trim_edge_pipes(line: String) -> String {
  let line = case string.starts_with(line, "|") {
    True -> string.drop_start(line, 1)
    False -> line
  }
  case string.ends_with(line, "|") {
    True -> string.drop_end(line, 1)
    False -> line
  }
}

fn is_separator_row(cells: List(String)) -> Bool {
  case cells {
    [] -> False
    _ -> list.all(cells, is_separator_cell)
  }
}

fn is_separator_cell(cell: String) -> Bool {
  let trimmed = string.trim(cell)
  case trimmed {
    "" -> False
    _ -> {
      let stripped =
        trimmed
        |> string.replace(":", "")
        |> string.replace("-", "")
        |> string.replace(" ", "")
      stripped == "" && string.contains(trimmed, "-")
    }
  }
}
