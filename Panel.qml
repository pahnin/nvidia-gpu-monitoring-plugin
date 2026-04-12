import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Services.UI
import qs.Widgets

// Panel Component - Focused purely on GPU metrics
Item {
  id: root

  // Plugin API (injected by PluginPanelSlot)
  property var pluginApi: null
  property var gpuCoreUtil: pluginApi?.mainInstance?.gpuCoreUtil
  property var gpuMemPercent: pluginApi?.mainInstance?.gpuMemPercent
  property var gpuTemp: pluginApi?.mainInstance?.gpuTemp
  property var gpuAvailable: pluginApi?.mainInstance?.gpuAvailable
  property var gpuMemUsedGB: pluginApi?.mainInstance?.gpuMemUsedGB
  property var gpuMemTotalGB: pluginApi?.mainInstance?.gpuMemTotalGB
  property var gpuName: pluginApi?.mainInstance?.gpuName

  // SmartPanel
  readonly property var geometryPlaceholder: panelContainer

  property real contentPreferredWidth: 440 * Style.uiScaleRatio
  property real contentPreferredHeight: 580 * Style.uiScaleRatio

  readonly property bool allowAttach: true
  anchors.fill: parent

  Component.onCompleted: {
    if (pluginApi) {
      Logger.i("HelloWorld", "Panel initialized");
    }
  }

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"

    ColumnLayout {
      anchors {
        fill: parent
        margins: Style.marginL
      }
      spacing: Style.marginL

      // Content area - GPU Monitoring Only
      Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: Color.mSurfaceVariant
        radius: Style.radiusL

        ColumnLayout {
          anchors.centerIn: parent
          spacing: Style.marginM

          // Header
          NText {
            Layout.alignment: Qt.AlignHCenter
            text: "GPU Status"
            pointSize: Style.fontSizeL
            font.weight: Font.Bold
            color: Color.mOnSurface
          }

          // --- GPU Name ---
          RowLayout {
            Layout.fillWidth: true
            spacing: Style.marginM
            NText {
              text: "GPU Model:"
              font.pointSize: Style.fontSizeS
              color: Color.mOnSurfaceVariant
              Layout.preferredWidth: 90
            }

            NText {
              text: root.gpuName || "N/A"
                font.pointSize: Style.fontSizeS
                font.family: Settings.data.ui.fontFixed
              color: root.gpuName === "Unavailable" ? Color.mOnSurfaceVariant : Color.mOnSurface
                Layout.fillWidth: true
              }
            }

          // --- Temperature ---
            RowLayout {
              Layout.fillWidth: true
              spacing: Style.marginM

              NText {
              text: "Temp:"
                font.pointSize: Style.fontSizeS
                color: Color.mOnSurfaceVariant
              Layout.preferredWidth: 40
              }

              NText {
              text: root.gpuTemp + "°C"
                font.pointSize: Style.fontSizeS
                 font.family: Settings.data.ui.fontFixed
              color: root.gpuTemp > 85 ? "#E53935" : // Critical
                     root.gpuTemp > 60 ? "#FB8C00" : // Warning
                     root.gpuTemp > 45 ? "#FBBC04" : // High
                     Color.mOnSurface // Normal
              Layout.fillWidth: true
              }
          }

          // --- Core Utilization ---
          RowLayout {
                Layout.fillWidth: true
            spacing: Style.marginM
            NText {
              text: "Core Util:"
              font.pointSize: Style.fontSizeS
              color: Color.mOnSurfaceVariant
              Layout.preferredWidth: 80
            }

            NText {
              text: root.gpuCoreUtil + "%"
              font.pointSize: Style.fontSizeS
              font.family: Settings.data.ui.fontFixed
              color: root.gpuCoreUtil > 90 ? "#E53935" : // Critical
                     root.gpuCoreUtil > 85 ? "#FB8C00" : // Warning
                     Color.mOnSurface
              Layout.fillWidth: true
            }
          }

          // --- Memory Usage ---
          RowLayout {
            Layout.fillWidth: true
            spacing: Style.marginM

            NText {
              text: "Mem Used:"
              font.pointSize: Style.fontSizeS
              color: Color.mOnSurfaceVariant
              Layout.preferredWidth: 70
        }

            NText {
              text: root.gpuMemUsedGB + " / " + root.gpuMemTotalGB + " GB (" + root.gpuMemPercent.toFixed(1) + "%)"
              font.pointSize: Style.fontSizeS
              font.family: Settings.data.ui.fontFixed
              color: root.gpuMemPercent > 90 ? "#E53935" : // Critical
                     root.gpuMemPercent > 75 ? "#FB8C00" : // Warning
                     Color.mOnSurface
              Layout.fillWidth: true
            }
          }
        }
      }
    }
  }
}

