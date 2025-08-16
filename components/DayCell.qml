// Components/DayCell.qml
// Квадрат с закруглёнными углами и «флюидными» размерами/рамкой.
// Брейкпоинты и интерполяция:
//   >1440 — 40x40
//   Tablet (1024..1440) — 36..40 (интерполяция)
//   Mobile (768..1023)  — 28..36 (интерполяция)
//   Mobile S (<=480)    — 22
// Толщина рамки: Laptop 4, Tablet 3, Mobile/Mobile S 1 (с интерполяцией на переходах).
//
// Примечание: если у вас есть свои синглтоны Scale/Theme из style/, раскомментируйте импорт Style
// и используйте их; иначе компонент работает с локальными константами.

import QtQuick
import QtQuick.Controls
import QtQuick.Window
import "Fluid.js" as U

Rectangle  {
    id: cell

    // цвета
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
    property color hoverBorderColor: "#ADD8E6"

    // Градиент 1..10 для метрик: 1 — красный, 5–6 — жёлтый, 10 — зелёный, 11 - серый (отсутствие метрик)
    property var metric11: [
        "#FF0000", // 1
        "#FF2E00", // 2
        "#FF5C00", // 3
        "#FF8B00", // 4
        "#FFB900", // 5   ≈ ярко-жёлтый
        "#E6CF0A", // 6   ≈ жёлтый
        "#B5CC1F", // 7   жёлто-зелёный
        "#84CA34", // 8
        "#53C749", // 9
        "#22C55E", // 10  зелёный
        gray75     // 11  серый
    ]

    property int baseRemPx: 16

    // ===== Брёйкпоинты =====
    readonly property int bpLaptop: 1440
    readonly property int bpTablet: 1023
    readonly property int bpMobile: 767
    readonly property int bpMobileS: 480

    // Хелперы размеров
    function rem(n)   { return Math.round(n * baseRemPx) }          // 1rem
    function space(n) { return Math.round(n * baseRemPx * 0.5) }    // шаг = 0.5rem

    // ====== Целевые размеры по точкам ======
    readonly property int sizeLaptop:  40
    readonly property int sizeTablet:  36
    readonly property int sizeMobile:  28
    readonly property int sizeMobileS: 22

    // ====== Толщина рамки по точкам ======
    readonly property int bwLaptop: 4
    readonly property int bwTablet: 3
    readonly property int bwMobile: 1
    readonly property int bwMobileS: 1

    // ===== Размер шрифта числа дня: =====
    // Laptop+=32, Tablet=30, Mobile=22, Mobile S=16 + интерполяция между диапазонами
    readonly property int fzLaptop: 28
    readonly property int fzTablet: 26
    readonly property int fzMobile: 22
    readonly property int fzMobileS: 16

    // ====== бордеры, радиусы ======
    readonly property int borderWidthL: 4
    readonly property int borderWidthM: 3
    readonly property int borderWidthS: 1

    readonly property int radiusL: 12
    readonly property int radiusM: 10
    readonly property int radiusS: 6
    readonly property int radiusXs: 2

    // ====== Текущая ширина окна ======
    property int viewportWidth: 100

    // ====== Вычисление стороны квадрата с учётом брейкпоинтов ======
    function calcSide(w) {
        // Mobile S (≤480): фиксировано 22
        if (w <= bpMobileS) return sizeMobileS;
        // 481..767: интерполяция 22 → 28
        if (w <= bpMobile)
            return U.fluid(w, bpMobileS, bpMobile, sizeMobileS, sizeMobile, true);
        // 768..1023: интерполяция 28 → 36
        if (w <= bpTablet)
            return U.fluid(w, bpMobile, bpTablet, sizeMobile, sizeTablet, true);
        // 1024..1440: интерполяция 36 → 40
        if (w <= bpLaptop)
            return U.fluid(w, bpTablet, bpLaptop, sizeTablet, sizeLaptop, true);
        // >1440: фиксировано 40
        return sizeLaptop;
    }

    // ====== Вычисление толщины рамки ======
    function calcBorderWidth(w) {
        // Mobile S/Mobile (≤767): фиксировано 1
        if (w <= bpMobile) return bwMobile;
        // 768..1023: интерполяция 1 → 3
        if (w <= bpTablet)
            return U.fluid(w, bpMobile, bpTablet, bwMobile, bwTablet, true);
        // 1024..1440: интерполяция 3 → 4
        if (w <= bpLaptop)
            return U.fluid(w, bpTablet, bpLaptop, bwTablet, bwLaptop, true);
        // >1440: фиксировано 4
        return bwLaptop;
    }

    // ====== Вычисление радиуса ======
    function calcBorderRadius(w) {
        // Mobile S/Mobile (≤767): фиксировано 6
        if (w <= bpMobile) return radiusS;
        // 768..1023: интерполяция 6 → 10
        if (w <= bpTablet)
            return U.fluid(w, bpMobile, bpTablet, radiusS, radiusM, true);
        // 1024..1440: интерполяция 10 → 12
        if (w <= bpLaptop)
            return U.fluid(w, bpTablet, bpLaptop, radiusM, radiusL, true);
        // >1440: фиксировано 12
        return radiusL;
    }

    // ====== Вычисление размера шрифта ======
    function fontSizeByWidth(w) {
        // Mobile S (≤480): фиксировано 16
        if (w <= bpMobileS) return fzMobileS;
        // 481..767: интерполяция 16 → 22
        if (w <= bpMobile)
            return U.fluid(w, bpMobileS, bpMobile, fzMobileS, fzMobile, true);
        // 768..1023: интерполяция 22 → 30
        if (w <= bpTablet)
            return U.fluid(w, bpMobile, bpTablet, fzMobile, fzTablet, true);
        // 1024..1440: интерполяция 30 → 32
        if (w <= bpLaptop)
            return U.fluid(w, bpTablet, bpLaptop, fzTablet, fzLaptop, true);
        // >1440: фиксировано 32
        return fzLaptop;
    }


    // ====== Геометрия ======
    width:  calcSide(viewportWidth)
    height: width
    radius: calcBorderRadius(viewportWidth)
    color:  black20

    // ====== Рамка с «флюидной» толщиной ======
    border.width: calcBorderWidth(viewportWidth)
    border.color: hoverHandler.hovered ? hoverBorderColor : baseBorderColor

    // ====== Публичные свойства (задаются из родителя) =====
    property int avrMetric: 11
    property int dayNumber: 12

    // ===== Текст с номером дня (по центру) =====
    Text {
        anchors.centerIn: parent
        text: cell.dayNumber
        font.pixelSize: fontSizeByWidth(cell.viewportWidth)
        color: metric11[Math.max(1, Math.min(cell.avrMetric, 11)) - 1]
    }

    // ====== Ховер ======
    HoverHandler {
        id: hoverHandler
        acceptedDevices: PointerDevice.Mouse
        cursorShape: Qt.PointingHandCursor
    }

    // ====== Плавная анимация смены цвета рамки ======
    Behavior on border.color { ColorAnimation { duration: 120 } }
}
