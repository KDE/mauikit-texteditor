#pragma once

#include <QString>
#include <KAboutData>
#include "texteditor_export.h"

namespace MauiKitTextEditor
{
   TEXTEDITOR_EXPORT QString versionString();
   TEXTEDITOR_EXPORT QString buildVersion();
   TEXTEDITOR_EXPORT KAboutComponent aboutData();
};
