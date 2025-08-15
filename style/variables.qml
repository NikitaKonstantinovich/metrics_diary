pragma Singleton
import QtQuick

QtObject {
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

    property color borderColor: "#D1D5DB"

    // Градиент 1..10 для метрик: 1 — красный, 5–6 — жёлтый, 10 — зелёный
    property var metric10: [
        "#FF0000", // 1
        "#FF2E00", // 2
        "#FF5C00", // 3
        "#FF8B00", // 4
        "#FFB900", // 5   ≈ ярко-жёлтый
        "#E6CF0A", // 6   ≈ жёлтый
        "#B5CC1F", // 7   жёлто-зелёный
        "#84CA34", // 8
        "#53C749", // 9
        "#22C55E"  // 10  зелёный
    ]

    // бордеры, радиусы
    property int borderWidthL: 4
    property int borderWidthM: 3
    property int borderWidthS: 1

    property real radiusL: 12
    property real radiusM: 10
    property real radiusS: 8
    property real radiusXs: 4
}
