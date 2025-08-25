#pragma once
#include <QAbstractListModel>
#include <QDate>
#include <QString>
#include <QVector>

struct Note {
    quint64 id; //PK
    QDate   date;
    QString text;
};

class NotesModel : public QAbstractListModel {
    Q_OBJECT
    Q_PROPERTY(QString currentDate READ currentDate WRITE setCurrentDate NOTIFY currentDateChanged)

public:
    enum Roles {
        IdRole = Qt::UserRole + 1,
        DateRole,
        TextRole
    };
    Q_ENUM(Roles)

    explicit NotesModel(QObject* parent = nullptr);

    // Модель
    int rowCount(const QModelIndex& parent = QModelIndex()) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    // Фильтр по дате (ISO)
    QString currentDate() const { return m_currentDate; }
    void setCurrentDate(const QString& iso);

    // CRUD
    Q_INVOKABLE quint64 addNote(const QString& isoDate, const QString& text);
    Q_INVOKABLE bool updateNote(quint64 id, const QString& newText);
    Q_INVOKABLE bool deleteNote(quint64 id);

signals:
    void currentDateChanged();

private:
    void rebuildIndex();                // перестроить m_indexMap по m_currentDate
    int  findById(quint64 id) const;    // индекс в m_allNotes (не в отфильтрованной)
    static QDate parseIso(const QString& iso);

private:
    QVector<Note> m_allNotes;     // все заметки
    QVector<int>  m_indexMap;     // отображение: row модели -> индекс в m_allNotes
    QString       m_currentDate;  // "YYYY-MM-DD"
    quint64       m_nextId = 1;
};
