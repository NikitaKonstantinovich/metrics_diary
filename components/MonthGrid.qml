// Components/MonthGrid.qml
import QtQuick
import QtQuick.Layouts
import Diary 1.0
import "."
import "Fluid.js" as U
import "Sizing.js" as S

Item {
    id: root
    // ===== входные параметры =====
    property int year: 2025
    property int month: 8             // 1..12
    property var metricsByDate: ({})  // { "YYYY-MM-DD": 1..11, ... }

    // ===== ширина окна, по которой делаем адаптацию =====
    property int viewportWidth: 400

    // ====== динамические отступы ======
    // отступ между ячейками
    property int gap: S.gap(viewportWidth)
    // боковой отступ
    property int sideMargin: S.sideMargin(viewportWidth)

    // ====== базовый размер ячейки ======
    property int side: S.side(viewportWidth)
    property int cellBorder: S.borderWidth(viewportWidth)
    property int sumCellSize: side + 2 * cellBorder
    property int  fontSize: S.fontSizeByWidth(viewportWidth)

    signal dayActivated(string isoDate)

    // модель на C++
    CalendarModel {
        id: model
        year: root.year
        month: root.month
    }

    // заголовок дней недели
    property bool mondayFirst: true
    property int headerFontSize: S.headerFont(viewportWidth)

    readonly property var namesMonFirst: ["Пн","Вт","Ср","Чт","Пт","Сб","Вс"]
    readonly property var namesSunFirst: ["Вс","Пн","Вт","Ср","Чт","Пт","Сб"]
    readonly property var weekdayNames: mondayFirst ? namesMonFirst : namesSunFirst

    // Локаль
    property var ruLocale: Qt.locale("ru_RU")
    readonly property int mNorm12: Math.max(1, Math.min(12, month))
    readonly property int jsMonthIndex: mNorm12 - 1
    readonly property string monthTitle: (function () {
        // QLocale ожидает 1..12 — даём mNorm12
        const raw = ruLocale.standaloneMonthName
                  ? ruLocale.standaloneMonthName(jsMonthIndex)
                  : ruLocale.monthName(jsMonthIndex);
        // Заглавная первая буква
        return raw.length ? raw.charAt(0).toUpperCase() + raw.slice(1) : "";
    })()


    // чуть крупнее шрифт для заголовка месяца
    property int monthTitleFont: headerFontSize + 4

    // ====== базовый размер клетки ======
    property int monthWidth: (2 * sideMargin) + (7 * sumCellSize) + (6 * gap)

    Column {
        id: column
        width: root.monthWidth
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: gap

        // ===== Заголовок месяца (по центру, над днями недели) =====
        Text {
            id: title
            width: column.width
            text: root.monthTitle
            font.pixelSize: root.monthTitleFont
            font.bold: true
            opacity: 0.9
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        // строка заголовков
        Row {
            id: weekHeader
            width: column.width - 2*sideMargin
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: gap

            Repeater {
                model: 7
                delegate: Text {
                    width: (weekHeader.width - 6*gap) / 7
                    text: root.weekdayNames[index]
                    font.pixelSize: headerFontSize
                    opacity: 0.8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        // сама сетка 7×6
        GridView {
            id: grid

            width: column.width
            height: width
            anchors.horizontalCenter: parent.horizontalCenter

            interactive: false
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            // ключевой момент: «логическая клетка» включает gap
            cellWidth:  Math.floor(root.sumCellSize + root.gap)
            cellHeight: Math.floor(root.sumCellSize + root.gap)

            model: model

            delegate: Item {
                width:  grid.cellWidth
                height: grid.cellHeight

                DayCell {
                    id: tile
                    anchors.fill: parent

                    cellSize: root.sumCellSize
                    borderW: root.cellBorder
                    fontPx: root.fontSize

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
