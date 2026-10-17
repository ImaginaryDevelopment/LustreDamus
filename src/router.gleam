//// Hash routes for deep links: `#/` (paste) and `#/s/<sample-id>`.

import gleam/string
import samples

pub type Route {
  Paste
  Sample(String)
}

@external(javascript, "./router_ffi.mjs", "get_hash")
pub fn get_hash() -> String

@external(javascript, "./router_ffi.mjs", "set_hash")
pub fn set_hash(path: String) -> Nil

@external(javascript, "./router_ffi.mjs", "on_hash_change")
pub fn on_hash_change(callback: fn(String) -> Nil) -> Nil

/// Path fragment after `#` (includes leading `/`), e.g. `/` or `/s/raid-targets`.
pub fn encode(route: Route) -> String {
  case route {
    Paste -> "/"
    Sample(id) -> "/s/" <> id
  }
}

/// Full `href` for nav links, e.g. `#/` or `#/s/raid-targets`.
pub fn href(route: Route) -> String {
  "#" <> encode(route)
}

/// Decode a hash path (with or without leading `#`). Unknown / missing sample → Paste.
pub fn decode(raw: String) -> Route {
  let path =
    raw
    |> string.trim
    |> strip_hash
    |> trim_slashes
  case path {
    "" | "/" -> Paste
    rest ->
      case string.split(rest, "/") {
        ["", "s", id] | ["s", id] -> decode_sample_id(id)
        ["", "s", id, ..] | ["s", id, ..] -> decode_sample_id(id)
        _ -> Paste
      }
  }
}

fn decode_sample_id(id: String) -> Route {
  let id = string.trim(id)
  case id == "" {
    True -> Paste
    False ->
      case samples.find(id) {
        Ok(_) -> Sample(id)
        Error(_) ->
          case id == "zone-index" {
            True -> Sample(id)
            False -> Paste
          }
      }
  }
}

fn strip_hash(raw: String) -> String {
  case string.starts_with(raw, "#") {
    True -> string.drop_start(raw, 1)
    False -> raw
  }
}

fn trim_slashes(path: String) -> String {
  case path {
    "" -> ""
    _ -> {
      let without_trailing = case string.ends_with(path, "/") && path != "/" {
        True -> string.drop_end(path, 1)
        False -> path
      }
      case string.starts_with(without_trailing, "/") {
        True -> without_trailing
        False -> "/" <> without_trailing
      }
    }
  }
}
