// Main.qml
import QtQuick
import QtQuick.Controls
import "Components"

Window {
    id: root
    width: 400
    height: 400
    visible: true
    color: "white"

    // Один пример DayCell
    DayCell {
        anchors.centerIn: parent
        dayNumber: 15
        avrMetric: 1
        viewportWidth: root.width
    }
}
