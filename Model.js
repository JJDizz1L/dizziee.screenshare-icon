// screencast owner comes from Hyprland socket2 (local, but not ours to
// trust). Only the two known scopes pass through.
var KNOWN_OWNERS = ["window", "monitor"]

function cleanOwner(value) {
  var next = typeof value === "string" ? value.trim() : ""
  return KNOWN_OWNERS.indexOf(next) !== -1 ? next : ""
}

function ownerFromEventData(data) {
  var parts = String(data || "").split(",")
  if (parts[0] === "1") {
    return parts[1] === "1" ? "window" : "monitor"
  }
  return ""
}

if (typeof module !== "undefined") {
  module.exports = {
    cleanOwner: cleanOwner,
    ownerFromEventData: ownerFromEventData,
    KNOWN_OWNERS: KNOWN_OWNERS
  }
}
