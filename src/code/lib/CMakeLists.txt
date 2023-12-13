# SPDX-FileCopyrightText: (C) 2020 Carl Schwan <carl@carlschwan.eu>
#
# SPDX-License-Identifier: BSD-2-Clause

set(kalendar_lib_SRCS
    colorproxymodel.cpp)

add_library(kalendar_lib STATIC)
target_sources(kalendar_lib PRIVATE ${kalendar_lib_SRCS})
set_property(TARGET kalendar_lib PROPERTY POSITION_INDEPENDENT_CODE ON)

target_include_directories(kalendar_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(kalendar_lib PUBLIC
    Qt${QT_MAJOR_VERSION}::Core
    Qt${QT_MAJOR_VERSION}::Gui
    Qt${QT_MAJOR_VERSION}::Qml
    Qt${QT_MAJOR_VERSION}::Quick
    Qt${QT_MAJOR_VERSION}::QuickControls2
    Qt${QT_MAJOR_VERSION}::Svg
    KF${KF_MAJOR_VERSION}::I18n
    KF${KF_MAJOR_VERSION}::CoreAddons
    KF${KF_MAJOR_VERSION}::CalendarCore
    KF${KF_MAJOR_VERSION}::ConfigWidgets
    KF${KF_MAJOR_VERSION}::Contacts
    KF${KF_MAJOR_VERSION}::ItemModels
    KPim${KF_MAJOR_VERSION}::AkonadiCore
    KPim${KF_MAJOR_VERSION}::AkonadiCalendar
    KPim${KF_MAJOR_VERSION}::CalendarUtils)

     if (QT_MAJOR_VERSION STREQUAL "5")
    target_link_libraries(kalendar_lib PRIVATE  KPim${KF_MAJOR_VERSION}::AkonadiContact)
else()
    target_link_libraries(kalendar_lib PRIVATE  KPim${KF_MAJOR_VERSION}::AkonadiContactCore)
endif()
