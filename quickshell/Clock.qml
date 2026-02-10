import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: clockArea
    
    width: 280
    height: 35
    radius: 5
    
    color: mouseArea.containsMouse ? "#828282" : "#99828282"
    
    signal toggleCalendar()

    Behavior on color {
        ColorAnimation { duration: 200 }
    }
    
    Text {
        id: clockText
        anchors.centerIn: parent
        font.family: "MapleMono NF"
        font.pixelSize: 25
        color: "#FFFFFF"
    }
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
	    cursorShape: Qt.PointingHandCursor

	    onClicked: {
	        toggleCalendar()
            console.log("Calendar toggle signal emited")
	    }
    }
    
    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        
        onTriggered: {
            let now = new Date()
            let day = now.getDate().toString().padStart(2, '0')
            let year = now.getFullYear()
            let hours = now.getHours()
            let minutes = now.getMinutes().toString().padStart(2, '0')
            let seconds = now.getSeconds().toString().padStart(2, '0')
            const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            // 24-hour format
            clockText.text = `${day}  ${monthNames[now.getMonth()]}  ${year}   ${hours}:${minutes}:${seconds}`
        }
    }
}
