#pragma once

#include <QObject>
#include <QQmlExtensionPlugin>

class MauiCalendarPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    void registerTypes(const char *uri) override;

    QUrl resolveFileUrl(const QString &filePath) const
    {
        return QUrl(QStringLiteral("qrc:/maui/calendar/") + filePath);
    }
};
