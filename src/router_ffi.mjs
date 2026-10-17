/** Current location hash without the leading `#` (may be empty). */
export function get_hash() {
  try {
    const h = globalThis.location?.hash ?? ""
    return h.startsWith("#") ? h.slice(1) : h
  } catch {
    return ""
  }
}

/** Set location hash to `path` (e.g. `/` or `/s/raid-targets`). */
export function set_hash(path) {
  try {
    const next = normalize_hash_path(path)
    if (hash_equivalent(get_hash(), next)) return
    globalThis.location.hash = next
  } catch {
    // ignore
  }
}

function normalize_hash_path(path) {
  const raw = String(path ?? "").trim()
  if (raw === "" || raw === "/") return "/"
  return raw.startsWith("/") ? raw : "/" + raw
}

function hash_equivalent(a, b) {
  const norm = (h) => {
    const s = String(h ?? "").replace(/^#/, "")
    if (s === "" || s === "/") return "/"
    return s.startsWith("/") ? s : "/" + s
  }
  return norm(a) === norm(b)
}

/** Subscribe to hashchange; callback receives hash without `#`. */
export function on_hash_change(callback) {
  try {
    globalThis.addEventListener?.("hashchange", () => {
      callback(get_hash())
    })
  } catch {
    // ignore
  }
}
