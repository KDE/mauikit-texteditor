# SPDX-FileCopyrightText: 2020 Camilo Higuita <milo.h@aol.com>
#
# SPDX-License-Identifier: BSD-2-Clause

remove_definitions(-DQT_NO_CAST_FROM_ASCII -DQT_STRICT_ITERATORS -DQT_NO_CAST_FROM_BYTEARRAY)

ecm_add_qml_module(MauiKitTextEditor${MAUI_MAJOR_VERSION} URI "org.mauikit.texteditor" VERSION 3.0 CLASSNAME TextEditorPlugin)

set(sources
    code/texteditor_plugin.cpp
    code/documenthandler.cpp
    code/colorschemesmodel.cpp)

if(QT_MAJOR_VERSION STREQUAL "5")
    if(QUICK_COMPILER)
        qtquick_compiler_add_resources(texteditor_QML_QRC resources.qrc)
    else()
        qt5_add_resources(texteditor_QML_QRC resources.qrc)
    endif()
endif()

ecm_target_qml_sources(MauiKitTextEditor${MAUI_MAJOR_VERSION} SOURCES
    controls.${QT_MAJOR_VERSION}/TextEditor.qml)

target_sources(MauiKitTextEditor${MAUI_MAJOR_VERSION}
    PRIVATE
    ${sources})

add_library(MauiKit${MAUI_MAJOR_VERSION}::TextEditor ALIAS MauiKitTextEditor${MAUI_MAJOR_VERSION})

if (QT_MAJOR_VERSION STREQUAL "5")
    if(QUICK_COMPILER)
        target_sources(MauiKitTextEditor${MAUI_MAJOR_VERSION} PRIVATE ${texteditor_QML_QRC})

        add_definitions(-DQUICK_COMPILER)
        target_compile_definitions(MauiKitTextEditor${MAUI_MAJOR_VERSION} PUBLIC QUICK_COMPILER)
    endif()
endif()

generate_export_header(MauiKitTextEditor${MAUI_MAJOR_VERSION} BASE_NAME TextEditor)
set_target_properties(MauiKitTextEditor${MAUI_MAJOR_VERSION} PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR}
    EXPORT_NAME "TextEditor")

target_include_directories(MauiKitTextEditor${MAUI_MAJOR_VERSION}
    INTERFACE "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/MauiKit${MAUI_MAJOR_VERSION}/TextEditor>")

target_include_directories(MauiKitTextEditor${MAUI_MAJOR_VERSION} PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR};${CMAKE_CURRENT_BINARY_DIR};>")

if(ANDROID)
    target_link_libraries(MauiKitTextEditor${MAUI_MAJOR_VERSION} PRIVATE Qt${QT_MAJOR_VERSION}::AndroidExtras)
endif()

target_link_libraries(MauiKitTextEditor${MAUI_MAJOR_VERSION}
    PRIVATE
    Qt${QT_MAJOR_VERSION}::Core
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::Qml
    KF${KF_MAJOR_VERSION}::SyntaxHighlighting
    KF${KF_MAJOR_VERSION}::I18n
    KF${KF_MAJOR_VERSION}::CoreAddons
    MauiKit${MAUI_MAJOR_VERSION})

ecm_finalize_qml_module(MauiKitTextEditor${MAUI_MAJOR_VERSION} DESTINATION ${KDE_INSTALL_QMLDIR})
ecm_generate_qmltypes(org.mauikit.texteditor 3.0 DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/texteditor)

install(TARGETS MauiKitTextEditor${MAUI_MAJOR_VERSION} EXPORT MauiKitTextEditor${MAUI_MAJOR_VERSION}Targets ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

install(FILES
    ${headers}
    ${CMAKE_CURRENT_BINARY_DIR}/texteditor_export.h
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}/MauiKit${MAUI_MAJOR_VERSION}/TextEditor
    COMPONENT Devel)
