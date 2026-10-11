/// Browser localStorage helpers (JavaScript target).

@external(javascript, "./storage_ffi.mjs", "get_item")
pub fn get_item(key: String) -> String

@external(javascript, "./storage_ffi.mjs", "set_item")
pub fn set_item(key: String, value: String) -> Nil
