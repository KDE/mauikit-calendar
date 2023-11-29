#pragma once

#include <QString>
#include <KAboutData>
#include "calendar_export.h"

namespace MauiKitCalendar
{
   CALENDAR_EXPORT QString versionString();
   CALENDAR_EXPORT QString buildVersion();
   CALENDAR_EXPORT KAboutComponent aboutData();
};
