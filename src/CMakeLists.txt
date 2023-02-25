# SPDX-FileCopyrightText: 2020 Carl Schwan <carl@carlschwan.eu>
#
# SPDX-License-Identifier: BSD-2-Clause


set(
    sources
    code/texteditor_plugin.cpp
    code/documenthandler.cpp
    code/colorschemesmodel.cpp
)

set(
    pluginData
    controls/qmldir
)

if(QUICK_COMPILER)
        qtquick_compiler_add_resources(texteditor_QML_QRC resources.qrc)
else()
        qt5_add_resources(texteditor_QML_QRC resources.qrc)
endif()

add_library(
    MauiKitTextEditor
    SHARED
    ${sources}
    ${pluginData}
    ${texteditor_QML_QRC}
)

add_library(MauiKit::TextEditor ALIAS MauiKitTextEditor)

generate_export_header(MauiKitTextEditor BASE_NAME TextEditor)
set_target_properties(MauiKitTextEditor PROPERTIES
    VERSION ${TextEditor_VERSION_STRING}
    SOVERSION ${TextEditor_SOVERSION}
    EXPORT_NAME TextEditor
    )

target_include_directories(MauiKitTextEditor
    INTERFACE "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/MauiKit/TextEditor>")

target_include_directories(MauiKitTextEditor PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR};${CMAKE_CURRENT_BINARY_DIR};>")

if(QUICK_COMPILER)
    add_definitions(-DQUICK_COMPILER)
    target_compile_definitions(MauiKitTextEditor PUBLIC QUICK_COMPILER)
endif()

if(ANDROID)
    target_link_libraries(MauiKitTextEditor PRIVATE Qt5::AndroidExtras)
endif()

target_link_libraries(
    MauiKitTextEditor

    PRIVATE
        Qt5::Core
        Qt5::Quick
        Qt5::Qml
        KF5::SyntaxHighlighting
        KF5::I18n
        KF5::CoreAddons
        MauiKit
)

install(TARGETS MauiKitTextEditor EXPORT MauiKitTextEditorTargets ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

install(FILES
    ${headers}
    ${CMAKE_CURRENT_BINARY_DIR}/texteditor_export.h
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}/MauiKit/TextEditor
    COMPONENT Devel)


if (BUILD_SHARED_LIBS)
    add_custom_target(copy_to_bin ALL
        COMMAND ${CMAKE_COMMAND} -E
                make_directory ${CMAKE_BINARY_DIR}/bin/org/mauikit/texteditor/
        COMMAND ${CMAKE_COMMAND} -E
                copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/controls ${CMAKE_BINARY_DIR}/bin/org/mauikit/texteditor/
        COMMAND ${CMAKE_COMMAND} -E
                copy $<TARGET_FILE:MauiKitTextEditor> ${CMAKE_BINARY_DIR}/bin/org/mauikit/texteditor/
    )

    if(QUICK_COMPILER AND NOT ANDROID )
        install(FILES controls/qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/texteditor)
    else()
        install(DIRECTORY controls/ DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/texteditor)
    endif()
    #include(ECMGeneratePriFile)
    #ecm_generate_pri_file(BASE_NAME KQuickImageEditor LIB_NAME KQuickImageEditor DEPS "core qml quick svg" FILENAME_VAR PRI_FILENAME )
    #install(FILES ${PRI_FILENAME}
            #DESTINATION ${ECM_MKSPECS_INSTALL_DIR})

endif()

install(TARGETS MauiKitTextEditor DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/texteditor )
