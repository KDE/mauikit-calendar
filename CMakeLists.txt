# Copyright 2018-2021 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2021 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

cmake_minimum_required(VERSION 3.16)

project(MauiCalendarLib VERSION ${MAUICALENDAR_VERSION})

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(QT_MIN_VERSION "5.15.2")
set(KF5_MIN_VERSION "5.92.0")

set(AKONADI_VERSION "5.19.0")
set(AKONADI_CONTACT_VERSION "5.19.0")
set(CALENDARSUPPORT_LIB_VERSION "5.19")
set(EVENTVIEW_LIB_VERSION "5.19.0")

find_package(ECM ${KF5_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(KDEInstallDirs)
include(KDECMakeSettings)
include(ECMInstallIcons)
include(ECMAddAppIcon)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDEClangFormat)
include(ECMSetupVersion)
include(ECMSourceVersionControl)
include(FeatureSummary)

find_package(Qt5 ${QT_MIN_VERSION} REQUIRED COMPONENTS Core Quick Qml)
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

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}/code
    ${CMAKE_CURRENT_SOURCE_DIR}/code/models
    )

#file(GLOB model_SRCS

#     "models/*.cpp"
#)

set(lib_SRCS
    code/plugin.cpp
#    code/calendarmanager.cpp
#    code/incidencewrapper.cpp
#    code/agentconfiguration.cpp

    code/models/infinitecalendarviewmodel.cpp
    code/models/hourlyincidencemodel.cpp
    code/models/multidayincidencemodel.cpp
    code/models/incidenceoccurrencemodel.cpp
    code/models/monthmodel.cpp
    code/models/timezonelistmodel.cpp
#    assets/assets.qrc
    )

set(lib_HDRS
    code/plugin.h
#    assets/assets.qrc
    )

qtquick_compiler_add_resources(lib_QML_QRC controls/qml.qrc)

add_library(${PROJECT_NAME}
    ${lib_SRCS}
    ${model_SRCS}
    ${lib_QML_QRC}
    )

target_link_libraries(${PROJECT_NAME}
    PRIVATE
    MauiKit

    Qt5::Core
    Qt5::Quick
    Qt5::Qml

    KF5::CoreAddons
    KF5::I18n
    KF5::ConfigCore

    KF5::CalendarCore
    KF5::AkonadiCore
    KF5::AkonadiCalendar
    KF5::AkonadiContact
    KF5::AkonadiAgentBase
    KF5::AkonadiXml
    KF5::CalendarSupport
    KF5::Contacts
    )

#install(FILES
#    ${lib_HDRS}
#    DESTINATION ${KDE_INSTALL_INCLUDEDIR}/Maui/Calendar
#    COMPONENT Devel)

set(CALENDAR_PLUGIN_DIR ${CMAKE_BINARY_DIR}/bin PARENT_SCOPE)
set(CALENDAR_PLUGIN_DIR ${CMAKE_BINARY_DIR}/bin)

if (BUILD_SHARED_LIBS)
    add_custom_target(copy_calendar_to_bin ALL
        COMMAND ${CMAKE_COMMAND} -E
        make_directory ${CALENDAR_PLUGIN_DIR}/org/maui/calendar/
        COMMAND ${CMAKE_COMMAND} -E
        copy ${CMAKE_CURRENT_SOURCE_DIR}/controls/qmldir ${CALENDAR_PLUGIN_DIR}/org/maui/calendar/
        COMMAND ${CMAKE_COMMAND} -E
        copy $<TARGET_FILE:${PROJECT_NAME}> ${CALENDAR_PLUGIN_DIR}/org/maui/calendar/
        )

        install(FILES controls/qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/maui/calendar)
endif()

install(TARGETS ${PROJECT_NAME} DESTINATION ${KDE_INSTALL_QMLDIR}/org/maui/calendar )
install(TARGETS ${PROJECT_NAME} #[[EXPORT CaskLibTargets]] ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
