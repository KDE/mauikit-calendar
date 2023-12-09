# Copyright 2018-2021 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2021 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

cmake_minimum_required(VERSION 3.16)

option(BUILD_WITH_QT5 "Use Qt 5" OFF)
option(BUILD_WITH_QT6 "Use Qt 6" OFF)

if(BUILD_WITH_QT5)
    set(QT_MAJOR_VERSION 5)
elseif(BUILD_WITH_QT6)
    set(QT_MAJOR_VERSION 6)
else()
    set(QT_MAJOR_VERSION 5)
endif()

if (QT_MAJOR_VERSION STREQUAL "6")
    set(REQUIRED_QT_VERSION 6.4)
    set(REQUIRED_KF_VERSION 5.240.0)
    set(KF_MAJOR_VERSION 6)
    set(MAUI_MAJOR_VERSION 4)

    set(MAUIKIT_VERSION 4.0.0)

else()
    set(REQUIRED_QT_VERSION 5.15.2)
    set(REQUIRED_KF_VERSION 5.96.0)

    set(KF_MAJOR_VERSION 5)
    set(MAUI_MAJOR_VERSION 3)

    set(MAUIKIT_VERSION 3.1.0)

    # set(AKONADI_VERSION 5.20.1)
    # set(AKONADI_CONTACT_VERSION 5.20.0)
    
set(AKONADI_LIB_VERSION "5.240.85")
set(AKONADICALENDAR_LIB_VERSION "5.240.85")
set(AKONADI_CONTACT_VERSION "5.240.85")
set(AKONADIMIME_LIB_VERSION "5.240.85")
set(CALENDARUTILS_LIB_VERSION "5.240.85")

    # set(CALENDARSUPPORT_LIB_VERSION 5.19)
    # set(EVENTVIEW_LIB_VERSION 5.19.0)
    # set(CALENDARUTILS_LIB_VERSION 5.23.0)
    # set(AKONADICALENDAR_LIB_VERSION 5.23.0)
endif()

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(AUTOMOC_MOC_OPTIONS -Muri=org.mauikit.calendar)

project(Calendar LANGUAGES CXX VERSION ${MAUIKIT_VERSION})

