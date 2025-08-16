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

    property var metrics: ({
        "2025-08-03": 9,
        "2025-08-12": 7,
        "2025-08-21": 4
    })

    MonthGrid {
        id: monthView
        anchors.fill: parent
        anchors.margins: 12
        year: 2025
        month: 8
        metricsByDate: root.metrics
        mondayFirst: true

        onDayActivated: (iso) => {
            console.log("clicked:", iso)
        }
    }
}
