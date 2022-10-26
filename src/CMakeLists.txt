# SPDX-FileCopyrightText: 2020 Carl Schwan <carl@carlschwan.eu>
#
# SPDX-License-Identifier: BSD-2-Clause

#ecm_create_qm_loader(filebrowsing_QM_LOADER libfilebrowsingplugin_qt)

add_subdirectory(code/lib)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/code
    ${CMAKE_CURRENT_SOURCE_DIR}/code/models
    )


set(lib_SRCS

    code/plugin.cpp
   code/calendarmanager.cpp
   code/incidencewrapper.cpp
#    code/agentconfiguration.cpp

code/models/todosortfilterproxymodel.cpp

    code/models/infinitecalendarviewmodel.cpp
    code/models/hourlyincidencemodel.cpp
    code/models/multidayincidencemodel.cpp
    code/models/incidenceoccurrencemodel.cpp
    code/models/monthmodel.cpp
    code/models/timezonelistmodel.cpp
#    assets/assets.qrc
    )

set(lib_HDRS
    #code/plugin.h
#    assets/assets.qrc
    )

qtquick_compiler_add_resources(lib_QML_QRC controls/qml.qrc)

add_library(
    MauiKitCalendar
    SHARED
    ${lib_SRCS}
    ${model_SRCS}
    ${lib_QML_QRC}
    )

    add_library(MauiKit::Calendar ALIAS MauiKitCalendar)

    generate_export_header(MauiKitCalendar BASE_NAME Calendar)
    
set_target_properties(MauiKitCalendar PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION ${Calendar_SOVERSION}
    EXPORT_NAME Calendar
    )    
    
target_include_directories(MauiKitCalendar
    INTERFACE "$<INSTALL_INTERFACE:${KDE_INSTALL_INCLUDEDIR}/MauiKit/Calendar>")
    
    target_include_directories(MauiKitCalendar PUBLIC "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR};${CMAKE_CURRENT_BINARY_DIR};>")

    
target_link_libraries(
MauiKitCalendar
    PRIVATE
    
    MauiKit
kalendar_lib
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

install(TARGETS MauiKitCalendar EXPORT MauiKitCalendarTargets ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})

install(FILES
    ${lib_HDRS}
    ${CMAKE_CURRENT_BINARY_DIR}/calendar_export.h
    DESTINATION ${KDE_INSTALL_INCLUDEDIR}/MauiKit/Calendar
    COMPONENT Devel)

  

if (BUILD_SHARED_LIBS)
    add_custom_target(copy_calendar_to_bin ALL
       COMMAND ${CMAKE_COMMAND} -E
        make_directory ${CMAKE_BINARY_DIR}/bin/org/mauikit/calendar/
        COMMAND ${CMAKE_COMMAND} -E
        copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/controls ${CMAKE_BINARY_DIR}/bin/org/mauikit/calendar/
        COMMAND ${CMAKE_COMMAND} -E
        copy $<TARGET_FILE:MauiKitCalendar> ${CMAKE_BINARY_DIR}/bin/org/mauikit/calendar/
        )

        install(FILES controls/qmldir DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/calendar)
endif()

install(TARGETS MauiKitCalendar DESTINATION ${KDE_INSTALL_QMLDIR}/org/mauikit/calendar )
