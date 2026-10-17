import gleam/dict.{type Dict}
import gleam/http/response.{type Response}
import gleam/int
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/order
import gleam/string
import lustre
import lustre/attribute
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import character_tracker.{type Character, type Form as CharForm}
import epic_quests
import markdown_table.{type Table}
import pal_index
import pom_deck
import pom_items
import raid_targets
import rsvp
import samples.{type Sample}
import storage
import table_format.{type FormattedCell, type TableFormatter}
import table_sort.{
  type Direction, type EmptyPlacement, type SortKind, type SortSpec,
  type TableSort, type TextPlacement, Asc, Desc, EmptiesFirst, EmptiesLast,
  SortNumeric, SortText, TextAfterNumbers, TextBeforeNumbers,
}

pub type Page {
  PastePage
  SamplePage(Sample)
}

pub type SortSlot {
  Primary
  Secondary
}

pub type Model {
  Model(
    page: Page,
    markdown: String,
    filter: String,
    loading: Bool,
    error: Option(String),
    sorts: Dict(String, TableSort),
    optional_columns: Dict(String, Dict(String, Bool)),
    value_filters: Dict(String, Dict(String, Dict(String, Bool))),
    /// When True, hide table rows marked IdleQuest **0%** spawn chance.
    hide_zero_spawn: Bool,
    pal_elements: Dict(String, String),
    zone_search: String,
    zone_search_open: Bool,
    /// Plane of Mischief deck cards owned (localStorage-backed).
    pom_cards: Dict(String, Bool),
    /// Raid targets beaten (localStorage-backed).
    raid_beaten: Dict(String, Bool),
    /// Raid target loot need status (localStorage-backed).
    raid_status: Dict(String, raid_targets.Status),
    /// Raid target group vs raid clear (localStorage-backed).
    raid_kill_mode: Dict(String, raid_targets.KillMode),
    /// Collapsed raid expansion / zone section keys (session only).
    raid_collapsed: Dict(String, Bool),
    /// Epic quest checklist steps done (localStorage-backed).
    epic_done: Dict(String, Bool),
    /// Class filter on Epic Quests page (`""` = all).
    epic_class_filter: String,
    /// Account characters (localStorage-backed).
    characters: List(Character),
    char_form: CharForm,
    char_editing: Option(String),
    char_error: Option(String),
  )
}

pub type Msg {
  UserChosePaste
  UserChoseSample(Sample)
  UserOpenedZoneSearch
  UserClosedZoneSearch
  UserUpdatedZoneSearch(String)
  UserUpdatedMarkdown(String)
  UserUpdatedFilter(String)
  UserClickedColumn(String, Int)
  UserSetSortKind(String, SortSlot, SortKind)
  UserSetDirection(String, SortSlot, Direction)
  UserSetEmptyPlacement(String, SortSlot, EmptyPlacement)
  UserSetTextPlacement(String, SortSlot, TextPlacement)
  UserClearSecondary(String)
  UserClearSort(String)
  UserToggledOptionalColumn(String, String, Bool)
  UserToggledValueFilter(String, String, String, Bool)
  UserToggledHideZeroSpawn(Bool)
  UserToggledPomCard(String, Bool)
  UserClearedPomCards
  /// Spend one exact recipe combination (card ids), not an item name.
  UserCombinedPomRecipe(List(String))
  UserToggledRaidBeaten(String, Bool)
  UserSetRaidStatus(String, String)
  UserSetRaidKillMode(String, String)
  UserClearedRaidBeaten
  UserToggledRaidSection(String)
  UserToggledEpicStep(String, Bool)
  UserSetEpicClassFilter(String)
  UserClearedEpicQuest(String)
  UserClearedAllEpicSteps
  UserUpdatedCharName(String)
  UserUpdatedCharClass(String)
  UserUpdatedCharLevel(String)
  UserUpdatedCharRace(String)
  UserUpdatedCharReligion(String)
  UserToggledCharHasEpic(Bool)
  UserSavedCharacter
  UserEditCharacter(String)
  UserDeleteCharacter(String)
  UserCancelCharEdit
  SampleLoaded(Result(String, String))
  PalIndexLoaded(Result(String, String))
}

pub fn main() -> Nil {
  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", Nil)
  Nil
}

fn init(_flags: Nil) -> #(Model, Effect(Msg)) {
  #(
    Model(
      page: PastePage,
      markdown: "",
      filter: "",
      loading: False,
      error: None,
      sorts: dict.new(),
      optional_columns: dict.new(),
      value_filters: dict.new(),
      hide_zero_spawn: False,
      pal_elements: dict.new(),
      zone_search: "",
      zone_search_open: False,
      pom_cards: pom_deck.decode_owned(storage.get_item(pom_deck.storage_key)),
      raid_beaten: raid_targets.decode(
        storage.get_item(raid_targets.storage_key),
      ),
      raid_status: raid_targets.decode_status(
        storage.get_item(raid_targets.status_storage_key),
      ),
      raid_kill_mode: raid_targets.decode_kill_mode(
        storage.get_item(raid_targets.kill_mode_storage_key),
      ),
      raid_collapsed: dict.new(),
      epic_done: epic_quests.decode(storage.get_item(epic_quests.storage_key)),
      epic_class_filter: "",
      characters: character_tracker.decode(
        storage.get_item(character_tracker.storage_key),
      ),
      char_form: character_tracker.empty_form(),
      char_editing: None,
      char_error: None,
    ),
    effect.none(),
  )
}

