/// Browser storage helpers (JavaScript target).

@external(javascript, "./storage_ffi.mjs", "get_item")
pub fn get_item(key: String) -> String

@external(javascript, "./storage_ffi.mjs", "set_item")
pub fn set_item(key: String, value: String) -> Nil

@external(javascript, "./storage_ffi.mjs", "get_session_item")
pub fn get_session_item(key: String) -> String

@external(javascript, "./storage_ffi.mjs", "set_session_item")
pub fn set_session_item(key: String, value: String) -> Nil

@external(javascript, "./storage_ffi.mjs", "new_id")
pub fn new_id() -> String
