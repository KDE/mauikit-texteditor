#include "moduleinfo.h"
#include "../texteditor_version.h"
#include <KI18n/KLocalizedString>

QString MauiKitCore::versionString()
{
    return QStringLiteral(TextEditor_VERSION_STRING);
}

QString MauiKitCore::buildVersion()
{
    return GIT_BRANCH+QStringLiteral("/")+GIT_COMMIT_HASH;
}

KAboutComponent MauiKitCore::aboutData()
{
    return KAboutComponent(QStringLiteral("MauiKit TextEditor"),
                         i18n("Text editor controls."),
                         QStringLiteral(TextEditor_VERSION_STRING),
                         QStringLiteral("http://mauikit.org"),
                         KAboutLicense::LicenseKey::LGPL_V3);
}