fn update(model: Model, msg: Msg) -> #(Model, Effect(Msg)) {
  case msg {
    UserChosePaste -> #(
      Model(
        ..model,
        page: PastePage,
        error: None,
        loading: False,
        zone_search_open: False,
      ),
      effect.none(),
    )

    UserChoseSample(sample) -> {
      let sorts = case samples.is_raid_targets(sample) {
        True -> raid_targets.default_sorts()
        False -> dict.new()
      }
      let base =
        Model(
          page: SamplePage(sample),
          markdown: "",
          filter: "",
          loading: False,
          error: None,
          sorts:,
          optional_columns: dict.new(),
          value_filters: dict.new(),
          hide_zero_spawn: False,
          pal_elements: model.pal_elements,
          zone_search: model.zone_search,
          zone_search_open: False,
          pom_cards: model.pom_cards,
          raid_beaten: model.raid_beaten,
          raid_status: model.raid_status,
          raid_kill_mode: model.raid_kill_mode,
          raid_collapsed: model.raid_collapsed,
          epic_done: model.epic_done,
          epic_class_filter: model.epic_class_filter,
          characters: model.characters,
          char_form: model.char_form,
          char_editing: model.char_editing,
          char_error: None,
        )
      case samples.is_character_tracker(sample) {
        True -> #(base, effect.none())
        False -> #(
          Model(..base, loading: True),
          effect.batch([
            load_sample(samples.url(sample)),
            case samples.is_palworld(sample) {
              True -> ensure_pal_index(model.pal_elements)
              False -> effect.none()
            },
          ]),
        )
      }
    }

    UserOpenedZoneSearch ->
      case by_class_is_open(model) {
        True -> #(model, effect.none())
        False ->
          case model.zone_search_open {
            True -> #(Model(..model, zone_search_open: False), effect.none())
            False -> {
              let sample = samples.zone_index_sample()
              #(
                Model(
                  page: SamplePage(sample),
                  markdown: samples.zone_index_markdown(),
                  filter: "",
                  loading: False,
                  error: None,
                  sorts: dict.new(),
                  optional_columns: dict.new(),
                  value_filters: dict.new(),
                  hide_zero_spawn: False,
                  pal_elements: model.pal_elements,
                  zone_search: "",
                  zone_search_open: True,
                  pom_cards: model.pom_cards,
                  raid_beaten: model.raid_beaten,
                  raid_status: model.raid_status,
                  raid_kill_mode: model.raid_kill_mode,
                  raid_collapsed: model.raid_collapsed,
                  epic_done: model.epic_done,
                  epic_class_filter: model.epic_class_filter,
                  characters: model.characters,
                  char_form: model.char_form,
                  char_editing: model.char_editing,
                  char_error: model.char_error,
                ),
                effect.none(),
              )
            }
          }
      }

    UserClosedZoneSearch -> #(
      Model(..model, zone_search_open: False),
      effect.none(),
    )

    UserUpdatedZoneSearch(zone_search) -> #(
      Model(
        ..model,
        zone_search: zone_search,
        zone_search_open: True,
        filter: zone_search,
      ),
      effect.none(),
    )

    UserUpdatedMarkdown(markdown) -> #(
      Model(
        ..model,
        markdown:,
        error: None,
        sorts: dict.new(),
        optional_columns: dict.new(),
        value_filters: dict.new(),
      ),
      effect.none(),
    )

    UserUpdatedFilter(filter) -> #(Model(..model, filter:), effect.none())

    UserClickedColumn(table_id, column) -> #(
      Model(..model, sorts: update_column_sort(model, table_id, column)),
      effect.none(),
    )

    UserSetSortKind(table_id, slot, kind) -> #(
      Model(
        ..model,
        sorts: update_slot(model.sorts, table_id, slot, fn(spec) {
          table_sort.SortSpec(..spec, kind:, direction: Asc)
        }),
      ),
      effect.none(),
    )

    UserSetDirection(table_id, slot, direction) -> #(
      Model(
        ..model,
        sorts: update_slot(model.sorts, table_id, slot, fn(spec) {
          table_sort.SortSpec(..spec, direction:)
        }),
      ),
      effect.none(),
    )

    UserSetEmptyPlacement(table_id, slot, empties) -> #(
      Model(
        ..model,
        sorts: update_slot(model.sorts, table_id, slot, fn(spec) {
          table_sort.SortSpec(..spec, empties:)
        }),
      ),
      effect.none(),
    )

    UserSetTextPlacement(table_id, slot, texts) -> #(
      Model(
        ..model,
        sorts: update_slot(model.sorts, table_id, slot, fn(spec) {
          table_sort.SortSpec(..spec, texts:)
        }),
      ),
      effect.none(),
    )

    UserClearSecondary(table_id) -> #(
      Model(..model, sorts: case dict.get(model.sorts, table_id) {
        Ok(table_sort.TableSort(primary:, secondary: _)) ->
          dict.insert(
            model.sorts,
            table_id,
            table_sort.TableSort(primary:, secondary: None),
          )
        Error(_) -> model.sorts
      }),
      effect.none(),
    )

    UserClearSort(table_id) -> #(
      Model(..model, sorts: dict.delete(model.sorts, table_id)),
      effect.none(),
    )

    UserToggledOptionalColumn(table_id, header, shown) -> #(
      Model(
        ..model,
        optional_columns: set_optional_column(
          model.optional_columns,
          table_id,
          header,
          shown,
        ),
      ),
      effect.none(),
    )

    UserToggledValueFilter(table_id, header, value, shown) -> #(
      Model(
        ..model,
        value_filters: set_value_filter(
          model.value_filters,
          table_id,
          header,
          value,
          shown,
        ),
      ),
      effect.none(),
    )

    UserToggledHideZeroSpawn(hide_zero_spawn) -> #(
      Model(..model, hide_zero_spawn:),
      effect.none(),
    )

    UserToggledPomCard(id, on) -> {
      let pom_cards = pom_deck.toggle(model.pom_cards, id, on)
      storage.set_item(pom_deck.storage_key, pom_deck.encode_owned(pom_cards))
      #(Model(..model, pom_cards:), effect.none())
    }

    UserClearedPomCards -> {
      storage.set_item(pom_deck.storage_key, "")
      #(Model(..model, pom_cards: dict.new()), effect.none())
    }

    UserCombinedPomRecipe(needs) -> {
      let pom_cards = pom_deck.combine(model.pom_cards, needs)
      storage.set_item(pom_deck.storage_key, pom_deck.encode_owned(pom_cards))
      #(Model(..model, pom_cards:), effect.none())
    }

    UserToggledRaidBeaten(id, on) -> {
      let raid_beaten = raid_targets.toggle(model.raid_beaten, id, on)
      storage.set_item(
        raid_targets.storage_key,
        raid_targets.encode(raid_beaten),
      )
      #(Model(..model, raid_beaten:), effect.none())
    }

    UserSetRaidStatus(id, raw) -> {
      let status = case raid_targets.parse_status(raw) {
        Ok(s) -> s
        Error(_) -> raid_targets.Unknown
      }
      let raid_status = raid_targets.set_status(model.raid_status, id, status)
      storage.set_item(
        raid_targets.status_storage_key,
        raid_targets.encode_status(raid_status),
      )
      #(Model(..model, raid_status:), effect.none())
    }

    UserSetRaidKillMode(id, raw) -> {
      let mode = case raid_targets.parse_kill_mode(raw) {
        Ok(m) -> m
        Error(_) -> raid_targets.KillUnknown
      }
      let raid_kill_mode =
        raid_targets.set_kill_mode(model.raid_kill_mode, id, mode)
      storage.set_item(
        raid_targets.kill_mode_storage_key,
        raid_targets.encode_kill_mode(raid_kill_mode),
      )
      #(Model(..model, raid_kill_mode:), effect.none())
    }

    UserClearedRaidBeaten -> {
      storage.set_item(raid_targets.storage_key, "")
      #(Model(..model, raid_beaten: dict.new()), effect.none())
    }

    UserToggledRaidSection(key) -> {
      let raid_collapsed = case dict.get(model.raid_collapsed, key) {
        Ok(True) -> dict.delete(model.raid_collapsed, key)
        _ -> dict.insert(model.raid_collapsed, key, True)
      }
      #(Model(..model, raid_collapsed:), effect.none())
    }

    UserToggledEpicStep(id, on) -> {
      let epic_done = epic_quests.toggle(model.epic_done, id, on)
      storage.set_item(epic_quests.storage_key, epic_quests.encode(epic_done))
      #(Model(..model, epic_done:), effect.none())
    }

    UserSetEpicClassFilter(filter) -> #(
      Model(..model, epic_class_filter: filter),
      effect.none(),
    )

    UserClearedEpicQuest(class_id) -> {
      let epic_done = case epic_quests.find_quest(class_id) {
        Ok(quest) -> epic_quests.clear_quest(model.epic_done, quest)
        Error(_) -> model.epic_done
      }
      storage.set_item(epic_quests.storage_key, epic_quests.encode(epic_done))
      #(Model(..model, epic_done:), effect.none())
    }

    UserClearedAllEpicSteps -> {
      storage.set_item(epic_quests.storage_key, "")
      #(Model(..model, epic_done: dict.new()), effect.none())
    }

    UserUpdatedCharName(name) -> #(
      Model(
        ..model,
        char_form: character_tracker.set_name(model.char_form, name),
        char_error: None,
      ),
      effect.none(),
    )

    UserUpdatedCharClass(class) -> #(
      Model(
        ..model,
        char_form: character_tracker.set_class(model.char_form, class),
        char_error: None,
      ),
      effect.none(),
    )

    UserUpdatedCharLevel(level) -> #(
      Model(
        ..model,
        char_form: character_tracker.set_level(model.char_form, level),
        char_error: None,
      ),
      effect.none(),
    )

    UserUpdatedCharRace(race) -> #(
      Model(
        ..model,
        char_form: character_tracker.set_race(model.char_form, race),
        char_error: None,
      ),
      effect.none(),
    )

    UserUpdatedCharReligion(religion) -> #(
      Model(
        ..model,
        char_form: character_tracker.set_religion(model.char_form, religion),
        char_error: None,
      ),
      effect.none(),
    )

    UserToggledCharHasEpic(has_epic) -> #(
      Model(
        ..model,
        char_form: character_tracker.set_has_epic(model.char_form, has_epic),
        char_error: None,
      ),
      effect.none(),
    )

    UserSavedCharacter ->
      case character_tracker.validate(model.char_form) {
        Error(message) -> #(
          Model(..model, char_error: Some(message)),
          effect.none(),
        )
        Ok(#(name, class, level, race, religion, has_epic)) -> {
          let editing = case model.char_editing {
            Some(id) -> id
            None -> ""
          }
          let id = case editing {
            "" -> storage.new_id()
            existing -> existing
          }
          let characters =
            character_tracker.upsert(
              model.characters,
              editing,
              id,
              name,
              class,
              level,
              race,
              religion,
              has_epic,
            )
          storage.set_item(
            character_tracker.storage_key,
            character_tracker.encode(characters),
          )
          #(
            Model(
              ..model,
              characters:,
              char_form: character_tracker.empty_form(),
              char_editing: None,
              char_error: None,
            ),
            effect.none(),
          )
        }
      }

    UserEditCharacter(id) ->
      case character_tracker.find(model.characters, id) {
        Error(_) -> #(model, effect.none())
        Ok(character) -> #(
          Model(
            ..model,
            char_form: character_tracker.form_from_character(character),
            char_editing: Some(id),
            char_error: None,
          ),
          effect.none(),
        )
      }

    UserDeleteCharacter(id) -> {
      let characters = character_tracker.remove(model.characters, id)
      storage.set_item(
        character_tracker.storage_key,
        character_tracker.encode(characters),
      )
      let #(char_form, char_editing) = case model.char_editing {
        Some(editing) if editing == id -> #(
          character_tracker.empty_form(),
          None,
        )
        _ -> #(model.char_form, model.char_editing)
      }
      #(
        Model(..model, characters:, char_form:, char_editing:, char_error: None),
        effect.none(),
      )
    }

    UserCancelCharEdit -> #(
      Model(
        ..model,
        char_form: character_tracker.empty_form(),
        char_editing: None,
        char_error: None,
      ),
      effect.none(),
    )

    SampleLoaded(Ok(markdown)) -> #(
      Model(..model, markdown:, loading: False, error: None),
      effect.none(),
    )

    SampleLoaded(Error(message)) -> #(
      Model(..model, loading: False, error: Some(message)),
      effect.none(),
    )

    PalIndexLoaded(Ok(markdown)) -> #(
      Model(..model, pal_elements: pal_index.parse_elements_index(markdown)),
      effect.none(),
    )

    PalIndexLoaded(Error(_)) -> #(model, effect.none())
  }
}