find_package(ECM ${REQUIRED_KF_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(GenerateExportHeader)
include(GNUInstallDirs)
include(FeatureSummary)
include(CMakePackageConfigHelpers)

include(KDEInstallDirs)
include(KDECMakeSettings)
include(KDECompilerSettings)
include(KDEClangFormat)
include(KDEPackageAppTemplates)

include(ECMSetupVersion)
include(ECMGenerateQmlTypes)
include(ECMGenerateHeaders)
include(ECMFindQmlModule)
include(ECMQmlModule)
include(ECMSourceVersionControl)

find_package(Qt${QT_MAJOR_VERSION} ${REQUIRED_QT_VERSION} REQUIRED COMPONENTS
    Core
    Quick
    Qml
    QuickControls2
    Svg)

if (QT_MAJOR_VERSION STREQUAL "6")
    find_package(Qt6Core5Compat REQUIRED)
endif()

find_package(KF${KF_MAJOR_VERSION} ${REQUIRED_KF_VERSION} REQUIRED COMPONENTS
    I18n
    CoreAddons
    Config)

if (QT_MAJOR_VERSION STREQUAL "5")
    find_package(Qt5QuickCompiler)
    set_package_properties(Qt5QuickCompiler PROPERTIES
        DESCRIPTION "Compile QML at build time"
        TYPE OPTIONAL)
endif()

find_package(MauiKit${MAUI_MAJOR_VERSION} ${MAUIKIT_VERSION} REQUIRED)

# find_package(KF${KF_MAJOR_VERSION}Akonadi ${AKONADI_VERSION} CONFIG REQUIRED)
# find_package(KF${KF_MAJOR_VERSION}AkonadiContact ${AKONADI_CONTACT_VERSION} CONFIG REQUIRED)
# find_package(KF${KF_MAJOR_VERSION}CalendarSupport ${CALENDARSUPPORT_LIB_VERSION} CONFIG REQUIRED)
# find_package(KF${KF_MAJOR_VERSION}EventViews ${EVENTVIEW_LIB_VERSION} CONFIG REQUIRED)

find_package(KPim${KF_MAJOR_VERSION}Akonadi ${AKONADI_LIB_VERSION} REQUIRED)
find_package(KPim${KF_MAJOR_VERSION}AkonadiCalendar ${AKONADICALENDAR_LIB_VERSION} REQUIRED)
find_package(KPim${KF_MAJOR_VERSION}AkonadiContactCore ${AKONADI_CONTACT_VERSION} REQUIRED)
find_package(KPim${KF_MAJOR_VERSION}AkonadiMime ${AKONADIMIME_LIB_VERSION} REQUIRED)
find_package(KPim${KF_MAJOR_VERSION}CalendarUtils ${CALENDARUTILS_LIB_VERSION} REQUIRED)

if(${ECM_SOURCE_UNDER_VERSION_CONTROL})
    execute_process(
        COMMAND git rev-parse --abbrev-ref HEAD
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_BRANCH
        OUTPUT_STRIP_TRAILING_WHITESPACE)

    # Get the latest abbreviated commit hash of the working branch
    execute_process(
        COMMAND git log -1 --format=%h
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE GIT_COMMIT_HASH
        OUTPUT_STRIP_TRAILING_WHITESPACE)

    add_definitions(-DGIT_COMMIT_HASH="${GIT_COMMIT_HASH}")
    add_definitions(-DGIT_BRANCH="${GIT_BRANCH}")

else()
    add_definitions(-DGIT_COMMIT_HASH="${PROJECT_VERSION}")
    add_definitions(-DGIT_BRANCH="Stable")
endif()

set(CMAKECONFIG_INSTALL_DIR "${KDE_INSTALL_CMAKEPACKAGEDIR}/MauiKitCalendar${MAUI_MAJOR_VERSION}")

ecm_setup_version(${PROJECT_VERSION}
    VARIABLE_PREFIX Calendar
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/calendar_version.h"
    PACKAGE_VERSION_FILE "${CMAKE_CURRENT_BINARY_DIR}/MauiKitCalendar${MAUI_MAJOR_VERSION}ConfigVersion.cmake"
    SOVERSION ${PROJECT_VERSION_MAJOR})

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/MauiKitCalendarConfig.cmake.in.${QT_MAJOR_VERSION}"
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKitCalendar${MAUI_MAJOR_VERSION}Config.cmake"
    INSTALL_DESTINATION ${CMAKECONFIG_INSTALL_DIR}
    PATH_VARS CMAKE_INSTALL_PREFIX)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKitCalendar${MAUI_MAJOR_VERSION}ConfigVersion.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/MauiKitCalendar${MAUI_MAJOR_VERSION}Config.cmake"
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    COMPONENT Devel)

install(EXPORT MauiKitCalendar${MAUI_MAJOR_VERSION}Targets
    DESTINATION "${CMAKECONFIG_INSTALL_DIR}"
    FILE MauiKitCalendar${MAUI_MAJOR_VERSION}Targets.cmake
    NAMESPACE MauiKit${MAUI_MAJOR_VERSION}::)

install(FILES "${CMAKE_CURRENT_BINARY_DIR}/calendar_version.h"
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}/MauiKit${MAUI_MAJOR_VERSION}/Calendar
    COMPONENT Devel)

add_definitions(-DTRANSLATION_DOMAIN="mauikitcalendar")
ki18n_install(po)

add_subdirectory(src)

file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})

feature_summary(WHAT ALL INCLUDE_QUIET_PACKAGES FATAL_ON_MISSING_REQUIRED_PACKAGES)
