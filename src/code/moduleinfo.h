#pragma once

#include <QString>
#include <KAboutData>
#include "texteditor_export.h"

namespace MauiKitCore
{
   TEXTEDITOR_EXPORT QString versionString();
   TEXTEDITOR_EXPORT QString buildVersion();
   TEXTEDITOR_EXPORT KAboutComponent aboutData();

   TEXTEDITOR_EXPORT KAboutComponent aboutLuv();
};