fn update_column_sort(
  model: Model,
  table_id: String,
  column: Int,
) -> Dict(String, TableSort) {
  let kind = inferred_kind(model, table_id, column)
  case dict.get(model.sorts, table_id) {
    Ok(table_sort.TableSort(primary:, secondary:)) if primary.column == column ->
      dict.insert(
        model.sorts,
        table_id,
        table_sort.TableSort(
          primary: table_sort.toggle_direction(primary),
          secondary:,
        ),
      )

    Ok(table_sort.TableSort(primary:, secondary: Some(secondary)))
      if secondary.column == column
    ->
      dict.insert(
        model.sorts,
        table_id,
        table_sort.TableSort(
          primary:,
          secondary: Some(table_sort.toggle_direction(secondary)),
        ),
      )

    Ok(table_sort.TableSort(primary:, secondary: _)) ->
      dict.insert(
        model.sorts,
        table_id,
        table_sort.TableSort(
          primary:,
          secondary: Some(table_sort.default_spec(column, kind)),
        ),
      )

    Error(_) ->
      dict.insert(
        model.sorts,
        table_id,
        table_sort.single(table_sort.default_spec(column, kind)),
      )
  }
}

fn sample_tables(model: Model) -> List(Table) {
  model.markdown
  |> markdown_table.extract_tables
  |> enrich_sample_tables(model.page)
  |> markdown_table.filter_tables(model.filter)
}

fn enrich_sample_tables(tables: List(Table), page: Page) -> List(Table) {
  case page {
    SamplePage(sample) if sample.id == "plane-of-mischief" ->
      pom_items.with_classes_on_item_rows(tables)
    _ -> tables
  }
}

fn inferred_kind(model: Model, table_id: String, column: Int) -> SortKind {
  let tables = sample_tables(model)
  case find_table(tables, table_id) {
    Ok(table) ->
      case table_sort.column_looks_numeric(table.rows, column) {
        True -> SortNumeric
        False -> SortText
      }
    Error(_) -> SortText
  }
}

fn update_slot(
  sorts: Dict(String, TableSort),
  table_id: String,
  slot: SortSlot,
  alter: fn(SortSpec) -> SortSpec,
) -> Dict(String, TableSort) {
  case dict.get(sorts, table_id) {
    Ok(table_sort.TableSort(primary:, secondary:)) -> {
      let updated = case slot {
        Primary -> table_sort.TableSort(primary: alter(primary), secondary:)
        Secondary ->
          case secondary {
            Some(spec) ->
              table_sort.TableSort(primary:, secondary: Some(alter(spec)))
            None -> table_sort.TableSort(primary:, secondary:)
          }
      }
      dict.insert(sorts, table_id, updated)
    }
    Error(_) -> sorts
  }
}

fn find_table(tables: List(Table), table_id: String) -> Result(Table, Nil) {
  list.find(tables, fn(table) { table_id_for(table) == table_id })
}

fn table_id_for(table: Table) -> String {
  table.title
}

fn load_sample(url: String) -> Effect(Msg) {
  rsvp.get(
    url,
    rsvp.expect_ok_response(
      fn(result: Result(Response(String), rsvp.Error(String))) {
        case result {
          Ok(response) -> SampleLoaded(Ok(response.body))
          Error(error) -> SampleLoaded(Error(describe_error(error)))
        }
      },
    ),
  )
}

fn ensure_pal_index(pal_elements: Dict(String, String)) -> Effect(Msg) {
  case dict.size(pal_elements) {
    0 ->
      rsvp.get(
        samples.breeding_sheet_url(),
        rsvp.expect_ok_response(
          fn(result: Result(Response(String), rsvp.Error(String))) {
            case result {
              Ok(response) -> PalIndexLoaded(Ok(response.body))
              Error(error) -> PalIndexLoaded(Error(describe_error(error)))
            }
          },
        ),
      )
    _ -> effect.none()
  }
}

fn describe_error(error: rsvp.Error(String)) -> String {
  case error {
    rsvp.BadUrl(url) -> "Bad sample URL: " <> url
    rsvp.HttpError(response) ->
      "Could not load sample (HTTP " <> int.to_string(response.status) <> ")."
    rsvp.NetworkError -> "Network error while loading sample."
    rsvp.UnhandledResponse(_) -> "Unexpected response while loading sample."
    rsvp.BadBody -> "Sample body could not be read."
    rsvp.JsonError(_) -> "Sample was not valid text."
  }
}

fn view(model: Model) -> Element(Msg) {
  let formatter = page_formatter(model.page, model.pal_elements)
  let tables =
    sample_tables(model)
    |> list.map(fn(table) { apply_sort(table, model.sorts) })

  html.div([attribute.class("app")], [
    html.header([], [
      html.h1([], [html.text("LustreDamus")]),
      html.p([], [
        html.text(
          "Read Markdown tables in the browser — paste your own, or open a sample.",
        ),
      ]),
    ]),
    html.nav(
      [
        attribute.class("site-nav"),
        attribute.attribute("aria-label", "Sections"),
      ],
      [
        nav_button(
          "Paste Markdown",
          model.page == PastePage,
          "nav-root",
          UserChosePaste,
        ),
        ..list.map(samples.groups(), fn(group) {
          sample_nav_bucket(group, model, 0)
        }),
      ],
    ),
    html.main([], case model.page {
      PastePage -> [
        html.label([attribute.for("markdown")], [html.text("Markdown")]),
        html.textarea(
          [
            attribute.id("markdown"),
            attribute.rows(12),
            attribute.placeholder(
              "| Name | Role |\n| ---- | ---- |\n| Ada  | Lead |",
            ),
            event.on_input(UserUpdatedMarkdown),
          ],
          model.markdown,
        ),
        filter_controls(model),
        tables_section(model, tables, formatter),
      ]
      SamplePage(sample) ->
        case samples.is_character_tracker(sample) {
          True -> [
            html.p([attribute.class("sample-meta")], [
              html.text(samples.meta_line(sample)),
            ]),
            character_tracker_panel(model),
          ]
          False -> [
            html.p([attribute.class("sample-meta")], [
              html.text(
                case model.zone_search_open && sample.id == "zone-index" {
                  True ->
                    "All zones — levels, XP, and * for friendly/faction caution. Type above to filter, or pick a zone."
                  False -> samples.meta_line(sample)
                },
              ),
            ]),
            case sample.id == "plane-of-mischief" {
              True -> pom_deck_panel(model.pom_cards)
              False -> element.none()
            },
            case samples.is_raid_targets(sample) {
              True ->
                raid_targets_panel(
                  model.raid_beaten,
                  model.raid_status,
                  model.raid_kill_mode,
                  model.raid_collapsed,
                )
              False -> element.none()
            },
            case samples.is_epic_quests(sample) {
              True ->
                epic_quests_panel(model.epic_done, model.epic_class_filter)
              False -> element.none()
            },
            filter_controls(model),
            tables_section(model, tables, formatter),
          ]
        }
    }),
  ])
}

fn page_formatter(
  page: Page,
  pal_elements: Dict(String, String),
) -> TableFormatter {
  case page {
    SamplePage(sample) -> samples.table_formatter(sample, pal_elements)
    PastePage -> table_format.plain()
  }
}

fn is_sample_page(page: Page, sample: Sample) -> Bool {
  case page {
    SamplePage(current) -> current.id == sample.id
    PastePage -> False
  }
}

fn apply_sort(table: Table, sorts: Dict(String, TableSort)) -> Table {
  let id = table_id_for(table)
  case dict.get(sorts, id) {
    Ok(sort) ->
      markdown_table.Table(
        ..table,
        rows: table_sort.sort_rows(table.rows, sort),
      )
    Error(_) -> table
  }
}

fn sample_nav_bucket(
  group: samples.SampleGroup,
  model: Model,
  depth: Int,
) -> Element(Msg) {
  case samples.is_all_nav(group) {
    True -> zone_all_button(model)
    False ->
      case samples.is_by_class_nav(group) {
        True -> by_class_nav_bucket(group, model, depth)
        False -> sample_nav_bucket_regular(group, model, depth)
      }
  }
}

fn sample_nav_bucket_regular(
  group: samples.SampleGroup,
  model: Model,
  depth: Int,
) -> Element(Msg) {
  // zone-index is not in the tree; keep EverQuest + Zones open while All is on.
  let open = case model.page {
    SamplePage(sample) ->
      samples.group_contains(group, sample)
      || {
        model.zone_search_open
        && {
          samples.is_everquest_nav(group) || samples.is_zones_nav(group)
        }
      }
    PastePage -> False
  }
  let branch_class = case depth {
    0 -> "nav-root"
    1 -> "nav-branch"
    _ -> "nav-subbranch"
  }
  let group_class = case depth {
    0 -> "nav-group nav-group-root"
    _ -> "nav-group"
  }

  // Only the game root mounts an inline panel. Nested rows emit detail
  // through the parent so sibling triggers stay on one line.
  let show_children = open && depth == 0
  let parent = case samples.group_samples(group) {
    [first, ..] ->
      nav_button(group.label, open, branch_class, UserChoseSample(first))
    [] ->
      html.span([attribute.class("nav-section-label")], [html.text(group.label)])
  }

  html.div([attribute.class(group_class)], [
    parent,
    case show_children {
      False -> element.none()
      True ->
        html.div(
          [attribute.class("nav-children")],
          nav_bucket_children(group, model, depth),
        )
    },
  ])
}

/// All replaces the detail panel (hiding byClass children); hide byClass too.
fn by_class_nav_bucket(
  group: samples.SampleGroup,
  model: Model,
  depth: Int,
) -> Element(Msg) {
  case model.zone_search_open {
    True -> element.none()
    False -> sample_nav_bucket_regular(group, model, depth)
  }
}

fn zone_all_button(model: Model) -> Element(Msg) {
  // Hide All while byClass is open (All also hides byClass's detail panel).
  case by_class_is_open(model) {
    True -> element.none()
    False ->
      nav_button(
        "All",
        model.zone_search_open,
        "nav-branch",
        UserOpenedZoneSearch,
      )
  }
}

