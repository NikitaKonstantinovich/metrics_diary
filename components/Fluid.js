// Components/Fluid.js
.pragma library

/**
 * Функция для «флюидной» (плавной) интерполяции значения
 *
 * @param w          (number) Текущая ширина окна/экрана, px
 * @param wMin       (number) Минимальная ширина экрана, с которой начинается интерполяция, px
 * @param wMax       (number) Максимальная ширина экрана, на которой интерполяция заканчивается, px
 * @param minValue   (number) Минимальное значение свойства (например, размер шрифта), когда ширина <= wMin
 * @param maxValue   (number) Максимальное значение свойства, когда ширина >= wMax
 * @param roundValue (bool)   Нужно ли округлять результат до целого числа (по умолчанию false)
 *
 * @return (number) Интерполированное значение в пределах [minValue..maxValue]
 */

function fluid(w, wMin, wMax, minValue, maxValue, roundValue) {
    if (w <= wMin) return minValue;
    if (w >= wMax) return maxValue;

    var t = (w - wMin) / (wMax - wMin);     // коэффициент [0..1]
    var value = minValue + (maxValue - minValue) * t;

    return roundValue ? Math.round(value) : value;
}
