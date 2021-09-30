# SPDX-FileCopyrightText: 2020 Carl Schwan <carl@carlschwan.eu>
#
# SPDX-License-Identifier: BSD-2-Clause

ecm_create_qm_loader(texteditor_QM_LOADER libtexteditorplugin_qt)

set(
    sources
    code/texteditor_plugin.cpp
    code/documenthandler.cpp
    ${texteditor_QM_LOADER}
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

if (BUILD_SHARED_LIBS)
    add_custom_target(copy_to_bin ALL
        COMMAND ${CMAKE_COMMAND} -E
                make_directory ${CMAKE_BINARY_DIR}/bin/org/mauikit/texteditor/
        COMMAND ${CMAKE_COMMAND} -E
                copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/controls ${CMAKE_BINARY_DIR}/bin/org/mauikit/texteditor/
        COMMAND ${CMAKE_COMMAND} -E
                copy $<TARGET_FILE:MauiKitTextEditor> ${CMAKE_BINARY_DIR}/bin/org/mauikit/texteditor/
    )

    install(DIRECTORY controls/ DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/texteditor)

    #include(ECMGeneratePriFile)
    #ecm_generate_pri_file(BASE_NAME KQuickImageEditor LIB_NAME KQuickImageEditor DEPS "core qml quick svg" FILENAME_VAR PRI_FILENAME )
    #install(FILES ${PRI_FILENAME}
            #DESTINATION ${ECM_MKSPECS_INSTALL_DIR})

endif()

install(TARGETS MauiKitTextEditor DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/texteditor )
