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

export function new_id() {
  const t = Date.now().toString(36)
  const r = Math.random().toString(36).slice(2, 8)
  return `${t}-${r}`
}
