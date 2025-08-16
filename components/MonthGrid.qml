// Components/MonthGrid.qml
import QtQuick
import QtQuick.Layouts
import Diary 1.0
import "."
import "Fluid.js" as U

Item {
    id: root
    // ===== входные параметры =====
    property int year: 2025
    property int month: 8             // 1..12
    property var metricsByDate: ({})  // { "YYYY-MM-DD": 1..11, ... }

    // ===== ширина окна, по которой делаем адаптацию =====
    property int viewportWidth: width

    // ====== брейкпоинты ======
    readonly property int bpLaptop: 1440
    readonly property int bpTablet: 1023
    readonly property int bpMobile: 767
    readonly property int bpMobileS: 480

    // ====== динамические отступы ======
    // отступ между ячейками
    property int gap: {
        if (viewportWidth <= bpMobileS)
            return 3
        else if (viewportWidth <= bpMobile)
            return U.fluid(viewportWidth, bpMobileS, bpMobile, 3, 4, true)
        else if (viewportWidth <= bpTablet)
            return U.fluid(viewportWidth, bpMobile, bpTablet, 4, 6, true)
        else if (viewportWidth <= bpLaptop)
            return U.fluid(viewportWidth, bpTablet, bpLaptop, 6, 8, true)
        return 8
    }
    // боковой отступ
    property int sideMargin: {
        if (viewportWidth <= bpMobileS)
            return 2
        else if (viewportWidth <= bpMobile)
            return U.fluid(viewportWidth, bpMobileS, bpMobile, 2, 3, true)
        else if (viewportWidth <= bpTablet)
            return U.fluid(viewportWidth, bpMobile, bpTablet, 3, 6, true)
        else if (viewportWidth <= bpLaptop)
            return U.fluid(viewportWidth, bpTablet, bpLaptop, 6, 10, true)
        return 10
    }

    // ====== базовый размер клетки ======
    // ширина всех ячеек = ширина контейнера - боковые отступы - промежутки
    property real cell: (viewportWidth - 2*sideMargin - 6*gap) / 7

    signal dayActivated(string isoDate)

    // модель на C++
    CalendarModel {
        id: model
        year: root.year
        month: root.month
    }

    // заголовок дней недели
    property bool mondayFirst: true
    property int headerFontSize: 14

    readonly property var namesMonFirst: ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
    readonly property var namesSunFirst: ["Вс","Пн","Вт","Ср","Чт","Пт","Сб"]
    readonly property var weekdayNames: mondayFirst ? namesMonFirst : namesSunFirst

    ColumnLayout {
        anchors.fill: parent
        spacing: gap

        // строка заголовков
        RowLayout {
            Layout.fillWidth: true
            spacing: gap
            Repeater {
                model: 7
                delegate: Text {
                    text: root.weekdayNames[index]
                    font.pixelSize: headerFontSize
                    opacity: 0.8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    Layout.fillWidth: true
                }
            }
        }

        // сама сетка 7×6
        GridView {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.leftMargin: sideMargin
            anchors.rightMargin: sideMargin

            model: model
            cellWidth:  cell
            cellHeight: cell
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            delegate: Item {
                width:  grid.cellWidth
                height: grid.cellHeight

                DayCell {
                    anchors.centerIn: parent

                    // делаем квадрат, чтобы вписался в ячейку с зазором
                    width:  parent.width
                    height: parent.height
                    viewportWidth: root.viewportWidth
                    dayNumber: model.day

                    // берём метрику из словаря, по умолчанию 0 (можешь поставить 7)
                    avrMetric: (root.metricsByDate[dateString] ?? 11)
                    opacity: inMonth ? 1.0 : 0.35

                    // клик по дню -> пробрасываем наружу ISO‑дату
                    TapHandler {
                        onTapped: root.dayActivated(dateString)
                    }
                }
            }
        }
    }
}