fn by_class_is_open(model: Model) -> Bool {
  case model.page {
    PastePage -> False
    SamplePage(sample) -> samples.is_by_class_sample(sample)
  }
}

fn zone_all_panel(model: Model) -> Element(Msg) {
  case model.zone_search_open {
    False -> element.none()
    True ->
      html.div([attribute.class("nav-detail-search")], [
        html.div([attribute.class("nav-zone-search-row")], [
          html.input([
            attribute.id("zone-search"),
            attribute.type_("search"),
            attribute.class("nav-zone-search"),
            attribute.placeholder("Zone short or long name…"),
            attribute.value(model.zone_search),
            attribute.attribute("autocomplete", "off"),
            attribute.attribute("aria-label", "Find zone"),
            event.on_input(UserUpdatedZoneSearch),
          ]),
          html.button(
            [
              attribute.type_("button"),
              attribute.class("nav-zone-search-back"),
              attribute.attribute("aria-label", "Back to zone lists"),
              event.on_click(UserClosedZoneSearch),
            ],
            [html.text("Lists")],
          ),
        ]),
        zone_search_results(model),
      ])
  }
}

fn zone_search_results(model: Model) -> Element(Msg) {
  let query = string.trim(model.zone_search)
  case string.length(query) < 2 {
    True ->
      html.p([attribute.class("nav-zone-hint")], [
        html.text("Type 2+ letters · Lists or All to browse"),
      ])
    False ->
      case samples.search_zones(query) {
        [] ->
          html.p([attribute.class("nav-zone-empty")], [
            html.text("No zones match."),
          ])
        matches ->
          html.div(
            [attribute.class("nav-links")],
            list.map(matches, fn(sample) {
              nav_button(
                sample.label,
                is_sample_page(model.page, sample),
                "nav-leaf",
                UserChoseSample(sample),
              )
            }),
          )
      }
  }
}

fn nav_bucket_children(
  group: samples.SampleGroup,
  model: Model,
  depth: Int,
) -> List(Element(Msg)) {
  case depth {
    0 -> root_nav_children(group, model)
    1 -> expansion_nav_children(group, model)
    _ -> leaf_nav_children(group, model)
  }
}

fn root_nav_children(
  group: samples.SampleGroup,
  model: Model,
) -> List(Element(Msg)) {
  let branch_buttons =
    list.filter_map(group.buckets, fn(bucket) {
      case samples.group_samples(bucket) != [] || samples.is_zones_nav(bucket) {
        True -> Ok(sample_nav_bucket(bucket, model, 1))
        False -> Error(Nil)
      }
    })
  let detail = case model.zone_search_open {
    True ->
      case list.find(group.buckets, samples.is_zones_nav) {
        Ok(zones) ->
          html.div(
            [attribute.class("nav-detail")],
            list.append(zones_nav_children(zones, model), [zone_all_panel(model)]),
          )
        Error(_) -> zone_all_panel(model)
      }
    False ->
      case open_child_bucket(group, model) {
        Ok(bucket) ->
          html.div(
            [attribute.class("nav-detail")],
            top_bucket_detail(bucket, model),
          )
        Error(Nil) -> element.none()
      }
  }
  let base = list.append(branch_buttons, [detail])
  case samples.is_everquest_nav(group) {
    True -> list.append(base, [related_sites_nav()])
    False -> base
  }
}

fn top_bucket_detail(
  bucket: samples.SampleGroup,
  model: Model,
) -> List(Element(Msg)) {
  case samples.is_zones_nav(bucket) {
    True -> zones_nav_children(bucket, model)
    False ->
      case samples.is_gear_nav(bucket) {
        True -> gear_nav_children(bucket, model)
        False -> [sample_links_row(model, bucket.samples, "")]
      }
  }
}

fn zones_nav_children(
  zones: samples.SampleGroup,
  model: Model,
) -> List(Element(Msg)) {
  let expansion_buttons =
    list.filter_map(zones.buckets, fn(bucket) {
      case samples.is_all_nav(bucket) {
        True -> Ok(zone_all_button(model))
        False ->
          case samples.group_samples(bucket) {
            [] -> Error(Nil)
            _ -> Ok(sample_nav_bucket(bucket, model, 2))
          }
      }
    })
  let expansion_detail = case model.zone_search_open {
    True -> []
    False ->
      case open_child_bucket(zones, model) {
        Ok(expansion) -> expansion_nav_children(expansion, model)
        Error(Nil) -> []
      }
  }
  list.append(expansion_buttons, expansion_detail)
}

fn gear_nav_children(
  gear: samples.SampleGroup,
  model: Model,
) -> List(Element(Msg)) {
  let sheet_links = sample_links_row(model, gear.samples, "")
  let class_branch =
    list.filter_map(gear.buckets, fn(bucket) {
      case samples.is_by_class_nav(bucket) {
        True -> Ok(by_class_nav_bucket(bucket, model, 2))
        False -> Error(Nil)
      }
    })
  let class_detail = case open_child_bucket(gear, model) {
    Ok(bucket) ->
      case samples.is_by_class_nav(bucket) {
        True -> expansion_nav_children(bucket, model)
        False -> []
      }
    Error(Nil) -> []
  }
  list.append([sheet_links, ..class_branch], class_detail)
}

fn sample_links_row(
  model: Model,
  samples_list: List(samples.Sample),
  extra_class: String,
) -> Element(Msg) {
  case samples_list {
    [] -> element.none()
    rows -> {
      let class = case extra_class {
        "" -> "nav-links"
        _ -> "nav-links " <> extra_class
      }
      html.div(
        [attribute.class(class)],
        list.map(rows, fn(sample) {
          nav_button(
            sample.label,
            is_sample_page(model.page, sample),
            "nav-leaf",
            UserChoseSample(sample),
          )
        }),
      )
    }
  }
}

fn expansion_nav_children(
  group: samples.SampleGroup,
  model: Model,
) -> List(Element(Msg)) {
  let sheet_links = sample_links_row(model, group.samples, "nav-zone-links")
  let type_buttons =
    list.filter_map(group.buckets, fn(bucket) {
      case samples.group_samples(bucket) {
        [] -> Error(Nil)
        _ -> Ok(sample_nav_bucket(bucket, model, 2))
      }
    })
  let zones = case open_child_bucket(group, model) {
    Ok(bucket) -> sample_links_row(model, bucket.samples, "nav-zone-links")
    Error(Nil) -> element.none()
  }
  list.append([sheet_links, ..type_buttons], [zones])
}

fn leaf_nav_children(
  group: samples.SampleGroup,
  model: Model,
) -> List(Element(Msg)) {
  [
    html.div(
      [attribute.class("nav-links")],
      list.map(group.samples, fn(sample) {
        nav_button(
          sample.label,
          is_sample_page(model.page, sample),
          "nav-leaf",
          UserChoseSample(sample),
        )
      }),
    ),
  ]
}

fn open_child_bucket(
  group: samples.SampleGroup,
  model: Model,
) -> Result(samples.SampleGroup, Nil) {
  case model.page {
    PastePage -> Error(Nil)
    SamplePage(sample) ->
      list.find(group.buckets, fn(bucket) {
        samples.group_contains(bucket, sample)
      })
  }
}

fn nav_button(
  label: String,
  active: Bool,
  kind: String,
  msg: Msg,
) -> Element(Msg) {
  let class = case active {
    True -> "nav-link " <> kind <> " active"
    False -> "nav-link " <> kind
  }
  html.button(
    [attribute.type_("button"), attribute.class(class), event.on_click(msg)],
    [html.text(label)],
  )
}

fn related_sites_nav() -> Element(Msg) {
  html.div(
    [
      attribute.class("nav-related"),
      attribute.attribute("aria-label", "Off-site EverQuest links"),
    ],
    [
      html.span([attribute.class("nav-section-label")], [html.text("Off-site")]),
      html.div([attribute.class("nav-links")], [
        external_nav_link("IdleQuest", "https://idlequest.net/"),
        external_nav_link("EQ Progression", "https://www.eqprogression.com/"),
        external_nav_link("Allakhazam", "https://everquest.allakhazam.com/"),
      ]),
    ],
  )
}

fn external_nav_link(label: String, url: String) -> Element(Msg) {
  html.a(
    [
      attribute.class("nav-link nav-leaf nav-link-external"),
      attribute.href(url),
      attribute.target("_blank"),
      attribute.rel("noopener noreferrer"),
      attribute.attribute("title", "Opens in a new tab"),
    ],
    [html.text(label)],
  )
}

