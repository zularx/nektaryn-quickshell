import Quickshell
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts


RowLayout{
    id: workspaceBar
    anchors.centerIn: parent
    width: 400
    height: 50
    spacing: 20
    Rectangle{
        color: "#B3101010"
        radius: 20
        anchors.fill: parent
        Row{
            anchors.centerIn: parent
            spacing: 16
                
            Repeater{
                model: 7
            
            
                Rectangle{
                    property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                    property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                    property bool isUrgent: ws?.urgent ?? false

                    color: mouseArea.containsMouse && ws ? "#b5b5b5" : mouseArea.containsMouse && !ws ? "#FFFFFF" : isUrgent ? "#FF9090" : isActive ? "#FFFFFF" :(ws ? "#FFFFFF" : "transparent")
                    Behavior on color {
                        ColorAnimation { duration: 200 }
                    }
                    width: isActive ? 80 : 30
                    height: 30
                    radius: 20
                    scale: mouseArea.containsMouse ? 1.15: isUrgent ? 1.3 : 1.0
                        
                    Behavior on width {
                        NumberAnimation{
                            duration: 200
                                easing.type: Easing.OutCubic
                        }
                    }
                    Behavior on scale {
                        NumberAnimation{
                            duration: 400
                                easing.type: Easing.OutCubic
                        }
                    }

                    Rectangle{
                        color: "transparent" 
                        anchors.centerIn: parent
                        width: 24
                        height: 24
                        radius: 20 

                        Behavior on color {
                            ColorAnimation { duration: 200 }
                        }
                        Text{
                            anchors.centerIn: parent
                            text: index + 1
                            font.pixelSize: 20
                            color: isActive ? "#101010" : isUrgent ? "#FFFFFF" : ws ? "#101010" : mouseArea.containsMouse ? "#101010" : "#FFFFFF" 
                            font.family: "Jetbrains Mono"
                            font.bold: true

                            Behavior on color {
                                ColorAnimation { duration: 200 }
                            }
                        }
                    }

                    MouseArea{
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Hyprland.dispatch("workspace " + (index + 1))
		            }

                }
            }
        }
    }
}

