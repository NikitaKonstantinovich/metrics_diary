#pragma once
#include <QAbstractListModel>
#include <QDate>

struct DayEntry {
    QDate date;            // конкретная дата
    bool inCurrentMonth;   // флаг, является ли этот день частью текущего месяца
};

class CalendarModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(int year READ year WRITE setYear NOTIFY yearChanged)
    Q_PROPERTY(int month READ month WRITE setMonth NOTIFY monthChanged)

public:
    enum Roles {
        DateRole = Qt::UserRole + 1,  // ISO-строка с датой (2025-08-12)
        DayNumberRole,                // номер дня (12)
        InMonthRole                   // булевый флаг, входит ли день в текущий месяц
    };

    CalendarModel(QObject *parent = nullptr);    // Конструктор. Инициализирует модель (по умолчанию — текущий месяц).

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;  // сколько элементов в модели (например, 42 дня).
    QVariant data(const QModelIndex &index, int role) const override;        // вернуть данные для элемента с индексом row и ролью
    QHash<int, QByteArray> roleNames() const override;                       // дать имена ролям, чтобы QML мог обращаться к ним не по цифрам, а по строкам.

    // ====== Геттеры и сеттеры для свойств =====
    int year() const { return m_year; }
    int month() const { return m_month; }

    void setYear(int y);
    void setMonth(int m);

/*
    *Сигналы — это механизм Qt (как события).
    *Когда year или month меняется, мы испускаем сигнал - QML-часть узнаёт, что нужно перестроить UI.
*/
signals:
    void yearChanged();
    void monthChanged();

private:
    void rebuild();    // вспомогательная функция, которая заново пересчитывает массив дней (m_days) при изменении месяца/года.
    int m_year;        // отображаемый год
    int m_month;       // отображаемый месяц
    QList<DayEntry> m_days;  // список всех дней (42 элемента), который реально используется
};