fn character_tracker_panel(model: Model) -> Element(Msg) {
  let form = model.char_form
  let save_label = case model.char_editing {
    Some(_) -> "Save changes"
    None -> "Add character"
  }
  html.section(
    [
      attribute.class("char-tracker"),
      attribute.attribute("aria-label", "Character tracker"),
    ],
    [
      html.div([attribute.class("char-tracker-head")], [
        html.h2([], [html.text("Characters")]),
        html.p([], [
          html.text(
            "Track alts on this account. Race and religion are optional. Saved in this browser (localStorage).",
          ),
        ]),
      ]),
      html.form(
        [
          attribute.class("char-form"),
          attribute.attribute("autocomplete", "off"),
          event.on_submit(fn(_) { UserSavedCharacter }),
        ],
        [
          html.label([], [
            html.span([], [html.text("Name")]),
            html.input([
              attribute.type_("text"),
              attribute.value(form.name),
              attribute.required(True),
              event.on_input(UserUpdatedCharName),
            ]),
          ]),
          html.label([], [
            html.span([], [html.text("Class")]),
            html.select(
              [event.on_input(UserUpdatedCharClass)],
              list.map(character_tracker.classes(), fn(class) {
                html.option(
                  [
                    attribute.value(class),
                    attribute.selected(form.class == class),
                  ],
                  class,
                )
              }),
            ),
          ]),
          html.label([], [
            html.span([], [html.text("Level")]),
            html.input([
              attribute.type_("number"),
              attribute.value(form.level),
              attribute.attribute("min", "1"),
              attribute.attribute("max", "100"),
              attribute.required(True),
              event.on_input(UserUpdatedCharLevel),
            ]),
          ]),
          html.label([], [
            html.span([], [html.text("Race (optional)")]),
            optional_select(
              form.race,
              character_tracker.races(),
              UserUpdatedCharRace,
            ),
          ]),
          html.label([], [
            html.span([], [html.text("Religion (optional)")]),
            optional_select(
              form.religion,
              character_tracker.religions(),
              UserUpdatedCharReligion,
            ),
          ]),
          html.label([attribute.class("char-epic")], [
            html.input([
              attribute.type_("checkbox"),
              attribute.checked(form.has_epic),
              event.on_check(UserToggledCharHasEpic),
            ]),
            html.text(" Has epic"),
          ]),
          html.div([attribute.class("char-form-actions")], [
            html.button([attribute.type_("submit"), attribute.class("char-save")], [
              html.text(save_label),
            ]),
            case model.char_editing {
              None -> element.none()
              Some(_) ->
                html.button(
                  [
                    attribute.type_("button"),
                    attribute.class("char-cancel"),
                    event.on_click(UserCancelCharEdit),
                  ],
                  [html.text("Cancel")],
                )
            },
          ]),
        ],
      ),
      case model.char_error {
        None -> element.none()
        Some(message) -> html.p([attribute.class("error")], [html.text(message)])
      },
      case model.characters {
        [] ->
          html.p([attribute.class("char-empty")], [
            html.text("No characters yet."),
          ])
        rows ->
          html.div([attribute.class("table-wrap")], [
            html.table([], [
              html.thead([], [
                html.tr([], [
                  html.th([], [html.text("Name")]),
                  html.th([], [html.text("Class")]),
                  html.th([], [html.text("Level")]),
                  html.th([], [html.text("Race")]),
                  html.th([], [html.text("Religion")]),
                  html.th([], [html.text("Epic")]),
                  html.th([], [html.text("")]),
                ]),
              ]),
              html.tbody(
                [],
                list.map(rows, fn(c) {
                  html.tr([], [
                    html.td([], [html.text(c.name)]),
                    html.td([], [html.text(c.class)]),
                    html.td([], [html.text(int.to_string(c.level))]),
                    html.td([], [
                      html.text(case c.race {
                        "" -> "—"
                        race -> race
                      }),
                    ]),
                    html.td([], [
                      html.text(case c.religion {
                        "" -> "—"
                        religion -> religion
                      }),
                    ]),
                    html.td([], [
                      html.text(case c.has_epic {
                        True -> "Yes"
                        False -> "—"
                      }),
                    ]),
                    html.td([attribute.class("char-row-actions")], [
                      html.button(
                        [
                          attribute.type_("button"),
                          event.on_click(UserEditCharacter(c.id)),
                        ],
                        [html.text("Edit")],
                      ),
                      html.button(
                        [
                          attribute.type_("button"),
                          event.on_click(UserDeleteCharacter(c.id)),
                        ],
                        [html.text("Delete")],
                      ),
                    ]),
                  ])
                }),
              ),
            ]),
          ])
      },
    ],
  )
}

fn optional_select(
  value: String,
  options: List(String),
  to_msg: fn(String) -> Msg,
) -> Element(Msg) {
  html.select(
    [event.on_input(to_msg)],
    [
      html.option([attribute.value(""), attribute.selected(value == "")], "—"),
      ..list.map(options, fn(opt) {
        html.option(
          [attribute.value(opt), attribute.selected(value == opt)],
          opt,
        )
      })
    ],
  )
}

fn pom_item_td(name: String) -> Element(Msg) {
  let attrs = case pom_items.tooltip(name) {
    Some(text) -> [
      attribute.class("cell-item"),
      attribute.title(text),
    ]
    None -> []
  }
  html.td(attrs, [html.text(name)])
}

fn epic_quests_panel(done: Dict(String, Bool), class_filter: String) -> Element(Msg) {
  let total = epic_quests.total_step_count()
  let done_n = epic_quests.total_done_count(done)
  let quests = case class_filter {
    "" -> epic_quests.quests()
    id ->
      case epic_quests.find_quest(id) {
        Ok(q) -> [q]
        Error(_) -> epic_quests.quests()
      }
  }
  html.section(
    [
      attribute.class("epic-quests"),
      attribute.attribute("aria-label", "Epic quest checklists"),
    ],
    [
      html.div([attribute.class("epic-quests-head")], [
        html.h2([], [html.text("Epic checklists")]),
        html.p([], [
          html.text(
            "Mark important P99 epic milestones. Progress saves in this browser. Full walkthroughs stay on the Project 1999 wiki.",
          ),
        ]),
        html.p([attribute.class("epic-quests-progress")], [
          html.text(int.to_string(done_n) <> " / " <> int.to_string(total)),
        ]),
        html.label([attribute.class("epic-quests-filter")], [
          html.span([], [html.text("Class")]),
          html.select(
            [
              attribute.attribute("aria-label", "Filter epic class"),
              event.on_input(UserSetEpicClassFilter),
            ],
            [
              html.option(
                [attribute.value(""), attribute.selected(class_filter == "")],
                "All classes",
              ),
              ..list.map(epic_quests.quests(), fn(q) {
                html.option(
                  [
                    attribute.value(q.id),
                    attribute.selected(q.id == class_filter),
                  ],
                  q.class,
                )
              })
            ],
          ),
        ]),
        html.button(
          [
            attribute.type_("button"),
            attribute.class("epic-quests-clear"),
            event.on_click(UserClearedAllEpicSteps),
          ],
          [html.text("Reset all")],
        ),
      ]),
      ..list.map(quests, fn(quest) { epic_quest_group(done, quest) })
    ],
  )
}

fn epic_quest_group(
  done: Dict(String, Bool),
  quest: epic_quests.ClassQuest,
) -> Element(Msg) {
  let done_n = epic_quests.done_count(done, quest)
  let total = epic_quests.step_count(quest)
  html.div([attribute.class("epic-quest-group")], [
    html.div([attribute.class("epic-quest-group-head")], [
      html.h3([], [
        html.text(
          quest.class
          <> " — "
          <> quest.final_epic
          <> " ("
          <> int.to_string(done_n)
          <> "/"
          <> int.to_string(total)
          <> ")",
        ),
      ]),
      html.a(
        [
          attribute.href(
            "https://wiki.project1999.com/" <> quest.wiki_path,
          ),
          attribute.target("_blank"),
          attribute.rel("noopener noreferrer"),
          attribute.class("epic-quest-wiki"),
        ],
        [html.text("P99 wiki")],
      ),
      html.button(
        [
          attribute.type_("button"),
          attribute.class("epic-quests-clear"),
          event.on_click(UserClearedEpicQuest(quest.id)),
        ],
        [html.text("Reset class")],
      ),
    ]),
    html.ul(
      [attribute.class("epic-quest-steps")],
      list.map(quest.steps, fn(step) {
        let checked = epic_quests.is_done(done, step.id)
        html.li(
          [
            attribute.class(case checked {
              True -> "epic-quest-step done"
              False -> "epic-quest-step"
            }),
          ],
          [
            html.label([attribute.class("epic-quest-check")], [
              html.input([
                attribute.type_("checkbox"),
                attribute.checked(checked),
                attribute.attribute("aria-label", step.label),
                event.on_check(fn(on) { UserToggledEpicStep(step.id, on) }),
              ]),
              html.span([attribute.class("epic-quest-label")], [
                html.text(step.label),
              ]),
            ]),
            case step.note {
              "" -> element.none()
              note ->
                html.span([attribute.class("epic-quest-note")], [
                  html.text(note),
                ])
            },
          ],
        )
      }),
    ),
  ])
}

fn raid_targets_panel(
  beaten: Dict(String, Bool),
  statuses: Dict(String, raid_targets.Status),
  kill_modes: Dict(String, raid_targets.KillMode),
  collapsed: Dict(String, Bool),
) -> Element(Msg) {
  let total = list.length(raid_targets.targets())
  let done = raid_targets.beaten_count(beaten)
  html.section(
    [
      attribute.class("raid-targets"),
      attribute.attribute("aria-label", "Raid targets tracker"),
    ],
    [
      html.div([attribute.class("raid-targets-head")], [
        html.h2([], [html.text("Beaten")]),
        html.p([], [
          html.text(
            "Mark bosses you have beaten. Loot status and group vs raid clear are separate. All save in this browser. Reset beaten when rules of engagement change.",
          ),
        ]),
        html.p([attribute.class("raid-targets-progress")], [
          html.text(int.to_string(done) <> " / " <> int.to_string(total)),
        ]),
        html.button(
          [
            attribute.type_("button"),
            attribute.class("raid-targets-clear"),
            event.on_click(UserClearedRaidBeaten),
          ],
          [html.text("Reset beaten")],
        ),
      ]),
      ..list.map(raid_targets.by_expansion(), fn(group) {
        let #(expansion, blocks) = group
        let expansion_key = expansion
        let expansion_collapsed = raid_section_is_collapsed(collapsed, expansion_key)
        html.div(
          [
            attribute.class(case expansion_collapsed {
              True -> "raid-targets-group collapsed"
              False -> "raid-targets-group"
            }),
          ],
          [
            raid_section_toggle(
              expansion,
              expansion_key,
              expansion_collapsed,
              "h3",
            ),
            ..case expansion_collapsed {
              True -> []
              False ->
                list.map(blocks, fn(block) {
                  raid_targets_section_block(
                    expansion,
                    block,
                    beaten,
                    statuses,
                    kill_modes,
                    collapsed,
                  )
                })
            }
          ],
        )
      })
    ],
  )
}

