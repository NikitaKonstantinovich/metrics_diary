cmake_minimum_required(VERSION 3.16)

project(metrics_diary VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appmetrics_diary
    main.cpp
)

qt_add_qml_module(appmetrics_diary
    URI metrics_diary
    VERSION 1.0
    QML_FILES
        Main.qml
        Components/DayCell.qml
        Components/Fluid.js
        QML_FILES Components/MonthGrid.qml
        SOURCES CalendarModel.h
        SOURCES CalendarModel.cpp
        QML_FILES Components/Sizing.js
        QML_FILES Components/YearView.qml
        SOURCES NotesModel.h
        SOURCES NotesModel.cpp
)

set_target_properties(appmetrics_diary PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appmetrics_diary
    PRIVATE Qt6::Quick
)

qt_import_qml_plugins(appmetrics_diary)

include(GNUInstallDirs)
install(TARGETS appmetrics_diary
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
