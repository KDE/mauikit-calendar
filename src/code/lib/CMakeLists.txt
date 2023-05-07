# SPDX-FileCopyrightText: (C) 2020 Carl Schwan <carl@carlschwan.eu>
#
# SPDX-License-Identifier: BSD-2-Clause

set(kalendar_lib_SRCS
    colorproxymodel.cpp
)

add_library(kalendar_lib STATIC)
target_sources(kalendar_lib PRIVATE ${kalendar_lib_SRCS})
set_property(TARGET kalendar_lib PROPERTY POSITION_INDEPENDENT_CODE ON)

target_include_directories(kalendar_lib PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(kalendar_lib PUBLIC
    Qt::Core
    Qt::Gui
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
    Qt::Svg
    KF5::I18n
    KF5::CoreAddons
    KF5::CalendarCore
  
    KPim5::AkonadiCore
    KPim5::AkonadiCalendar
    KPim5::AkonadiContact
    KF5::ConfigWidgets
    KF5::Contacts
    KF5::ItemModels
    KPim5::CalendarUtils
)
