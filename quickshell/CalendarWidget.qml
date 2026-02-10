import QtQuick
import Quickshell
import Quickshell.Io 


Rectangle{
    id: calendar
    radius: 12
    color: "#CC101010"
    width: 560
    height: 500
    enabled: false
    Column{
        anchors{
            fill: parent
            margins: 16
            bottomMargin: 20
        }
        spacing: 12
        Rectangle {
            id: timeSection
            width: parent.width
            height: 80
            color: "#CC49494a"
            radius: 16

            Row {
                anchors.centerIn: parent
                spacing: 8

                Text {
                    id: clockText
                    font.family: "MapleMono NF"
                    font.pixelSize: 48
                    font.weight: Font.Medium
                    color: "#FFFFFF"
                }
            }

            Timer {
                id: clockTimer
                interval: 1000
                running: shellRoot.isVisibleCalendar
                repeat: true
                triggeredOnStart: true

                onTriggered: {
                    let now = new Date()
                    let hours = now.getHours().toString().padStart(2, '0')
                    let minutes = now.getMinutes().toString().padStart(2, '0')
                    let seconds = now.getSeconds().toString().padStart(2, '0')
                    clockText.text = `${hours}:${minutes}:${seconds}`
                }
            }
        }
        Row{
            width: parent.width
            height: parent.height - 80 - 12

            Rectangle {
                width: parent.width 
                height: parent.height - 20
                anchors.centerIn: parent
                radius: 16
                color: "#CC49494a"

                Column {
                    anchors{
                        fill: parent
                        leftMargin: 14
                        rightMargin: 14
                        topMargin: 12
                        bottomMargin: 18
                    }
                    spacing: 6

                    Text {
                        width: parent.width
                        text: {
                            const now = new Date()
                            const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
                            return monthNames[now.getMonth()] + " " + now.getFullYear()
                        }
                        color: "#FFFFFF"
                        font.family: "MapleMono NF"
                        font.pixelSize: 20
                        font.weight: Font.Medium
                        horizontalAlignment: Text.AlignHCenter
                    }

                Grid {
                    width: parent.width
                    columns: 7
                    columnSpacing: 6
                    rowSpacing: 5

                    Repeater {
                        model: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]         

                        Text{
                            text: modelData
                            font.family: "MapleMono NF"
                            color: "#FFFFFF"
                            font.pixelSize: 15
                            font.weight: Font.Medium
                            width: 65
                            height: 24
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                    Repeater {
                        model: 35

                        Rectangle{
                            width: 65
                            height: 45
                            radius: 8

                            property var now: new Date()
                            property int currentDay: now.getDate()
                            property int currentMonth: now.getMonth()
                            property int currentYear: now.getFullYear()

                            property var firstDay: new Date(currentYear, currentMonth, 1)
                            property int startOffset: firstDay.getDay()
                            property int dayNumber: index - startOffset + 1
                            property var lastDay: new Date(currentYear, currentMonth + 1, 0)
                            property int daysInMonth: lastDay.getDate()
                            property bool isCurrentDay: dayNumber === currentDay
                            property bool isValidDay: dayNumber >= 1 && dayNumber <= daysInMonth


                            color: {
                                if (isValidDay && isCurrentDay) return "#FF9090"
                                return "transparent"
                            }

                            Text {
                                anchors.centerIn: parent
                                text: parent.isValidDay ? parent.dayNumber : ""
                                font.family: "MapleMono NF"
                                font.pixelSize: 15
                                color: {
                                    if (parent.isValidDay && parent.isCurrentDay) return "#000000"
                                    return "#FFFFFF"
                                }
                                font.weight: parent.isValidDay && parentisCurrentDay ? Font.DemiBold : Font.Normal
                            }
                        }
                    }
                }
            }
            }
        }
    }
}
