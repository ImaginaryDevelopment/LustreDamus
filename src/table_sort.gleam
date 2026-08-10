import gleam/float
import gleam/int
import gleam/list
import gleam/order.{type Order}
import gleam/string

pub type Direction {
  Asc
  Desc
}

pub type EmptyPlacement {
  EmptiesFirst
  EmptiesLast
}

/// Where non-numeric, non-empty text sits relative to parsed numbers.
pub type TextPlacement {
  TextBeforeNumbers
  TextAfterNumbers
}

pub type SortKind {
  SortText
  SortNumeric
}

pub type SortSpec {
  SortSpec(
    column: Int,
    kind: SortKind,
    direction: Direction,
    empties: EmptyPlacement,
    texts: TextPlacement,
  )
}

pub type CellClass {
  EmptyCell
  NumberCell(Float)
  TextCell(String)
}

pub fn default_spec(column: Int, kind: SortKind) -> SortSpec {
  SortSpec(
    column:,
    kind:,
    direction: Asc,
    empties: EmptiesLast,
    texts: TextAfterNumbers,
  )
}

pub fn is_empty_cell(value: String) -> Bool {
  case string.trim(value) {
    "" | "-" | "--" | "—" | "–" -> True
    _ -> False
  }
}

pub fn classify_cell(value: String) -> CellClass {
  let trimmed = string.trim(value)
  case is_empty_cell(trimmed) {
    True -> EmptyCell
    False ->
      case parse_number(trimmed) {
        Ok(number) -> NumberCell(number)
        Error(_) -> TextCell(string.lowercase(trimmed))
      }
  }
}

/// Sort rows by a column. Short rows are treated as empty in missing cells.
pub fn sort_rows(
  rows: List(List(String)),
  spec: SortSpec,
) -> List(List(String)) {
  list.sort(rows, fn(left, right) {
    compare_cells(cell_at(left, spec.column), cell_at(right, spec.column), spec)
  })
}

pub fn column_looks_numeric(rows: List(List(String)), column: Int) -> Bool {
  let values = list.map(rows, fn(row) { cell_at(row, column) })
  let non_empty =
    list.filter(values, fn(value) { !is_empty_cell(value) })
  case non_empty {
    [] -> False
    _ -> {
      let numeric_count =
        list.fold(non_empty, 0, fn(count, value) {
          case parse_number(value) {
            Ok(_) -> count + 1
            Error(_) -> count
          }
        })
      numeric_count * 2 >= list.length(non_empty)
    }
  }
}

pub fn toggle_direction(spec: SortSpec) -> SortSpec {
  let direction = case spec.direction {
    Asc -> Desc
    Desc -> Asc
  }
  SortSpec(..spec, direction:)
}

fn compare_cells(left: String, right: String, spec: SortSpec) -> Order {
  case spec.kind {
    SortText -> compare_text(left, right, spec)
    SortNumeric -> compare_numeric(left, right, spec)
  }
}

fn compare_text(left: String, right: String, spec: SortSpec) -> Order {
  let left_empty = is_empty_cell(left)
  let right_empty = is_empty_cell(right)
  case left_empty, right_empty {
    True, True -> order.Eq
    True, False -> empty_order(spec.empties)
    False, True -> order.negate(empty_order(spec.empties))
    False, False -> {
      let base =
        string.compare(string.lowercase(string.trim(left)), string.lowercase(
          string.trim(right),
        ))
      apply_direction(base, spec.direction)
    }
  }
}

fn compare_numeric(left: String, right: String, spec: SortSpec) -> Order {
  let left_class = classify_cell(left)
  let right_class = classify_cell(right)
  let left_rank = bucket_rank(left_class, spec)
  let right_rank = bucket_rank(right_class, spec)
  case int.compare(left_rank, right_rank) {
    order.Eq ->
      case left_class, right_class {
        NumberCell(a), NumberCell(b) ->
          tie_break(
            apply_direction(float.compare(a, b), spec.direction),
            left,
            right,
          )
        TextCell(a), TextCell(b) ->
          tie_break(
            apply_direction(string.compare(a, b), spec.direction),
            left,
            right,
          )
        _, _ -> string.compare(left, right)
      }
    other -> other
  }
}

