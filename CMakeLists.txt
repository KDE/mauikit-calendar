# Copyright 2018-2021 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2021 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

cmake_minimum_required(VERSION 3.16)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QT_MIN_VERSION "5.15.2")
set(KF5_MIN_VERSION "5.92.0")
set(KF5_VERSION "5.70.0")

set(AKONADI_VERSION "5.20.1")
set(AKONADI_CONTACT_VERSION "5.20.0")

set(CALENDARSUPPORT_LIB_VERSION "5.19")
set(EVENTVIEW_LIB_VERSION "5.19.0")

set(AUTOMOC_MOC_OPTIONS -Muri=org.mauikit.calendar)

project(Calendar LANGUAGES CXX VERSION 1.0.0)

find_package(ECM ${KF5_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(GenerateExportHeader)
include(GNUInstallDirs)
include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings)
include(FeatureSummary)
include(ECMPoQmTools)
include(ECMSetupVersion)
include(ECMGenerateQmlTypes)
include(CMakePackageConfigHelpers)
include(KDEClangFormat)
include(KDEPackageAppTemplates)

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/MauiKitCalendar")

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/MauiKitCalendarConfig.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKitCalendarConfig.cmake"
    INSTALL_DESTINATION ${CMAKECONFIG_INSTALL_DIR}
    PATH_VARS KF5_INCLUDE_INSTALL_DIR CMAKE_INSTALL_PREFIX
    )

    install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKitCalendarConfigVersion.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKitCalendarConfig.cmake"
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    COMPONENT Devel
    )

install(EXPORT MauiKitCalendarTargets
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    FILE MauiKitCalendarTargets.cmake
    NAMESPACE MauiKit::)

    ecm_setup_version(${PROJECT_VERSION}
    VARIABLE_PREFIX Calendar
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/calendar_version.h"
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/MauiKitCalendarConfigVersion.cmake"
    SOVERSION ${PROJECT_VERSION_MAJOR}
    )


install(FILES "${CMAKE_CURRENT_BINARY_DIR}/calendar_version.h"
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}/MauiKit/Calendar
    COMPONENT Devel)


find_package(Qt5 ${QT_MIN_VERSION} REQUIRED COMPONENTS Core Quick Qml QuickControls2 Svg)
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS I18n CoreAddons Config)

find_package(Qt5QuickCompiler)
set_package_properties(Qt5QuickCompiler PROPERTIES
    DESCRIPTION "Compile QML at build time"
    TYPE OPTIONAL
    )

find_package(MauiKit)

find_package(KF5Akonadi ${AKONADI_VERSION} CONFIG REQUIRED)
find_package(KF5AkonadiContact ${AKONADI_CONTACT_VERSION} CONFIG REQUIRED)
find_package(KF5CalendarSupport ${CALENDARSUPPORT_LIB_VERSION} CONFIG REQUIRED)
find_package(KF5EventViews ${EVENTVIEW_LIB_VERSION} CONFIG REQUIRED)


    add_definitions(-DTRANSLATION_DOMAIN="mauikitcalendar")
    ki18n_install(po)

    add_subdirectory(src)

    file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
