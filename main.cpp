// main.cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "CalendarModel.h"
#include "NotesModel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    qmlRegisterType<NotesModel>("Diary", 1, 0, "NotesModel");

    QQmlApplicationEngine engine;

    qmlRegisterType<CalendarModel>("Diary", 1, 0, "CalendarModel");

    engine.loadFromModule("metrics_diary", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