fn raid_targets_section_block(
  expansion: String,
  block: raid_targets.SectionBlock,
  beaten: Dict(String, Bool),
  statuses: Dict(String, raid_targets.Status),
  kill_modes: Dict(String, raid_targets.KillMode),
  collapsed: Dict(String, Bool),
) -> Element(Msg) {
  let list_el =
    html.ul(
      [attribute.class("raid-targets-list")],
      list.map(block.targets, fn(t) {
        raid_target_row(t, beaten, statuses, kill_modes)
      }),
    )
  case block.title {
    None ->
      html.div([attribute.class("raid-targets-section")], [list_el])
    Some(title) -> {
      let key = expansion <> "/" <> title
      let is_collapsed = raid_section_is_collapsed(collapsed, key)
      html.div(
        [
          attribute.class(case is_collapsed {
            True -> "raid-targets-section collapsed"
            False -> "raid-targets-section"
          }),
        ],
        [
          raid_section_toggle(title, key, is_collapsed, "h4"),
          ..case is_collapsed {
            True -> []
            False -> [list_el]
          }
        ],
      )
    }
  }
}

fn raid_section_is_collapsed(
  collapsed: Dict(String, Bool),
  key: String,
) -> Bool {
  case dict.get(collapsed, key) {
    Ok(True) -> True
    _ -> False
  }
}

fn raid_section_toggle(
  label: String,
  key: String,
  collapsed: Bool,
  level: String,
) -> Element(Msg) {
  html.button(
    [
      attribute.type_("button"),
      attribute.class(case collapsed {
        True -> "raid-targets-toggle " <> level <> " collapsed"
        False -> "raid-targets-toggle " <> level
      }),
      attribute.attribute(
        "aria-expanded",
        case collapsed {
          True -> "false"
          False -> "true"
        },
      ),
      event.on_click(UserToggledRaidSection(key)),
    ],
    [html.text(label)],
  )
}

fn raid_target_row(
  t: raid_targets.Target,
  beaten: Dict(String, Bool),
  statuses: Dict(String, raid_targets.Status),
  kill_modes: Dict(String, raid_targets.KillMode),
) -> Element(Msg) {
  let checked = raid_targets.has_beaten(beaten, t.id)
  let status = raid_targets.get_status(statuses, t.id)
  let kill_mode = raid_targets.get_kill_mode(kill_modes, t.id)
  html.li(
    [
      attribute.class(case checked {
        True -> "raid-target-row beaten"
        False -> "raid-target-row"
      }),
    ],
    [
      html.label([attribute.class("raid-target-check")], [
        html.input([
          attribute.type_("checkbox"),
          attribute.checked(checked),
          attribute.attribute("aria-label", t.name <> " beaten"),
          event.on_check(fn(on) { UserToggledRaidBeaten(t.id, on) }),
        ]),
      ]),
      html.span([attribute.class("raid-target-name")], [html.text(t.name)]),
      raid_status_select(t.id, t.name, status),
      raid_kill_mode_select(t.id, t.name, kill_mode),
      html.span([attribute.class("raid-target-hp")], [
        html.text(raid_targets.hp_label(t.hp)),
      ]),
      html.span([attribute.class("raid-target-zone")], [html.text(t.zone)]),
      case t.note {
        "" -> element.none()
        note ->
          html.span([attribute.class("raid-target-note")], [html.text(note)])
      },
    ],
  )
}

fn raid_status_select(
  id: String,
  name: String,
  status: raid_targets.Status,
) -> Element(Msg) {
  html.select(
    [
      attribute.class("raid-target-status"),
      attribute.attribute("aria-label", name <> " loot status"),
      attribute.title(raid_targets.status_tooltip(status)),
      event.on_input(fn(raw) { UserSetRaidStatus(id, raw) }),
    ],
    list.map(raid_targets.statuses(), fn(option) {
      html.option(
        [
          attribute.value(raid_targets.status_id(option)),
          attribute.selected(
            raid_targets.status_id(option) == raid_targets.status_id(status),
          ),
          attribute.title(raid_targets.status_tooltip(option)),
        ],
        raid_targets.status_label(option),
      )
    }),
  )
}

fn raid_kill_mode_select(
  id: String,
  name: String,
  mode: raid_targets.KillMode,
) -> Element(Msg) {
  html.select(
    [
      attribute.class("raid-target-kill-mode"),
      attribute.attribute("aria-label", name <> " group or raid clear"),
      attribute.title(raid_targets.kill_mode_tooltip(mode)),
      event.on_input(fn(raw) { UserSetRaidKillMode(id, raw) }),
    ],
    list.map(raid_targets.kill_modes(), fn(option) {
      html.option(
        [
          attribute.value(raid_targets.kill_mode_id(option)),
          attribute.selected(
            raid_targets.kill_mode_id(option)
            == raid_targets.kill_mode_id(mode),
          ),
          attribute.title(raid_targets.kill_mode_tooltip(option)),
        ],
        raid_targets.kill_mode_label(option),
      )
    }),
  )
}

fn pom_deck_panel(owned: Dict(String, Bool)) -> Element(Msg) {
  let craftable = pom_deck.craftable(owned)
  let missing = pom_deck.missing_one(owned)
  html.section(
    [
      attribute.class("pom-deck"),
      attribute.attribute("aria-label", "Plane of Mischief deck tracker"),
    ],
    [
      html.div([attribute.class("pom-deck-head")], [
        html.h2([], [html.text("Deck combo tracker")]),
        html.p([], [
          html.text(
            "Check cards you have. Hover item names for stats. Combine spends that row’s exact cards. Progress saves in this browser.",
          ),
        ]),
        html.button(
          [
            attribute.type_("button"),
            attribute.class("pom-deck-clear"),
            event.on_click(UserClearedPomCards),
          ],
          [html.text("Clear cards")],
        ),
      ]),
      pom_card_grid(owned),
      html.h3([], [html.text("Can create")]),
      case craftable {
        [] ->
          html.p([attribute.class("pom-deck-empty")], [
            html.text("No complete recipes yet."),
          ])
        rows ->
          html.div([attribute.class("table-wrap")], [
            html.table([], [
              html.thead([], [
                html.tr([], [
                  html.th([], [html.text("Item")]),
                  html.th([], [html.text("Classes")]),
                  html.th([], [html.text("Cards")]),
                  html.th([], [html.text("")]),
                ]),
              ]),
              html.tbody(
                [],
                list.map(rows, fn(r) {
                  let needs = r.needs
                  html.tr([], [
                    pom_item_td(r.name),
                    html.td([], [html.text(r.classes)]),
                    html.td([], [html.text(pom_deck.needs_labels(needs))]),
                    html.td([attribute.class("pom-combine-cell")], [
                      html.button(
                        [
                          attribute.type_("button"),
                          attribute.class("pom-combine"),
                          attribute.attribute(
                            "aria-label",
                            "Combine "
                              <> r.name
                              <> " using "
                              <> pom_deck.needs_labels(needs),
                          ),
                          event.on_click(UserCombinedPomRecipe(needs)),
                        ],
                        [html.text("Combine")],
                      ),
                    ]),
                  ])
                }),
              ),
            ]),
          ])
      },
      html.h3([], [html.text("Missing 1")]),
      case missing {
        [] ->
          html.p([attribute.class("pom-deck-empty")], [
            html.text("Nothing is one card away."),
          ])
        rows ->
          html.div([attribute.class("table-wrap")], [
            html.table([], [
              html.thead([], [
                html.tr([], [
                  html.th([], [html.text("Item")]),
                  html.th([], [html.text("Classes")]),
                  html.th([], [html.text("Need")]),
                  html.th([], [html.text("Farm")]),
                ]),
              ]),
              html.tbody(
                [],
                list.map(rows, fn(m) {
                  html.tr([], [
                    pom_item_td(m.recipe.name),
                    html.td([], [html.text(m.recipe.classes)]),
                    html.td([], [html.text(m.missing_label)]),
                    html.td([attribute.class("col-notes")], [html.text(m.farm)]),
                  ])
                }),
              ),
            ]),
          ])
      },
    ],
  )
}

