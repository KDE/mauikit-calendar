#include "moduleinfo.h"
#include <QString>
#include "../calendar_version.h"
#include <akonadi_version.h>

QString MauiKitCalendar::versionString()
{
    return QStringLiteral(Calendar_VERSION_STRING);
}

QString MauiKitCalendar::buildVersion()
{
    return QStringLiteral(GIT_BRANCH)+QStringLiteral("/")+QStringLiteral(GIT_COMMIT_HASH);
}

KAboutComponent MauiKitCalendar::aboutData()
{
    return KAboutComponent(QStringLiteral("MauiKit Calendar"),
                         QStringLiteral("Calendar and events viewer controls."),
                         QStringLiteral(Calendar_VERSION_STRING),
                         QStringLiteral("http://mauikit.org"),
                         KAboutLicense::LicenseKey::LGPL_V3);
}

KAboutComponent MauiKitCalendar::aboutAkonadi()
{
    return KAboutComponent(QStringLiteral("Akonadi"),
                         QStringLiteral("The PIM Storage Service."),
                         QStringLiteral(AKONADI_VERSION_STRING),
                         QStringLiteral("https://community.kde.org/KDE_PIM/Akonadi"),
                         KAboutLicense::LicenseKey::LGPL_V3);
}
