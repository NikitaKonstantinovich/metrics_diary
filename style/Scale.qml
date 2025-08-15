pragma Singleton
import QtQuick

QtObject {
    property int baseRemPx: 16

    // Брёйкпоинты
    readonly property int bpLaptop: 1440
    readonly property int bpTablet: 1023
    readonly property int bpMobile: 767
    readonly property int bpMobileS: 480

    // Хелперы размеров
    function rem(n)   { return Math.round(n * baseRemPx) }          // 1rem
    function space(n) { return Math.round(n * baseRemPx * 0.5) }    // шаг = 0.5rem

    // «Флюидная» интерполяция между значениями
    // minV..maxV — значения в px (или rem*baseRemPx), wMin..wMax — коридор
    function fluid(maxV, minV, wMin, wMax, w) {
        if (w <= wMin) return minV;
        if (w >= wMax) return maxV;
        var t = (w - wMin) / (wMax - wMin);
        return Math.round(minV + (maxV - minV) * t);
    }
}

