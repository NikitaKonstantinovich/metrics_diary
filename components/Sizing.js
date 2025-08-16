// Components/Sizing.js
.import "Fluid.js" as U

// Брейкпоинты
const BP_L = 1440, BP_T = 1023, BP_M = 767, BP_S = 480;

// Внутренняя сторона квадрата дня (БЕЗ бордера)
function side(viewportWidth) {
    if (viewportWidth <= BP_S) return 22;                                     // S
    if (viewportWidth <= BP_M) return U.fluid(viewportWidth, BP_S, BP_M, 22, 28, true);
    if (viewportWidth <= BP_T) return U.fluid(viewportWidth, BP_M, BP_T, 28, 36, true);
    if (viewportWidth <= BP_L) return U.fluid(viewportWidth, BP_T, BP_L, 36, 40, true);
    return 40;                                                                // ≥L
}

// Толщина бордера
function borderWidth(viewportWidth) {
    if (viewportWidth <= BP_S) return 1;
    if (viewportWidth <= BP_M) return U.fluid(viewportWidth, BP_S, BP_M, 1, 2, true);
    if (viewportWidth <= BP_T) return U.fluid(viewportWidth, BP_M, BP_T, 2, 3, true);
    if (viewportWidth <= BP_L) return U.fluid(viewportWidth, BP_T, BP_L, 3, 4, true);
    return 4;
}

// Отступ между ячейками (канал), ограниченный 3..8
function gap(viewportWidth) {
    if (viewportWidth <= BP_S) return 3;
    if (viewportWidth <= BP_M) return U.fluid(viewportWidth, BP_S, BP_M, 3, 4, true);
    if (viewportWidth <= BP_T) return U.fluid(viewportWidth, BP_M, BP_T, 4, 6, true);
    if (viewportWidth <= BP_L) return U.fluid(viewportWidth, BP_T, BP_L, 6, 8, true);
    return 8;
}

// Боковые поля контейнера, ограниченные 2..10
function sideMargin(viewportWidth) {
    if (viewportWidth <= BP_S) return 2;
    if (viewportWidth <= BP_M) return U.fluid(viewportWidth, BP_S, BP_M, 2, 3, true);
    if (viewportWidth <= BP_T) return U.fluid(viewportWidth, BP_M, BP_T, 3, 6, true);
    if (viewportWidth <= BP_L) return U.fluid(viewportWidth, BP_T, BP_L, 6, 10, true);
    return 10;
}

// Размер шрифта заголовков дней недели
function headerFont(viewportWidth) {
    if (viewportWidth <= BP_S) return 11;
    if (viewportWidth <= BP_M) return U.fluid(viewportWidth, BP_S, BP_M, 11, 12, true);
    if (viewportWidth <= BP_T) return U.fluid(viewportWidth, BP_M, BP_T, 12, 14, true);
    if (viewportWidth <= BP_L) return U.fluid(viewportWidth, BP_T, BP_L, 14, 16, true);
    return 16;
}

// ===== Размеры шрифтов =====
const fzLaptop = 32
const fzTablet = 30
const fzMobile = 22
const fzMobileS = 16

// ===== Функция для адаптивного размера шрифта =====
function fontSizeByWidth(w) {
    // Mobile S (≤480): фиксировано 16
    if (w <= BP_S) return fzMobileS;
    // 481..767: интерполяция 16 → 22
    if (w <= BP_M)
        return U.fluid(w, BP_S, BP_M, fzMobileS, fzMobile, true);
    // 768..1023: интерполяция 22 → 30
    if (w <= BP_T)
        return U.fluid(w, BP_M, BP_T, fzMobile, fzTablet, true);
    // 1024..1440: интерполяция 30 → 32
    if (w <= BP_L)
        return U.fluid(w, BP_T, BP_L, fzTablet, fzLaptop, true);
    // >1440: фиксировано 32
    return fzLaptop;
}
