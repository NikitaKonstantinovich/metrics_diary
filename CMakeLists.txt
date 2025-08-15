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
        QML_FILES style/variables.qml
        QML_FILES style/Scale.qml
        QML_FILES style/Variables.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appmetrics_diary PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appmetrics_diary
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appmetrics_diary
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appmetrics_diary
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
