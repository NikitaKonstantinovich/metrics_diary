// Components/Sizing.js
.pragma library
.import "Fluid.js" as U

// Брейкпоинты
const BP_L = 1900, BP_T = 1250, BP_M = 767, BP_S = 480;

// Внутренняя сторона квадрата дня (БЕЗ бордера)
function side(viewportWidth) {
    if (viewportWidth <= BP_S) return 32;                                     // S
    if (viewportWidth <= BP_M) return U.fluid(viewportWidth, BP_S, BP_M, 32, 38, true);
    if (viewportWidth <= BP_T) return U.fluid(viewportWidth, BP_M, BP_T, 38, 40, true);
    if (viewportWidth <= BP_L) return U.fluid(viewportWidth, BP_T, BP_L, 40, 52, true);
    return 52;                                                                // ≥L
}

// Толщина бордера
function borderWidth(viewportWidth) {
    if (viewportWidth <= BP_S) return 2;
    if (viewportWidth <= BP_M) return U.fluid(viewportWidth, BP_S, BP_M, 2, 3, true);
    if (viewportWidth <= BP_T) return U.fluid(viewportWidth, BP_M, BP_T, 3, 4, true);
    if (viewportWidth <= BP_L) return U.fluid(viewportWidth, BP_T, BP_L, 4, 5, true);
    return 5;
}

// Отступ между ячейками (канал), ограниченный 2..5
function gap(viewportWidth) {
    if (viewportWidth <= BP_S) return 2;
    if (viewportWidth <= BP_M) return U.fluid(viewportWidth, BP_S, BP_M, 2, 3, true);
    if (viewportWidth <= BP_T) return U.fluid(viewportWidth, BP_M, BP_T, 3, 4, true);
    if (viewportWidth <= BP_L) return U.fluid(viewportWidth, BP_T, BP_L, 4, 5, true);
    return 5;
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
    // 768..1250: интерполяция 22 → 30
    if (w <= BP_T)
        return U.fluid(w, BP_M, BP_T, fzMobile, fzTablet, true);
    // 1250..1900: интерполяция 30 → 32
    if (w <= BP_L)
        return U.fluid(w, BP_T, BP_L, fzTablet, fzLaptop, true);
    // >1900: фиксировано 32
    return fzLaptop;
}

// ===== Колонки для YearView =====
function columns(w) {
    if (w > BP_T) return 3;     // Laptop и шире
    if (w > BP_M) return 2;     // Tablet
    return 1;                   // Mobile / Mobile S
}

// ===== Отступы между месяцами =====
function monthHeightGap(w) {
    // S: 15, M: 15..19, T: 19..21, L: 21..25
    if (w <= BP_S) return 15;
    if (w <= BP_M) return U.fluid(w, BP_S, BP_M, 15, 19, true);
    if (w <= BP_T) return U.fluid(w, BP_M, BP_T, 19, 21, true);
    if (w <= BP_L) return U.fluid(w, BP_T, BP_L, 21, 25, true);
    return 25;
}

function monthWidthGap(w) {
    // S: 16, M: 20..28, T: 28..36, L: 36..44
    if (w <= BP_S) return 16;
    if (w <= BP_M) return U.fluid(w, BP_S, BP_M, 16, 24, true);
    if (w <= BP_T) return U.fluid(w, BP_M, BP_T, 24, 26, true);
    if (w <= BP_L) return U.fluid(w, BP_T, BP_L, 26, 44, true);
    return 44;
}
