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

    // контейнер календаря
    Item {
        id: calendarRoot
        anchors.fill: parent

        YearView {
            id: yearView
            anchors.fill: parent
            year: new Date().getFullYear()
            viewportWidth: mainWin.width
            metricsByDate: mainWin.metrics

            // проброс сигнала из YearView
            onDayActivated: (iso) => {
                details.currentDateIso = iso
                details.blurSource = calendarRoot
                details.open()
            }
        }
    }

    // оверлей-окно поверх календаря
    DayDetailsPopup {
        id: details
        parent: Overlay.overlay
        anchors.centerIn: parent
        width:  mainWin.width
        height: mainWin.height
        z: 1000
    }
}
