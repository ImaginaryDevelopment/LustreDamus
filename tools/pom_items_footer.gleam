pub fn lookup(name: String) -> Option(ItemInfo) {
  let key = normalize(alias_target(normalize(name)))
  case key {
    "" -> None
    _ ->
      list.find(items(), fn(item) { normalize(item.name) == key })
      |> option.from_result
  }
}

pub fn tooltip(name: String) -> Option(String) {
  case lookup(name) {
    None -> None
    Some(item) -> {
      let body = case item.stats {
        "" -> "Quest / combine reagent"
        stats -> stats
      }
      case item.classes {
        "ALL" | "" -> Some(body)
        classes -> Some(classes <> " — " <> body)
      }
    }
  }
}

/// Restricted classes only (None when ALL / unknown).
pub fn classes_for(name: String) -> Option(String) {
  case lookup(name) {
    Some(ItemInfo(_, "ALL", _)) -> None
    Some(ItemInfo(_, "", _)) -> None
    Some(ItemInfo(_, classes, _)) -> Some(classes)
    None -> None
  }
}

pub fn normalize(value: String) -> String {
  value
  |> string.trim
  |> string.replace("**", "")
  |> string.replace("__", "")
  |> string.trim
}

/// Hover stats on Item / Set cells (and any cell that exactly matches a known item).
pub fn with_item_tooltips(formatter: TableFormatter) -> TableFormatter {
  table_format.decorate(formatter, fn(ctx, cell) {
    case should_tooltip(ctx.header, ctx.value) {
      False -> cell
      True ->
        case tooltip(ctx.value) {
          Some(text) ->
            FormattedCell(
              ..cell,
              class_name: append_class(cell.class_name, "cell-item"),
              title: Some(text),
            )
          None -> cell
        }
    }
  })
}

fn should_tooltip(header: String, value: String) -> Bool {
  let h = string.lowercase(string.trim(header))
  case h {
    "item" | "set" -> True
    _ ->
      case lookup(value) {
        Some(_) -> True
        None -> False
      }
  }
}

fn append_class(existing: String, next: String) -> String {
  case existing {
    "" -> next
    _ -> existing <> " " <> next
  }
}

/// Add or fill a Classes column from IdleQuest restrictions (blank when ALL).
pub fn with_classes_on_item_rows(tables: List(Table)) -> List(Table) {
  list.map(tables, enrich_table)
}

fn enrich_table(table: Table) -> Table {
  case column_index(table.headers, "Item") {
    Error(_) -> table
    Ok(item_i) ->
      case class_column_index(table.headers) {
        Ok(class_i) -> fill_classes(table, item_i, class_i)
        Error(_) -> insert_classes(table, item_i)
      }
  }
}

fn class_column_index(headers: List(String)) -> Result(Int, Nil) {
  case column_index(headers, "Classes") {
    Ok(i) -> Ok(i)
    Error(_) -> column_index(headers, "Class")
  }
}

fn fill_classes(table: Table, item_i: Int, class_i: Int) -> Table {
  let rows =
    list.map(table.rows, fn(row) {
      let current = cell_at(row, class_i)
      case table_sort.is_empty_cell(current) || string.trim(current) == "" {
        False -> row
        True ->
          case classes_for(cell_at(row, item_i)) {
            None -> row
            Some(classes) -> set_cell(row, class_i, classes)
          }
      }
    })
  MdTable(..table, rows:)
}

fn insert_classes(table: Table, item_i: Int) -> Table {
  let headers = insert_at(table.headers, item_i + 1, "Classes")
  let rows =
    list.map(table.rows, fn(row) {
      let classes = case classes_for(cell_at(row, item_i)) {
        Some(c) -> c
        None -> ""
      }
      insert_at(row, item_i + 1, classes)
    })
  MdTable(..table, headers:, rows:)
}

fn column_index(headers: List(String), wanted: String) -> Result(Int, Nil) {
  list.index_map(headers, fn(header, i) { #(header, i) })
  |> list.find(fn(pair) {
    let #(header, _) = pair
    string.lowercase(string.trim(header)) == string.lowercase(wanted)
  })
  |> result_map_second
}

fn result_map_second(found: Result(#(String, Int), Nil)) -> Result(Int, Nil) {
  case found {
    Ok(#(_, i)) -> Ok(i)
    Error(Nil) -> Error(Nil)
  }
}

fn cell_at(row: List(String), index: Int) -> String {
  case list.drop(row, index) {
    [cell, ..] -> cell
    [] -> ""
  }
}

fn set_cell(row: List(String), index: Int, value: String) -> List(String) {
  list.index_map(row, fn(cell, i) {
    case i == index {
      True -> value
      False -> cell
    }
  })
}

fn insert_at(items: List(String), index: Int, value: String) -> List(String) {
  let #(before, after) = list.split(items, index)
  list.append(before, [value, ..after])
}
