import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Ui
import qs.Commons

BarWidget {
  id: root
  moduleName: "dizziee.screenshare-icon"
  property bool active: false
  property string owner: ""

  function refresh() {
    if (!ssProc.running) ssProc.running = true
  }

  // Hyprland announces capture clients on socket2 as "screencast>>state,owner"
  // (state 0/1, owner 0 = monitor, 1 = window). Starts show instantly; stops
  // are verified against PipeWire because the event carries no client id and
  // parallel shares would otherwise desync the count.
  Connections {
    target: Hyprland
    function onRawEvent(event) {
      if (!event || event.name !== "screencast") return
      const parts = String(event.data).split(",")
      if (parts[0] === "1") {
        root.active = true
        root.owner = parts[1] === "1" ? "window" : "monitor"
      } else if (root.active) {
        root.refresh()
      }
    }
  }

  Process {
    id: ssProc
    command: ["pw-dump"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.updateStatus(text)
    }
  }

  function updateStatus(text) {
    try {
      var nodes = JSON.parse(String(text || "[]"))
      root.active = nodes.some(function(node) {
        if (node.type !== "PipeWire:Interface:Node") return false
        var info = node.info || {}
        var props = info.props || {}
        return String(props["node.name"] || "").indexOf("xdg-desktop-portal") !== -1
            && props["media.class"] === "Video/Source"
            && info.state === "running"
      })
      if (!root.active) root.owner = ""
    } catch (e) { root.active = false }
  }

  // Resync: catches device/camera portal shares that never reach Hyprland's
  // screencast protocol and heals missed socket2 events. Slow while idle —
  // each pw-dump is ~200KB of JSON parsed in the shell thread — and fast
  // while a share is live so its end is noticed within seconds even if the
  // stop event is missed.
  Timer {
    id: resyncTimer
    interval: root.active ? 5000 : 120000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.refresh()
  }

  // Apply the new cadence immediately on state flips instead of waiting out
  // the old interval (avoids a 2-minute lag detecting a share's end, and a
  // 5-second hot loop after it ends).
  onActiveChanged: resyncTimer.restart()

  visible: active

  implicitWidth: visible ? button.implicitWidth : 0
  implicitHeight: visible ? button.implicitHeight : 0

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: "👀"
    fixedWidth: root.bar && root.bar.vertical ? -1 : Style.space(27)
    fixedHeight: root.bar && root.bar.vertical ? Style.space(26) : -1
    tooltipText: root.active ? "Screen sharing active (" + root.owner + ")" : "ScreenSharing Active"
  }
}
