#pragma once

#include <QObject>
#include <QUrl>
#include <QQmlExtensionPlugin>

class MauiCalendarPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    void registerTypes(const char *uri) override;

    QUrl resolveFileUrl(const QString &filePath) const
    {
        #ifdef QUICK_COMPILER
        return QStringLiteral("qrc:/maui/calendar/") + filePath;
#else
        return QUrl(baseUrl().toString() + QStringLiteral("/") + filePath);
#endif
    }
};
