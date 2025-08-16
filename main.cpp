// main.cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "CalendarModel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    qmlRegisterType<CalendarModel>("Diary", 1, 0, "CalendarModel");

    engine.loadFromModule("metrics_diary", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