fn pom_card_grid(owned: Dict(String, Bool)) -> Element(Msg) {
  html.div([attribute.class("table-wrap pom-card-grid")], [
    html.table([], [
      html.thead([], [
        html.tr(
          [],
          [
            html.th([], [html.text("Rank")]),
            ..list.map(pom_deck.colors(), fn(c) {
              let #(_, label) = c
              html.th([], [html.text(label)])
            })
          ],
        ),
      ]),
      html.tbody(
        [],
        list.map(pom_deck.ranks(), fn(rank) {
          let #(rank_id, rank_label) = rank
          html.tr(
            [],
            [
              html.th([], [html.text(rank_label)]),
              ..list.map(pom_deck.colors(), fn(color) {
                let #(color_id, _) = color
                let id = color_id <> "-" <> rank_id
                let checked = pom_deck.has_card(owned, id)
                html.td([], [
                  html.label([attribute.class("pom-card-check")], [
                    html.input([
                      attribute.type_("checkbox"),
                      attribute.checked(checked),
                      attribute.attribute("aria-label", pom_deck.card_label(id)),
                      event.on_check(fn(on) { UserToggledPomCard(id, on) }),
                    ]),
                    html.text(" have"),
                  ]),
                ])
              })
            ],
          )
        }),
      ),
    ]),
  ])
}

fn filter_controls(model: Model) -> Element(Msg) {
  html.div([attribute.class("filter-row")], [
    html.label([attribute.for("filter")], [html.text("Filter tables")]),
    html.input([
      attribute.id("filter"),
      attribute.type_("search"),
      attribute.placeholder("Search rows…"),
      attribute.value(model.filter),
      event.on_input(UserUpdatedFilter),
    ]),
  ])
}

fn tables_section(
  model: Model,
  tables: List(Table),
  formatter: TableFormatter,
) -> Element(Msg) {
  html.section([attribute.class("preview")], [
    html.h2([], [html.text("Tables")]),
    case model.loading {
      True -> html.p([attribute.class("empty")], [html.text("Loading sample…")])
      False ->
        case model.error {
          Some(message) ->
            html.p([attribute.class("error")], [html.text(message)])
          None ->
            render_tables(
              tables,
              model.markdown,
              model.sorts,
              model.optional_columns,
              model.value_filters,
              model.hide_zero_spawn,
              formatter,
            )
        }
    },
  ])
}

fn render_tables(
  tables: List(Table),
  markdown: String,
  sorts: Dict(String, TableSort),
  optional_columns: Dict(String, Dict(String, Bool)),
  value_filters: Dict(String, Dict(String, Dict(String, Bool))),
  hide_zero_spawn: Bool,
  formatter: TableFormatter,
) -> Element(Msg) {
  case tables {
    [] if markdown == "" ->
      html.p([attribute.class("empty")], [
        html.text("Paste Markdown or open a sample to see tables."),
      ])
    [] ->
      html.p([attribute.class("empty")], [
        html.text("No tables matched this Markdown (or filter)."),
      ])
    _ -> {
      let has_zero =
        list.any(tables, fn(table) {
          list.any(table.rows, fn(row) {
            row_marked_zero_spawn(table.headers, row)
          })
        })
      html.div([attribute.class("tables")], [
        case has_zero {
          False -> element.none()
          True ->
            html.div([attribute.class("column-toggles")], [
              html.label([], [
                html.input([
                  attribute.type_("checkbox"),
                  attribute.checked(hide_zero_spawn),
                  event.on_check(UserToggledHideZeroSpawn),
                ]),
                html.text(" Hide 0% spawn"),
              ]),
            ])
        },
        ..list.map(tables, fn(table) {
          render_table(
            table,
            sorts,
            optional_columns,
            value_filters,
            hide_zero_spawn,
            formatter,
          )
        })
      ])
    }
  }
}

/// Zero static spawn: Chance column is 0%/0, or legacy Notes marker **0%**.
fn row_marked_zero_spawn(headers: List(String), row: List(String)) -> Bool {
  let from_chance = case column_index(headers, "Chance") {
    Error(_) -> False
    Ok(index) -> {
      let value = string.trim(cell_at(row, index))
      value == "0%" || value == "0" || string.contains(value, "**0%**")
    }
  }
  from_chance
  || list.any(row, fn(cell) { string.contains(cell, "**0%**") })
}

fn render_table(
  table: Table,
  sorts: Dict(String, TableSort),
  optional_columns: Dict(String, Dict(String, Bool)),
  value_filters: Dict(String, Dict(String, Dict(String, Bool))),
  hide_zero_spawn: Bool,
  formatter: TableFormatter,
) -> Element(Msg) {
  let id = table_id_for(table)
  let active = dict.get(sorts, id)
  let optional_headers =
    list.filter(table.headers, fn(header) {
      is_optional_header(table.headers, header)
    })
  let rows =
    filter_rows_by_values(table, id, value_filters)
    |> list.filter(fn(row) {
      case hide_zero_spawn && row_marked_zero_spawn(table.headers, row) {
        True -> False
        False -> True
      }
    })

  html.section([attribute.class("md-table")], [
    html.h3([], render_inline_text(table.title)),
    case active {
      Ok(sort) -> sort_controls(id, sort, table.headers)
      Error(_) ->
        html.p([attribute.class("sort-hint")], [
          html.text(
            "Click a column to sort. Click another column to add a secondary sort.",
          ),
        ])
    },
    value_filter_toggles(id, table, value_filters),
    optional_column_toggles(id, table.headers, optional_headers, optional_columns),
    html.div([attribute.class("table-wrap")], [
      html.table([], [
        html.thead([], [
          html.tr(
            [],
            visible_header_cells(
              table.headers,
              id,
              optional_columns,
              active,
            ),
          ),
        ]),
        html.tbody(
          [],
          list.index_map(rows, fn(row, row_index) {
            html.tr(
              [],
              visible_body_cells(
                table,
                row,
                row_index,
                id,
                optional_columns,
                formatter,
              ),
            )
          }),
        ),
      ]),
    ]),
  ])
}

