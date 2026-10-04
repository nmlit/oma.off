import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

Panel {
  id: root
  moduleName: "oma.off"
  ipcTarget: "oma.off"

  readonly property string powerGlyph: "\uf011"
  property bool shuttingDown: false

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  function shutdown() {
    if (shuttingDown || shutdownProc.running)
      return
    shuttingDown = true
    shutdownProc.running = true
  }

  Process {
    id: shutdownProc
    command: ["omarchy-system-shutdown"]
  }

  BarIconButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    text: root.powerGlyph
    slotSize: Style.bar.iconSlot
    tooltipText: root.opened ? "Stäng rutan" : "Stäng av"
    onPressed: function (b) {
      if (b === Qt.LeftButton)
        root.toggle()
    }
  }

  KeyboardPanel {
    id: panel
    anchorItem: button
    owner: root
    bar: root.bar
    open: root.opened
    focusTarget: keyCatcher
    contentWidth: panel.fittedContentWidth(Style.space(220))
    contentHeight: panel.fittedContentHeight(column.implicitHeight)

    PanelKeyCatcher {
      id: keyCatcher
      anchors.fill: parent
      onActivateRequested: root.shutdown()
      onCloseRequested: root.close()
      onTabRequested: function (direction) {
        root.switchPanel(direction)
      }

      Column {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        spacing: Style.space(16)

        Text {
          width: parent.width
          horizontalAlignment: Text.AlignHCenter
          text: root.shuttingDown ? "Stänger av…" : "Stäng av datorn?"
          color: root.bar ? root.bar.foreground : Color.foreground
          font.family: root.bar ? root.bar.fontFamily : ""
          font.pixelSize: Style.font.title
          font.bold: true
        }

        Item {
          width: parent.width
          implicitHeight: confirmButton.height

          Rectangle {
            id: confirmButton
            anchors.horizontalCenter: parent.horizontalCenter
            width: Style.space(72)
            height: Style.space(72)
            radius: width / 2
            color: confirmHover.containsMouse
              ? Qt.rgba(0.85, 0.18, 0.16, 0.22)
              : Qt.rgba(0.85, 0.18, 0.16, 0.12)
            border.width: 1
            border.color: Qt.rgba(0.85, 0.18, 0.16, 0.55)

            Text {
              anchors.centerIn: parent
              text: root.powerGlyph
              color: "#e24b4a"
              font.family: root.bar ? root.bar.fontFamily : ""
              font.pixelSize: Style.font.displayLarge
            }

            MouseArea {
              id: confirmHover
              anchors.fill: parent
              hoverEnabled: true
              cursorShape: Qt.PointingHandCursor
              enabled: !root.shuttingDown
              onClicked: root.shutdown()
            }
          }
        }

        Text {
          width: parent.width
          horizontalAlignment: Text.AlignHCenter
          visible: !root.shuttingDown
          text: "Esc stänger rutan"
          color: Qt.darker(root.bar ? root.bar.foreground : Color.foreground, 1.5)
          font.family: root.bar ? root.bar.fontFamily : ""
          font.pixelSize: Style.font.caption
        }
      }
    }
  }
}
