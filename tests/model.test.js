// Run with: node --test tests/
const test = require("node:test")
const assert = require("node:assert/strict")
const Model = require("../Model.js")

test("ownerFromEventData parses screencast events", () => {
  assert.equal(Model.ownerFromEventData("1,1"), "window")
  assert.equal(Model.ownerFromEventData("1,0"), "monitor")
  assert.equal(Model.ownerFromEventData("1,"), "monitor")
  assert.equal(Model.ownerFromEventData("0,1"), "")
  assert.equal(Model.ownerFromEventData(""), "")
})

test("markup-shaped owner is rejected", () => {
  const evil = '<img src="https://example.invalid/tracker">'
  assert.equal(Model.cleanOwner(evil), "")
  assert.equal(Model.ownerFromEventData("1," + evil), "monitor")
})
