cmake_minimum_required(VERSION 3.16)
project(demo1 VERSION 0.1 LANGUAGES CXX)
find_package(Qt6 REQUIRED COMPONENTS Quick Multimedia Network)
qt_standard_project_setup(REQUIRES 6.8)
qt_add_executable(demo1
    main.cpp
)
file(GLOB_RECURSE QML_COMPONENTS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} CONFIGURE_DEPENDS "components/*.qml")
qt_add_qml_module(demo1
    URI EvolveUI
    VERSION 1.0
    QML_FILES
                Main.qml
                pages/HomePage.qml
                pages/FavoritesPage.qml
                pages/SettingsPage.qml
                ${QML_COMPONENTS}
)
qt_add_resources(APP_RESOURCES
    src.qrc
)
target_sources(demo1 PRIVATE ${APP_RESOURCES})
target_link_libraries(demo1 PRIVATE Qt6::Quick Qt6::Multimedia Qt6::Network)
set_target_properties(demo1 PROPERTIES WIN32_EXECUTABLE TRUE)