fn visible_header_cells(
  headers: List(String),
  table_id: String,
  optional_columns: Dict(String, Dict(String, Bool)),
  active: Result(TableSort, Nil),
) -> List(Element(Msg)) {
  headers
  |> list.index_map(fn(cell, index) { #(cell, index) })
  |> list.filter_map(fn(pair) {
    let #(cell, index) = pair
    case column_is_shown(headers, optional_columns, table_id, cell) {
      False -> Error(Nil)
      True -> {
        let role = column_role(active, index)
        let marker = case role {
          Some(#(Primary, Asc)) -> " ↑1"
          Some(#(Primary, Desc)) -> " ↓1"
          Some(#(Secondary, Asc)) -> " ↑2"
          Some(#(Secondary, Desc)) -> " ↓2"
          None -> ""
        }
        let class = case role {
          Some(#(Primary, _)) -> "sortable selected primary"
          Some(#(Secondary, _)) -> "sortable selected secondary"
          None -> "sortable"
        }
        Ok(
          html.th([attribute.class(join_class(class, column_class(cell)))], [
            html.button(
              [
                attribute.type_("button"),
                attribute.class("sort-header"),
                event.on_click(UserClickedColumn(table_id, index)),
              ],
              [html.text(cell <> marker)],
            ),
          ]),
        )
      }
    }
  })
}

fn visible_body_cells(
  table: Table,
  row: List(String),
  row_index: Int,
  table_id: String,
  optional_columns: Dict(String, Dict(String, Bool)),
  formatter: TableFormatter,
) -> List(Element(Msg)) {
  table.headers
  |> list.index_map(fn(header, column) { #(header, column) })
  |> list.filter_map(fn(pair) {
    let #(header, column) = pair
    case column_is_shown(table.headers, optional_columns, table_id, header) {
      False -> Error(Nil)
      True -> {
        let ctx =
          table_format.make_context(
            table.title,
            table.headers,
            column,
            row_index,
            row,
          )
        let formatted = table_format.format_cell(formatter, ctx)
        Ok(render_td(formatted, column_class(header)))
      }
    }
  })
}

fn optional_column_toggles(
  table_id: String,
  all_headers: List(String),
  optional_headers: List(String),
  optional_columns: Dict(String, Dict(String, Bool)),
) -> Element(Msg) {
  case optional_headers {
    [] -> html.text("")
    _ ->
      html.div(
        [attribute.class("column-toggles")],
        list.map(optional_headers, fn(header) {
          let shown =
            column_is_shown(all_headers, optional_columns, table_id, header)
          html.label([], [
            html.input([
              attribute.type_("checkbox"),
              attribute.checked(shown),
              event.on_check(fn(checked) {
                UserToggledOptionalColumn(table_id, header, checked)
              }),
            ]),
            html.text(" Show " <> header),
          ])
        }),
      )
  }
}

/// Columns hidden by default with a "Show …" toggle.
/// Mob `Class` only — not loot `Classes`, and not Party DPS `Class` (no Mob col).
fn is_optional_header(headers: List(String), header: String) -> Bool {
  case header {
    "Wing" | "Loc" -> True
    "Class" -> list.contains(headers, "Mob")
    _ -> False
  }
}

fn column_is_shown(
  headers: List(String),
  optional_columns: Dict(String, Dict(String, Bool)),
  table_id: String,
  header: String,
) -> Bool {
  case is_optional_header(headers, header) {
    False -> True
    True ->
      case dict.get(optional_columns, table_id) {
        Ok(columns) ->
          case dict.get(columns, header) {
            Ok(True) -> True
            Ok(False) -> False
            Error(_) -> False
          }
        Error(_) -> False
      }
  }
}

fn set_optional_column(
  optional_columns: Dict(String, Dict(String, Bool)),
  table_id: String,
  header: String,
  shown: Bool,
) -> Dict(String, Dict(String, Bool)) {
  let columns = case dict.get(optional_columns, table_id) {
    Ok(existing) -> existing
    Error(_) -> dict.new()
  }
  dict.insert(
    optional_columns,
    table_id,
    dict.insert(columns, header, shown),
  )
}

fn is_filter_header(header: String) -> Bool {
  header == "Expansion"
}

fn value_filter_toggles(
  table_id: String,
  table: Table,
  value_filters: Dict(String, Dict(String, Dict(String, Bool))),
) -> Element(Msg) {
  let groups =
    table.headers
    |> list.filter(is_filter_header)
    |> list.filter_map(fn(header) {
      case unique_column_values(table, header) {
        [] -> Error(Nil)
        values -> Ok(#(header, values))
      }
    })

  case groups {
    [] -> html.text("")
    _ ->
      html.div(
        [attribute.class("column-toggles")],
        list.flat_map(groups, fn(group) {
          let #(header, values) = group
          [
            html.span([attribute.class("sort-group-label")], [
              html.text(header),
            ]),
            ..list.map(values, fn(value) {
              let shown =
                value_is_shown(value_filters, table_id, header, value)
              html.label([], [
                html.input([
                  attribute.type_("checkbox"),
                  attribute.checked(shown),
                  event.on_check(fn(checked) {
                    UserToggledValueFilter(table_id, header, value, checked)
                  }),
                ]),
                html.text(value),
              ])
            })
          ]
        }),
      )
  }
}

fn unique_column_values(table: Table, header: String) -> List(String) {
  case column_index(table.headers, header) {
    Error(_) -> []
    Ok(index) ->
      table.rows
      |> list.filter_map(fn(row) {
        case cell_at(row, index) {
          "" -> Error(Nil)
          value -> Ok(value)
        }
      })
      |> unique_strings
      |> list.sort(compare_filter_values)
  }
}

fn unique_strings(values: List(String)) -> List(String) {
  list.fold(values, [], fn(acc, value) {
    case list.contains(acc, value) {
      True -> acc
      False -> list.append(acc, [value])
    }
  })
}

fn compare_filter_values(a: String, b: String) -> order.Order {
  case int.compare(filter_value_rank(a), filter_value_rank(b)) {
    order.Eq -> string.compare(a, b)
    other -> other
  }
}

fn filter_value_rank(value: String) -> Int {
  case value {
    "Classic" -> 0
    "Kunark" -> 1
    "Velious" -> 2
    _ -> 10
  }
}

fn filter_rows_by_values(
  table: Table,
  table_id: String,
  value_filters: Dict(String, Dict(String, Dict(String, Bool))),
) -> List(List(String)) {
  list.filter(table.rows, fn(row) {
    list.index_fold(table.headers, True, fn(keep, header, index) {
      case keep && is_filter_header(header) {
        False -> keep
        True ->
          value_is_shown(
            value_filters,
            table_id,
            header,
            cell_at(row, index),
          )
      }
    })
  })
}

fn value_is_shown(
  value_filters: Dict(String, Dict(String, Dict(String, Bool))),
  table_id: String,
  header: String,
  value: String,
) -> Bool {
  case dict.get(value_filters, table_id) {
    Error(_) -> True
    Ok(headers) ->
      case dict.get(headers, header) {
        Error(_) -> True
        Ok(values) ->
          case dict.get(values, value) {
            Ok(False) -> False
            Ok(True) -> True
            Error(_) -> True
          }
      }
  }
}

fn set_value_filter(
  value_filters: Dict(String, Dict(String, Dict(String, Bool))),
  table_id: String,
  header: String,
  value: String,
  shown: Bool,
) -> Dict(String, Dict(String, Dict(String, Bool))) {
  let headers = case dict.get(value_filters, table_id) {
    Ok(existing) -> existing
    Error(_) -> dict.new()
  }
  let values = case dict.get(headers, header) {
    Ok(existing) -> existing
    Error(_) -> dict.new()
  }
  dict.insert(
    value_filters,
    table_id,
    dict.insert(headers, header, dict.insert(values, value, shown)),
  )
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
    [cell, ..] -> cell
    [] -> ""
  }
}

fn render_td(formatted: FormattedCell, extra_class: String) -> Element(Msg) {
  let class_name = join_class(formatted.class_name, extra_class)
  let class_attr = case class_name {
    "" -> []
    _ -> [attribute.class(class_name)]
  }
  let title_attr = case formatted.title {
    Some(title) -> [attribute.title(title)]
    None -> []
  }
  html.td(list.append(class_attr, title_attr), render_inline_text(formatted.text))
}

fn render_inline_text(text: String) -> List(Element(Msg)) {
  case table_format.parse_markdown_emphasis(text) {
    [] -> [html.text("")]
    segments ->
      list.map(segments, fn(segment) {
        case segment {
          table_format.PlainText(value) -> html.text(value)
          table_format.BoldText(value) ->
            html.strong([], [html.text(value)])
        }
      })
  }
}

fn column_class(header: String) -> String {
  "col-" <> string.replace(string.lowercase(header), " ", "-")
}

fn join_class(existing: String, next: String) -> String {
  case existing {
    "" -> next
    _ -> existing <> " " <> next
  }
}

fn column_role(
  active: Result(TableSort, Nil),
  index: Int,
) -> Option(#(SortSlot, Direction)) {
  case active {
    Ok(table_sort.TableSort(primary:, secondary: _))
      if primary.column == index
    -> Some(#(Primary, primary.direction))
    Ok(table_sort.TableSort(primary: _, secondary: Some(secondary)))
      if secondary.column == index
    -> Some(#(Secondary, secondary.direction))
    _ -> None
  }
}

fn sort_controls(
  table_id: String,
  sort: TableSort,
  headers: List(String),
) -> Element(Msg) {
  html.div([attribute.class("sort-panels")], [
    sort_panel(table_id, Primary, sort.primary, headers),
    case sort.secondary {
      Some(secondary) ->
        html.div([attribute.class("sort-secondary-wrap")], [
          sort_panel(table_id, Secondary, secondary, headers),
          html.button(
            [
              attribute.type_("button"),
              attribute.class("sort-clear"),
              event.on_click(UserClearSecondary(table_id)),
            ],
            [html.text("Clear secondary")],
          ),
        ])
      None ->
        html.p([attribute.class("sort-hint")], [
          html.text("Click another column header to add a secondary sort."),
        ])
    },
    html.button(
      [
        attribute.type_("button"),
        attribute.class("sort-clear"),
        event.on_click(UserClearSort(table_id)),
      ],
      [html.text("Clear all sorts")],
    ),
  ])
}

fn sort_panel(
  table_id: String,
  slot: SortSlot,
  spec: SortSpec,
  headers: List(String),
) -> Element(Msg) {
  let column_name = case list.drop(headers, spec.column) {
    [name, ..] -> name
    [] -> "Column"
  }
  let title = case slot {
    Primary -> "Primary: " <> column_name
    Secondary -> "Secondary: " <> column_name
  }

  html.div([attribute.class("sort-controls")], [
    html.p([attribute.class("sort-active")], [html.text(title)]),
    html.div([attribute.class("sort-group")], [
      html.span([attribute.class("sort-group-label")], [html.text("Type")]),
      toggle_btn(
        "Text",
        spec.kind == SortText,
        UserSetSortKind(table_id, slot, SortText),
      ),
      toggle_btn(
        "Numeric",
        spec.kind == SortNumeric,
        UserSetSortKind(table_id, slot, SortNumeric),
      ),
    ]),
    html.div([attribute.class("sort-group")], [
      html.span([attribute.class("sort-group-label")], [html.text("Direction")]),
      toggle_btn(
        case spec.kind {
          SortText -> "A → Z"
          SortNumeric -> "0 → 9"
        },
        spec.direction == Asc,
        UserSetDirection(table_id, slot, Asc),
      ),
      toggle_btn(
        case spec.kind {
          SortText -> "Z → A"
          SortNumeric -> "9 → 0"
        },
        spec.direction == Desc,
        UserSetDirection(table_id, slot, Desc),
      ),
    ]),
    html.div([attribute.class("sort-group")], [
      html.span([attribute.class("sort-group-label")], [html.text("Empties")]),
      toggle_btn(
        "First",
        spec.empties == EmptiesFirst,
        UserSetEmptyPlacement(table_id, slot, EmptiesFirst),
      ),
      toggle_btn(
        "Last",
        spec.empties == EmptiesLast,
        UserSetEmptyPlacement(table_id, slot, EmptiesLast),
      ),
    ]),
    case spec.kind {
      SortNumeric ->
        html.div([attribute.class("sort-group")], [
          html.span([attribute.class("sort-group-label")], [
            html.text("Non-numbers"),
          ]),
          toggle_btn(
            "Before numbers",
            spec.texts == TextBeforeNumbers,
            UserSetTextPlacement(table_id, slot, TextBeforeNumbers),
          ),
          toggle_btn(
            "After numbers",
            spec.texts == TextAfterNumbers,
            UserSetTextPlacement(table_id, slot, TextAfterNumbers),
          ),
        ])
      SortText -> element.none()
    },
  ])
}

fn toggle_btn(label: String, active: Bool, msg: Msg) -> Element(Msg) {
  let class = case active {
    True -> "sort-option active"
    False -> "sort-option"
  }
  html.button(
    [attribute.type_("button"), attribute.class(class), event.on_click(msg)],
    [html.text(label)],
  )
}
