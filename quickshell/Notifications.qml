import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    width: 35
 	height: 35
    color: mouseArea.containsMouse ? "#828282" : "#99828282"
    radius: 6

    Behavior on color {
        ColorAnimation { duration: 200 }
    }

    Text {
        anchors.centerIn: parent
		text: ""                     			
		color: "#FFFFFF"
        font.family: "Jetbrains Mono"
        font.pixelSize: 25
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
		onClicked: {
    	    var proc = Qt.createQmlObject('import Quickshell.Io; Process { running: true }', root);
    		proc.command = ["swaync-client", "-t", "-sw"];
		}
	}
}
