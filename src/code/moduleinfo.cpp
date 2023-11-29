#include "moduleinfo.h"
#include <QString>
#include "../calendar_version.h"

QString MauiKitCalendar::versionString()
{
    return QStringLiteral(Calendar_VERSION_STRING);
}

QString MauiKitCalendar::buildVersion()
{
    return GIT_BRANCH+QStringLiteral("/")+GIT_COMMIT_HASH;
}

KAboutComponent MauiKitCalendar::aboutData()
{
    return KAboutComponent(QStringLiteral("MauiKit Calendar"),
                         QStringLiteral("Calendar and events viewer controls."),
                         QStringLiteral(Calendar_VERSION_STRING),
                         QStringLiteral("http://mauikit.org"),
                         KAboutLicense::LicenseKey::LGPL_V3);
}