fn tie_break(primary: Order, left: String, right: String) -> Order {
  case primary {
    order.Eq -> string.compare(left, right)
    _ -> primary
  }
}

fn bucket_rank(class: CellClass, spec: SortSpec) -> Int {
  let buckets = case spec.texts, spec.empties {
    TextAfterNumbers, EmptiesLast -> [0, 1, 2]
    // number, text, empty
    TextBeforeNumbers, EmptiesLast -> [1, 0, 2]
    // text, number, empty
    TextAfterNumbers, EmptiesFirst -> [1, 2, 0]
    // empty, number, text
    TextBeforeNumbers, EmptiesFirst -> [2, 1, 0]
    // empty, text, number
  }
  let assert [number_rank, text_rank, empty_rank] = buckets
  case class {
    NumberCell(_) -> number_rank
    TextCell(_) -> text_rank
    EmptyCell -> empty_rank
  }
}

fn empty_order(empties: EmptyPlacement) -> Order {
  case empties {
    EmptiesFirst -> order.Lt
    EmptiesLast -> order.Gt
  }
}

fn apply_direction(base: Order, direction: Direction) -> Order {
  case direction {
    Asc -> base
    Desc -> order.negate(base)
  }
}

fn cell_at(row: List(String), column: Int) -> String {
  case list.drop(row, column) {
    [value, ..] -> value
    [] -> ""
  }
}

pub fn parse_number(value: String) -> Result(Float, Nil) {
  let trimmed =
    value
    |> string.trim
    |> strip_trailing_stars

  case parse_direct_number(trimmed) {
    Ok(number) -> Ok(number)
    Error(_) -> parse_embedded_number(trimmed)
  }
}

fn strip_trailing_stars(value: String) -> String {
  case string.ends_with(value, "*") {
    True -> strip_trailing_stars(string.drop_end(value, 1))
    False -> value
  }
}

fn parse_direct_number(value: String) -> Result(Float, Nil) {
  let value = case string.starts_with(value, "~") {
    True -> string.drop_start(value, 1)
    False -> value
  }
  parse_floatish(string.trim(value))
}

fn parse_embedded_number(value: String) -> Result(Float, Nil) {
  case find_number_token(value) {
    Ok(token) -> parse_direct_number(token)
    Error(_) -> Error(Nil)
  }
}

fn find_number_token(value: String) -> Result(String, Nil) {
  find_number_token_loop(string.to_graphemes(value), [], False, False)
}

fn find_number_token_loop(
  graphemes: List(String),
  acc: List(String),
  seen_digit: Bool,
  seen_dot: Bool,
) -> Result(String, Nil) {
  case graphemes {
    [] ->
      case seen_digit {
        True -> Ok(string.concat(list.reverse(acc)))
        False -> Error(Nil)
      }

    ["~", ..rest] if !seen_digit && acc == [] ->
      find_number_token_loop(rest, ["~"], False, False)

    [g, ..rest] ->
      case g {
        "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" ->
          find_number_token_loop(rest, [g, ..acc], True, seen_dot)

        "." if seen_digit && !seen_dot ->
          find_number_token_loop(rest, [g, ..acc], True, True)

        _ if seen_digit -> Ok(string.concat(list.reverse(acc)))

        _ if acc == ["~"] -> find_number_token_loop(rest, [], False, False)

        _ -> find_number_token_loop(rest, [], False, False)
      }
  }
}

fn parse_floatish(value: String) -> Result(Float, Nil) {
  case float.parse(value) {
    Ok(number) -> Ok(number)
    Error(_) ->
      case int.parse(value) {
        Ok(number) -> Ok(int.to_float(number))
        Error(_) -> Error(Nil)
      }
  }
}
