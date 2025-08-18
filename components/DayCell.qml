// Components/DayCell.qml
import QtQuick
import QtQuick.Controls

Rectangle {
    id: cell

    // ===== Палитра =====
    property color white: "#FFFFFF"
    property color black: "#000000"

    property color red50: "#FF0000"
    property color red60: "#FF3333"
    property color red80: "#FF9999"

    property color yellow50: "#FFB900"
    property color yellow60: "#FFCE4C"
    property color yellow80: "#FFE399"

    property color green50:  "#22C55E"
    property color green60:  "#64D68E"
    property color green80:  "#A7E8BF"

    property color gray50: "#7f7f7f"
    property color gray60: "#999999"
    property color gray75: "#BFBFBF"

    property color black10: "#1A1A1A"
    property color black20: "#333333"
    property color black30: "#4D4D4D"

    property color baseBorderColor: "#D1D5DB"
    property color hoverBorderColor: "#A0A0FF"

    // ===== Градиент 1..10 + серый =====
    property var metric11: [
        "#FF0000", // 1
        "#FF2E00", // 2
        "#FF5C00", // 3
        "#FF8B00", // 4
        "#FFB900", // 5
        "#E6CF0A", // 6
        "#B5CC1F", // 7
        "#84CA34", // 8
        "#53C749", // 9
        "#22C55E", // 10
        gray75     // 11
    ]

    // ===== Входные свойства =====
    property int dayNumber: 1
    property int avrMetric: 11
    property int cellSize: 40        // ширина / высота ячейки
    property int borderW: 1          // толщина рамки
    property int borderR: 6          // радиус скругления
    property int fontPx: 60          // размер шрифта

    // ===== Геометрия =====
    implicitWidth:  cellSize
    implicitHeight: cellSize
    radius:         borderR
    color:          black20

    border.width: borderW
    border.color: hoverHandler.hovered ? hoverBorderColor : baseBorderColor

    // ===== Текст с номером дня =====
    Text {
        anchors.centerIn: parent
        text: cell.dayNumber
        font.pixelSize: cell.fontPx
        color: {
            const v = Math.max(1, Math.min(cell.avrMetric, 11))
            return cell.metric11[v - 1]
        }
    }

    // ===== Hover =====
    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse
        cursorShape: Qt.PointingHandCursor
    }

    Behavior on border.color { ColorAnimation { duration: 120 } }
}
