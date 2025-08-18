// Main.qml
import QtQuick
import QtQuick.Controls
import "Components"

Window {
    id: mainWin
    visible: true
    width: 1920
    height: 800
    title: "Metrics Diary"
    color: "white"

    property var metrics: ({
        "2025-08-03": 9,
        "2025-08-12": 7,
        "2025-08-21": 4
    })

    YearView {
        id: yearView
        anchors.fill: parent
        year: new Date().getFullYear()
        viewportWidth: mainWin.width
        metricsByDate: mainWin.metrics
    }
}
// MonthGrid {
//     id: monthView
//     anchors.fill: parent
//     anchors.margins: 12
//     year: 2025
//     month: 8
//     metricsByDate: root.metrics
//     mondayFirst: true
//     viewportWidth: root.width

//     onDayActivated: (iso) => {
//         console.log("clicked:", iso)
//     }
// }
