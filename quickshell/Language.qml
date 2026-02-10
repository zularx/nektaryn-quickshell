import Quickshell
import Quickshell.Io 
import QtQuick.Layouts
import QtQuick



Item{
    width: 90
	height: parent.height
	Text {
        id: keyboardLayout
    	text: "English"
    	color: "white"
		font.pixelSize: 25
		anchors.centerIn: parent   
        horizontalAlignment: Text.AlignHCenter
		verticalAlignment: Text.AlignVCenter
		width: 90
	    
        Behavior on text {
            SequentialAnimation {
                NumberAnimation { target: keyboardLayout; property: "opacity"; to: 0; duration: 140 }
                PropertyAction   {}
                NumberAnimation { target: keyboardLayout; property: "opacity"; to: 1; duration: 140}
            }
        }
        
    	Process {
            id: layoutProc
        	command: ["sh", "-c", "hyprctl devices -j | jq '.keyboards[] | select(.main==true) | .active_layout_index'"]

        	stdout: SplitParser {
                onRead: {
                    if (!data)
                        return

                	switch (data.trim()) {
                	case "0":
                        keyboardLayout.text = "English"
                    	break
                	case "1":
                        keyboardLayout.text = "Russian"
                    	break
                	default:
                        keyboardLayout.text = "??"
                	}
            	}
        	}

        	Component.onCompleted: running = true
    	}

    	Timer {
            interval: 100
        	running: true
       		repeat: true
        	onTriggered: layoutProc.running = true
    	}
	}
}
