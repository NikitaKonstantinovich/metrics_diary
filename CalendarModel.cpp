#include "CalendarModel.h"

CalendarModel::CalendarModel(QObject *parent)
    : QAbstractListModel(parent), m_year(QDate::currentDate().year()), m_month(QDate::currentDate().month()) {
    rebuild();
}

int CalendarModel::rowCount(const QModelIndex &) const {
    return m_days.size();
}

QVariant CalendarModel::data(const QModelIndex &index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_days.size())
        return {};

    // ===== структура одного дня: дата (QDate) и флаг «входит ли в текущий месяц» =====
    const DayEntry &day = m_days[index.row()];

    switch (role) {
    case DateRole:                  // возвращает ISO-строку YYYY-MM-DD (удобно для ключей, БД и логов)
        return day.date.toString(Qt::ISODate);
    case DayNumberRole:             // возвращает номер дня месяца (1..31)
        return day.date.day();
    case InMonthRole:               // возвращает true/false (приглушать «хвосты» предыдущего/следующего месяца в UI)
        return day.inCurrentMonth;
    default:
        return {};
    }
}

// ===== Имена ролей для QML =====
QHash<int, QByteArray> CalendarModel::roleNames() const {
    return {
        { DateRole, "dateString" },
        { DayNumberRole, "day" },
        { InMonthRole, "inMonth" }
    };
}

// ===== Сеттеры года и месяца =====
void CalendarModel::setYear(int y) {
    if (m_year == y) return;
    m_year = y;
    emit yearChanged();
    rebuild();
}

void CalendarModel::setMonth(int m) {
    if (m_month == m) return;
    m_month = m;
    emit monthChanged();
    rebuild();
}

// ===== Перестройка набора дней =====
void CalendarModel::rebuild() {
    beginResetModel();
    m_days.clear();

    QDate first(m_year, m_month, 1);
    int daysInMonth = first.daysInMonth();
    int startOffset = (first.dayOfWeek() + 6) % 7; // пн=0, вс=6

    // Предыдущий месяц
    QDate prev = first.addMonths(-1);
    int daysInPrev = prev.daysInMonth();
    for (int i = startOffset - 1; i >= 0; --i) {
        m_days.append({ QDate(prev.year(), prev.month(), daysInPrev - i), false });
    }

    // Текущий месяц
    for (int d = 1; d <= daysInMonth; ++d) {
        m_days.append({ QDate(m_year, m_month, d), true });
    }

    // Следующий месяц до 42 ячеек
    int idx = 1;
    while (m_days.size() < 42) {
        QDate next = first.addMonths(1);
        m_days.append({ QDate(next.year(), next.month(), idx++), false });
    }

    endResetModel();
}
