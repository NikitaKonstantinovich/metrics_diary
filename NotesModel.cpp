#include "NotesModel.h"
#include <QDateTime>

NotesModel::NotesModel(QObject* parent) : QAbstractListModel(parent) {
    // по умолчанию — сегодня
    m_currentDate = QDate::currentDate().toString(Qt::ISODate);

    // демо-данные
    m_allNotes.push_back({ m_nextId++, QDate::currentDate(), QStringLiteral("Sample note #1") });
    m_allNotes.push_back({ m_nextId++, QDate::currentDate(), QStringLiteral("Sample note #2") });

    rebuildIndex();
}

int NotesModel::rowCount(const QModelIndex&) const {
    return m_indexMap.size();
}

QVariant NotesModel::data(const QModelIndex& index, int role) const {
    if (!index.isValid() || index.row() < 0 || index.row() >= m_indexMap.size())
        return {};
    const Note& n = m_allNotes[m_indexMap[index.row()]];
    switch (role) {
    case IdRole:   return QVariant::fromValue<quint64>(n.id);
    case DateRole: return n.date.toString(Qt::ISODate);
    case TextRole: return n.text;
    case CreatedAtIsoRole: return n.createdAt.toString(Qt::ISODate);
    case CreatedAtDisplayRole: return n.createdAt.toString("hh:mm dd.MM");
    default:       return {};
    }
}

QHash<int, QByteArray> NotesModel::roleNames() const {
    QHash<int, QByteArray> r;
    r[IdRole]   = "id";
    r[DateRole] = "dateString";
    r[TextRole] = "text";
    r[CreatedAtIsoRole] = "createdAtIso";
    r[CreatedAtDisplayRole] = "createdAtDisplay";
    return r;
}

void NotesModel::setCurrentDate(const QString& iso) {
    if (m_currentDate == iso) return;
    m_currentDate = iso;
    emit currentDateChanged();
    rebuildIndex();
}

quint64 NotesModel::addNoteNow(const QString& text) {
    return addNote(m_currentDate, text);
}

quint64 NotesModel::addNote(const QString& isoDate, const QString& text) {
    const QDate d = parseIso(isoDate);
    if (!d.isValid()) return 0;

    const quint64 id = m_nextId++;
    const int pos = m_allNotes.size();
    Note n;
    n.id = id;
    n.date = d;
    n.text = text;
    n.createdAt = QDateTime::currentDateTime();
    m_allNotes.push_back(std::move(n));

    // если добавили в текущую дату — отразим в фильтре
    if (isoDate == m_currentDate) {
        beginResetModel();
        m_indexMap.push_back(pos);
        std::sort(m_indexMap.begin(), m_indexMap.end(),
                  [this](int a, int b){return m_allNotes[a].createdAt > m_allNotes[b].createdAt; });
        endResetModel();
    }
    return id;
}

bool NotesModel::updateNote(quint64 id, const QString& newText) {
    const int idx = findById(id);
    if (idx < 0) return false;

    m_allNotes[idx].text = newText;

    // если этот элемент показывается сейчас — уведомим вид
    const int row = m_indexMap.indexOf(idx);
    if (row >= 0) {
        const QModelIndex mi = index(row, 0);
        emit dataChanged(mi, mi, { TextRole });
    }
    return true;
}

bool NotesModel::deleteNote(quint64 id) {
    const int idx = findById(id);
    if (idx < 0) return false;

    // если элемент отфильтрован в текущем представлении — удалим строку из модели
    const int row = m_indexMap.indexOf(idx);
    if (row >= 0) {
        beginRemoveRows(QModelIndex(), row, row);
        m_indexMap.removeAt(row);
        endRemoveRows();
    }

    // удалить сам элемент и поправить индексы больше idx
    m_allNotes.removeAt(idx);
    for (int& mapIdx : m_indexMap) {
        if (mapIdx > idx) --mapIdx;
    }
    return true;
}

void NotesModel::rebuildIndex() {
    beginResetModel();
    m_indexMap.clear();
    const QDate d = parseIso(m_currentDate);
    if (d.isValid()) {
        for (int i = 0; i < m_allNotes.size(); ++i) {
            if (m_allNotes[i].date == d)
                m_indexMap.push_back(i);
        }
        std::sort(m_indexMap.begin(), m_indexMap.end(),
                  [this](int a, int b){return m_allNotes[a].createdAt > m_allNotes[b].createdAt; });
    }
    endResetModel();
}

int NotesModel::findById(quint64 id) const {
    for (int i = 0; i < m_allNotes.size(); ++i)
        if (m_allNotes[i].id == id) return i;
    return -1;
}

QDate NotesModel::parseIso(const QString& iso) {
    return QDate::fromString(iso, Qt::ISODate); // YYYY-MM-DD
}
