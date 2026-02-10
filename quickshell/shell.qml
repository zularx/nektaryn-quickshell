import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import "Language.qml"
import "SteamWidget.qml"
import "Updates.qml"

PanelWindow{
    id: shellRoot

    property int volumeLevel: 0
    property int cpuUsage: 0
    property int memUsage: 0 
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0
    property bool isVisibleCalendar: false
    property var capsIsActive: 0
    property bool isVisibleMusic: false
    property bool isSteamRunning: false
    property string activeWindow: "Window"
    
    Process {
        id: capsCheckProc
        command: ["sh", "-c", "cat /sys/class/leds/input*::capslock/brightness 2>/dev/null | head -n1"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return;
                let val = data.trim()
                capsIsActive = (val === "1") ? 2 : 0;
                console.log(capsIsActive)
            }
        }
    }

    Process {
        id: volProc
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var match = data.match(/Volume:\s*([\d.]+)/)
                if (match) {
                    volumeLevel = Math.round(parseFloat(match[1]) * 100)
                }
            }
        }
        Component.onCompleted: running = true
    }
    
    Process {
        id: memProc
        command: ["sh", "-c", "free -g |grep Mem| awk '{print $3}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                memUsage = this.text.trim() 
                console.log(memUsage)
            }
        }
    }
    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) return
                var parts = data.trim().split(/\s+/)
                var user = parseInt(parts[1]) || 0
                var nice = parseInt(parts[2]) || 0
                var system = parseInt(parts[3]) || 0
                var idle = parseInt(parts[4]) || 0
                var iowait = parseInt(parts[5]) || 0
                var irq = parseInt(parts[6]) || 0
                var softirq = parseInt(parts[7]) || 0

                var total = user + nice + system + idle + iowait + irq + softirq
                var idleTime = idle + iowait

                if (lastCpuTotal > 0) {
                    var totalDiff = total - lastCpuTotal
                    var idleDiff = idleTime - lastCpuIdle
                    if (totalDiff > 0) {
                        cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff)
                    }
                }
                lastCpuTotal = total
                lastCpuIdle = idleTime
            }
        }
        Component.onCompleted: running = true
    }

    // Active window title
    Process {
        id: windowProc
        command: ["hyprctl", "activewindow", "-j"]
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const obj = JSON.parse(this.text)
                    activeWindow = obj.class ?? ""
                } catch (e) {
                    activeWindow = ""
                }
            }
        }
    }
    Timer {
        interval: 100
        running: true
        repeat: true
        onTriggered: {
            windowProc.running = true
        }
    }
    Timer {
        interval: 20
        running: true
        repeat: true
        onTriggered: {
            capsCheckProc.running = true
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            steamCheckProc.running = true
        }
    }

    anchors { 
        top: true
        left: true
        right: true
    }
    implicitHeight: 70
    
    color: "transparent"
    
    


    Rectangle{
        id: root
        anchors.fill: parent
        color: "transparent"
        opacity: 1
        radius: 10
        anchors {
            rightMargin: 10
            leftMargin: 10
            topMargin: 10
            bottomMargin: 10
        }
        

        // LEFT SECTION
        Rectangle{
            color: "#B3101010"
            width: 530
            height: 50
            radius: 20
            Row {
                anchors.fill: parent
                width: 400
                anchors.leftMargin: 28
                Updates{
                    anchors.verticalCenter: parent.verticalCenter
                }
                Rectangle{
                    width: 300
                    height: 35
                    color: "#99828282"
                    radius: 10
                    clip: true
                    anchors.centerIn: parent
                    Text {
                        id: windowText
                        text: activeWindow === "kitty" ? "   Kitty" : activeWindow === "zen" ? "󰖟   zen-browser" : activeWindow === "discord" ? "   Discord" : activeWindow === "org.telegram.desktop" ? "   Telegram" : activeWindow === "com.github.neithern.g4music" ? "󰌳   Gapless music player" : activeWindow === "thunar" ? "   Thunar file manager" : activeWindow === "org.prismlauncher.PrismLauncher" ? "󰍳   Minecraft" : activeWindow === "wofi" ? "   Wofi" : activeWindow === "waypaper" ? "󰸉   Waypaper" : activeWindow === "steam" ? "   Steam" : activeWindow === "heroic" ? "   Heroic game laucher" : activeWindow === "resolve" ? "   DaVinci Resolve" : activeWindow === "code-oss" ? "   VS Code" : activeWindow === "Bitwarden" ? "   Bitwarden" : activeWindow === "obsidian" ? "   Obsidian" : activeWindow === "ONLYOFFICE" ? "   Only Office" : activeWindow === "AmneziaVPN" ? "󰒍   Amnezia VPN" : activeWindow === "com.obsproject.Studio" ? "   OBS" : activeWindow === "google-chrome" ? "   Google Chrome" : activeWindow !== "" ? activeWindow : "󰇄   Desktop"
                        color: "#FFFFFF"
                        anchors.centerIn: parent
                        font.pixelSize: 20

                    }
                }
            }
        }

        // CENTER SECTION
            WorkspaceBar{}
            

        //RIGHT SECTION
        Rectangle{
            color: "#B3101010"
            width: 550
            height: 50
            radius: 20
            anchors.right: parent.right

            RowLayout{
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: 28
                width: 530

                
                Rectangle{
                    color: "#99828282"
                    radius: 5
                    width: 140
                    height: 35
                    border.width: capsIsActive
                    border.color: "#FF9090"
                    anchors.left: parent.left
                    anchors.leftMargin: 45

                    Language {
                        anchors.centerIn: parent
                    }

                    Behavior on border.width {
                        NumberAnimation { 
                            duration: 80
                            easing.type: Easing.OutCubic
                        }
                    }
                }

                Clock{
                    id: clock
                    anchors.verticalCenter: parent.verticalCenter
                    onToggleCalendar: isVisibleCalendar = !isVisibleCalendar
                    anchors.right: parent.right
                    anchors.rightMargin: 55
                }
                Notifications{
                    anchors.right: parent.right
                }
            }
        }
    }
    PanelWindow{
        width: 570
        implicitHeight: 500
        visible: isVisibleCalendar
        anchors{
            right: true
            top: true
        }
        color: "transparent"
        CalendarWidget{
            opacity: visible ? 1 : 0
            scale: visible ? 1 : 0
            Behavior on opacity{
                NumberAnimation{
                    duration: 200
                }
            }
        }
    }
}
