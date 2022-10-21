#include "plugin.h"

#include <QQmlEngine>

#include "infinitecalendarviewmodel.h"
#include "hourlyincidencemodel.h"
#include "incidenceoccurrencemodel.h"
#include "timezonelistmodel.h"
#include "monthmodel.h"


//#include <KCalendarCore/MemoryCalendar>
//#include <KCalendarCore/VCalFormat>


void MauiCalendarPlugin::registerTypes(const char *uri)
{
    //C++ STUFF
    //    qmlRegisterType<IncidenceWrapper>(uri, 1, 0, "IncidenceWrapper");
    //        qmlRegisterType<AttendeesModel>(uri, 1, 0, "AttendeesModel");
    qmlRegisterType<MultiDayIncidenceModel>(uri, 1, 0, "MultiDayIncidenceModel");
    qmlRegisterType<IncidenceOccurrenceModel>(uri, 1, 0, "IncidenceOccurrenceModel");
    //        qmlRegisterType<TodoSortFilterProxyModel>(uri, 1, 0, "TodoSortFilterProxyModel");
    //        qmlRegisterType<ItemTagsModel>(uri, 1, 0, "ItemTagsModel");
    qmlRegisterType<HourlyIncidenceModel>(uri, 1, 0, "HourlyIncidenceModel");
    qmlRegisterType<TimeZoneListModel>(uri, 1, 0, "TimeZoneListModel");
    qmlRegisterType<MonthModel>(uri, 1, 0, "MonthModel");
    qmlRegisterType<InfiniteCalendarViewModel>(uri, 1, 0, "InfiniteCalendarViewModel");


    //QML STUFF
    qmlRegisterSingletonType(resolveFileUrl(QStringLiteral("KalendarUiUtils.qml")), uri, 1, 0, "KalendarUiUtils");

    qmlRegisterType(resolveFileUrl(QStringLiteral("DayLabelsBar.qml")), uri, 1, 0, "DayLabelsBar");
    qmlRegisterType(resolveFileUrl(QStringLiteral("MonthView.qml")), uri, 1, 0, "MonthView");
    qmlRegisterType(resolveFileUrl(QStringLiteral("Month.qml")), uri, 1, 0, "Month");
    qmlRegisterType(resolveFileUrl(QStringLiteral("YearView.qml")), uri, 1, 0, "YearView");
    qmlRegisterType(resolveFileUrl(QStringLiteral("EventPage.qml")), uri, 1, 0, "EventPage");
    qmlRegisterType(resolveFileUrl(QStringLiteral("DayGridView.qml")), uri, 1, 0, "DayGridView");
    qmlRegisterType(resolveFileUrl(QStringLiteral("HourlyView.qml")), uri, 1, 0, "HourlyView");
    qmlRegisterType(resolveFileUrl(QStringLiteral("DateComboBox.qml")), uri, 1, 0, "DateComboBox");


}
