// main.cpp
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDir>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    engine.addImportPath(QDir(QCoreApplication::applicationDirPath())
                             .filePath("qt/qml"));

    engine.loadFromModule("metrics_diary", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
