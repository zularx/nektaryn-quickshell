import QtQuick
import Quickshell
import Quickshell.Io 

Rectangle {
    id: updatesArea
    property int updateCount: 0
    property var lastCheckTime: new Date()

    color: mouseArea.containsMouse ? "#828282" : "#99828282"
    height: 35
    width: 60
    radius: 5
    
    Behavior on color {
        ColorAnimation { duration: 200 }
    }    

    Component.onCompleted: {
        updateCheckProcess.running = true
        lastCheckTime = new Date()
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor

        
        Row {
            id: updatesText
            spacing: 6
            anchors.centerIn: parent

            Text{
                text: "󰚰"
                anchors.verticalCenter: parent.verticalCenter
                font.family: "MapleMono NF"
                font.pixelSize: 20
                color: updatesArea.updateCount > 0 ? "#FF9090" : "#FFFFFF"

            }

            Text {
                text: updatesArea.updateCount.toString()
                font.family: "MapleMono NF"
                font.pixelSize: 20
                color: updatesArea.updateCount > 0 ? "#FF9090" : "#FFFFFF"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
    }

    Process {
        id: updateCheckProcess
        command: [Quickshell.env("HOME") + "/.config/quickshell/scripts/check-updates.sh"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                console.log("Read data from update check:", data)
                let count = parseInt(data.trim()) || 0
                console.log("Parsed update count:", count)
                updatesArea.updateCount = count
            }
        }

        onStarted: {
            console.log("Update check process started")
        }

        onExited: (exitCode, exitStatus) => {
            console.log("Process exited with code:", exitCode, "status:", exitStatus)
            if (exitCode !== 0 && !updateTimer.running) {
                console.log("Update check failed, will retry on next timer")
            }
        }
    }

    Timer {
        id: updateTimer
        interval: 300000
        running: true
        repeat: true
        triggeredOnStart: true

        onTriggered: {
            console.log("Update timer triggered")
            lastCheckTime = new Date()
            updateCheckProcess.running = true
        }
    }
}

