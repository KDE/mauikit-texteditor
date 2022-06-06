# SPDX-FileCopyrightText: 2020 Carl Schwan <carl@carlschwan.eu>
#
# SPDX-License-Identifier: BSD-2-Clause

cmake_minimum_required(VERSION 3.16)

set(KF5_VERSION "5.70.0")
set(REQUIRED_QT_VERSION 5.15.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(AUTOMOC_MOC_OPTIONS -Muri=org.mauikit.texteditor)

project(TextEditor LANGUAGES CXX VERSION 2.2.0)

find_package(ECM ${KF5_VERSION} NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(GNUInstallDirs)
include(KDEInstallDirs)
include(KDECMakeSettings)
#include(KDECompilerSettings)
include(FeatureSummary)
include(ECMPoQmTools)
include(ECMSetupVersion)
include(CMakePackageConfigHelpers)
#include(KDEFrameworkCompilerSettings NO_POLICY_SCOPE)
include(KDEPackageAppTemplates)

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/MauiKitTextEditor")

option(QUICK_COMPILER "Use QtQuick compiler to improve performance" TRUE)

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/MauiKitTextEditorConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKitTextEditorConfig.cmake"
    INSTALL_DESTINATION ${CMAKECONFIG_INSTALL_DIR}
    PATH_VARS KF5_INCLUDE_INSTALL_DIR CMAKE_INSTALL_PREFIX
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKitTextEditorConfigVersion.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKitTextEditorConfig.cmake"
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    COMPONENT Devel
)

ecm_setup_version(${PROJECT_VERSION}
    VARIABLE_PREFIX TEXTEDITOR
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/texteditor_version.h"
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/MauiKitTextEditorConfigVersion.cmake"
    SOVERSION ${PROJECT_VERSION_MAJOR}
)

if(ANDROID)
    find_package(Qt5 REQUIRED COMPONENTS AndroidExtras)
endif()

find_package(Qt5 ${REQUIRED_QT_VERSION} COMPONENTS Core Qml Quick REQUIRED)
find_package(KF5 ${REQUIRED_KF5_VERSION} REQUIRED COMPONENTS SyntaxHighlighting I18n CoreAddons)
find_package(MauiKit)
    
if(QUICK_COMPILER)
        find_package(Qt5QuickCompiler)
        set_package_properties(Qt5QuickCompiler PROPERTIES
                DESCRIPTION "Compile QML at build time"
                TYPE OPTIONAL
        )
endif()

add_subdirectory(src)

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
