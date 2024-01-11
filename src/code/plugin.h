#pragma once

#include <QObject>
#include <QUrl>
#include <QQmlExtensionPlugin>

class MauiCalendarPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlEngineExtensionInterface_iid)

public:
    void registerTypes(const char *uri) override;

    QUrl resolveFileUrl(const QString &filePath) const
    {
        #ifdef QUICK_COMPILER
        return QUrl(QStringLiteral("qrc:/maui/calendar/") + filePath);
#else
        return QUrl(baseUrl().toString() + QStringLiteral("/") + filePath);
#endif
    }
};
