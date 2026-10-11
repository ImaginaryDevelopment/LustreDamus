export function get_item(key) {
  try {
    return globalThis.localStorage?.getItem(key) ?? ""
  } catch {
    return ""
  }
}

export function set_item(key, value) {
  try {
    globalThis.localStorage?.setItem(key, value)
  } catch {
    // ignore quota / private mode
  }
}
