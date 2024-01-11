#include "plugin.h"

#include <QQmlEngine>

#include "infinitecalendarviewmodel.h"
#include "hourlyincidencemodel.h"
#include "incidenceoccurrencemodel.h"
#include "timezonelistmodel.h"
#include "monthmodel.h"

#include "calendarmanager.h"
#include "incidencewrapper.h"
#include "filter.h"

#include "collection.h"
#include "collectioncomboboxmodel.h"
#include "mimetypes.h"

//#include <KCalendarCore/MemoryCalendar>
//#include <KCalendarCore/VCalFormat>
#include <akonadi_version.h>
#include <Akonadi/Collection>
#include <Akonadi/AgentFilterProxyModel>

void MauiCalendarPlugin::registerTypes(const char *uri)
{    
    Q_ASSERT(uri == QByteArray("org.mauikit.calendar"));

    qmlRegisterType<IncidenceWrapper>(uri, 1, 0, "IncidenceWrapper");
    //        qmlRegisterType<AttendeesModel>(uri, 1, 0, "AttendeesModel");
    qmlRegisterType<MultiDayIncidenceModel>(uri, 1, 0, "MultiDayIncidenceModel");
    qmlRegisterType<IncidenceOccurrenceModel>(uri, 1, 0, "IncidenceOccurrenceModel");
    //        qmlRegisterType<TodoSortFilterProxyModel>(uri, 1, 0, "TodoSortFilterProxyModel");
    //        qmlRegisterType<ItemTagsModel>(uri, 1, 0, "ItemTagsModel");
    qmlRegisterType<HourlyIncidenceModel>(uri, 1, 0, "HourlyIncidenceModel");
    qmlRegisterType<TimeZoneListModel>(uri, 1, 0, "TimeZoneListModel");
    // qmlRegisterType<MonthModel>(uri, 1, 0, "MonthModel");
    qmlRegisterType<InfiniteCalendarViewModel>(uri, 1, 0, "InfiniteCalendarViewModel");    
    
    qmlRegisterSingletonType<CalendarManager>(uri, 1, 0, "CalendarManager", [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
        Q_UNUSED(scriptEngine)
        auto cal = CalendarManager::instance();
        engine->setObjectOwnership(cal, QQmlEngine::CppOwnership);
        return cal;
    });    
    
    qmlRegisterSingletonType<Filter>(uri, 1, 0, "Filter", [](QQmlEngine *engine, QJSEngine *scriptEngine) {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        return new Filter;
    });  
    
    //Taken from Kalendar Akonadi plugin
    qmlRegisterSingletonType<Akonadi::Quick::MimeTypes>(uri, 1, 0, "MimeTypes", [](QQmlEngine *engine, QJSEngine *scriptEngine) {
        Q_UNUSED(engine)
        Q_UNUSED(scriptEngine)
        return new Akonadi::Quick::MimeTypes;
    });
    
    qmlRegisterType<Akonadi::Quick::CollectionComboBoxModel>(uri, 1, 0, "CollectionComboBoxModel");
    // qmlRegisterType<Akonadi::Quick::CollectionPickerModel>(uri, 1, 0, "CollectionPickerModel");    
    qmlRegisterUncreatableType<Akonadi::Quick::Collection>(uri, 1, 0, "Collection", QStringLiteral("It's just an enum"));
    qRegisterMetaType<Akonadi::ETMCalendar::Ptr>();
    qRegisterMetaType<QAbstractProxyModel *>("QAbstractProxyModel*");
    qRegisterMetaType<Akonadi::AgentFilterProxyModel *>();
    
    //QML STUFF
    qmlRegisterSingletonType(resolveFileUrl(QStringLiteral("KalendarUiUtils.qml")), uri, 1, 0, "KalendarUiUtils");
    
    qmlRegisterType(resolveFileUrl(QStringLiteral("DayLabelsBar.qml")), uri, 1, 0, "DayLabelsBar");
    qmlRegisterType(resolveFileUrl(QStringLiteral("MonthView.qml")), uri, 1, 0, "MonthView");
    qmlRegisterType(resolveFileUrl(QStringLiteral("YearView.qml")), uri, 1, 0, "YearView");
    
    qmlRegisterType(resolveFileUrl(QStringLiteral("EventPage.qml")), uri, 1, 0, "EventPage");
    
    qmlRegisterType(resolveFileUrl(QStringLiteral("DayGridView.qml")), uri, 1, 0, "DayGridView");
    qmlRegisterType(resolveFileUrl(QStringLiteral("HourlyView.qml")), uri, 1, 0, "HourlyView");
    
    qmlRegisterType(resolveFileUrl(QStringLiteral("DateComboBox.qml")), uri, 1, 0, "DateComboBox");
    qmlRegisterType(resolveFileUrl(QStringLiteral("TimeComboBox.qml")), uri, 1, 0, "TimeComboBox");
    
    qmlRegisterType(resolveFileUrl(QStringLiteral("TimePicker.qml")), uri, 1, 0, "TimePicker");
    qmlRegisterType(resolveFileUrl(QStringLiteral("DatePicker.qml")), uri, 1, 0, "DatePicker");
    
    qmlRegisterType(resolveFileUrl(QStringLiteral("MonthsGrid.qml")), uri, 1, 0, "MonthsGrid");
    qmlRegisterType(resolveFileUrl(QStringLiteral("DaysGrid.qml")), uri, 1, 0, "DaysGrid");
    qmlRegisterType(resolveFileUrl(QStringLiteral("YearsGrid.qml")), uri, 1, 0, "YearsGrid");
}

#include "plugin.moc"
#include "moc_plugin.cpp"
