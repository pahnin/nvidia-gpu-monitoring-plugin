import QtQuick
import Quickshell.Io
import qs.Services.UI

Item {
  id: root
  property var pluginApi: null
  property real gpuMemPercent: 0
  property real gpuCoreUtil: 0
  property real gpuTemp: 0
  property bool gpuAvailable: false

  property string gpuMemUsedGB: "0"
  property string gpuMemTotalGB: "0"

  Timer {
    interval: 250
    running: true
    repeat: true
    onTriggered: gpuProcess.running = true
  }

Process {
  id: gpuProcess

  command: [
    "nvidia-smi",
    "--query-gpu=memory.used,memory.total,utilization.gpu,temperature.gpu",
    "--format=csv,noheader,nounits"
  ]

  stdout: StdioCollector {
    onStreamFinished: {
      let output = this.text.trim()
      if (!output) return

      // "3560, 16311, 12, 38"
      let parts = output.split(",")

      if (parts.length >= 4) {
        let used = parseFloat(parts[0])
        let total = parseFloat(parts[1])
        let util = parseFloat(parts[2])
        let temp = parseFloat(parts[3])

        root.gpuTemp = temp
        root.gpuCoreUtil = util

        root.gpuMemPercent = (used / total) * 100

        root.gpuMemUsedGB = (used / 1024).toFixed(2)
        root.gpuMemTotalGB = (total / 1024).toFixed(2)

        root.gpuAvailable = true
      }
    }
  }

  stderr: StdioCollector {}

  onExited: (code) => {
    if (code !== 0) root.gpuAvailable = false
  }
}

  IpcHandler {
    target: "plugin:nvidia-gpu-monitor"
    function setMessage(message: string) {
      if (pluginApi && message) {
        // Update the plugin settings object
        pluginApi.pluginSettings.message = message;

        // Save to disk
        pluginApi.saveSettings();

        // Show confirmation
        ToastService.showNotice("Message updated to: " + message);
      }
    }
    function toggle() {
      if (pluginApi) {
        pluginApi.withCurrentScreen(screen => {
          pluginApi.openPanel(screen);
        });
      }
    }
  }
}