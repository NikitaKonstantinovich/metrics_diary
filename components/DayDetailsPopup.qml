// Components/DayDetailsPopup.qml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import Diary 1.0
import "."

Popup {
    id: popup
    modal: true
    focus: true
    closePolicy: Popup.CloseOnEscape

    // === РАЗМЫТИЕ ФОНА ===
    // ожидаем, что родитель передаст нам ref на календарь (или весь root),
    // либо просто ставим подложку с затемнением.
    property Item blurSource     // <- сюда из вне: blurSource: calendarRoot
    Rectangle { anchors.fill: parent; color: "#00000080" } // затемнение
    // MultiEffect {
    //     anchors.fill: parent
    //     source: popup.blurSource
    //     blurEnabled: true
    //     blur: 0.6
    //     saturation: 1.0
    //     brightness: 1.0
    // }

    // === ДАТА, ДЛЯ КОТОРОЙ ОТКРЫТА ПАНЕЛЬ ===
    property string currentDateIso: ""

    background: Rectangle {
        color: "#13131A"
        radius: 12
        border.color: "#2A2A35"
        anchors.margins: 48
    }

    contentItem: Item {
        anchors.fill: parent
        anchors.margins: 48

        // кнопка закрытия
        ToolButton {
            anchors.top: parent.top
            anchors.right: parent.right
            text: "✖"
            background: Rectangle { color: "#8B0000"; radius: 8 }
            onClicked: popup.close()
            Accessible.name: "Close day details"
        }

        // Две равные колонки
        RowLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 16

            // ====== ЛЕВО: КОММЕНТАРИИ ======
            Frame {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 10

                    Label {
                        text: "Comments — " + (popup.currentDateIso || "—")
                        font.bold: true
                        font.pixelSize: 16
                    }

                    // редактор + Save
                    RowLayout {
                        Layout.fillWidth: true

                        TextArea {
                            id: editor
                            Layout.fillWidth: true
                            Layout.preferredHeight: 90
                            placeholderText: "Write a comment…"
                            wrapMode: TextEdit.Wrap
                        }
                        Button {
                            text: "Save"
                            enabled: editor.text.length > 0 && popup.currentDateIso.length > 0
                            onClicked: {
                                notes.addNoteNow(editor.text)    // сохраняем с текущим временем
                                editor.text = ""
                                list.positionViewAtBeginning()   // новые сверху — пролистаем к началу
                            }
                        }
                    }

                    // список (новые сверху)
                    ListView {
                        id: list
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        spacing: 6
                        model: notes

                        delegate: Rectangle {
                            width: ListView.view.width
                            radius: 8
                            color: "#1C1C25"
                            border.color: "#2E2E3A"
                            height: Math.max(48, textItem.paintedHeight + 20)

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 8

                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 2
                                    Label {
                                        text: model.createdAtDisplay    // "hh:mm dd.MM"
                                        opacity: 0.7
                                        font.pixelSize: 12
                                    }
                                    Text {
                                        id: textItem
                                        text: model.text.length ? model.text : "(empty)"
                                        wrapMode: Text.Wrap
                                        Layout.fillWidth: true
                                    }
                                }

                                // Корзина справа
                                ToolButton {
                                    text: "🗑"
                                    onClicked: confirmDelete.open(model.id)
                                    Accessible.name: "Delete comment"
                                }
                            }
                        }
                    }
                }
            }
            // ====== ПРАВО: МЕТРИКИ (пока заглушка) ======
            Frame {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Label {
                    anchors.centerIn: parent
                    text: "Metrics — soon"
                    opacity: 0.5
                }
            }
        }
    }

    // Локальная модель для этой панели
    NotesModel {
        id: notes
        currentDate: popup.currentDateIso
    }

    // Подтверждение удаления
    Dialog {
        id: confirmDelete
        modal: true
        property var _idToDelete: 0
        title: "Delete comment?"
        standardButtons: Dialog.Ok | Dialog.Cancel
        onAccepted: {
            if (_idToDelete) notes.deleteNote(_idToDelete)
            _idToDelete = 0
        }
        onRejected: _idToDelete = 0

        function open(id) {
            _idToDelete = id
            confirmDelete.open()
        }
        contentItem: Column {
            spacing: 8
            padding: 12
            Label { text: "Are you sure you want to delete this comment?" }
        }
    }
}



