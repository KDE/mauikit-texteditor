#include "moduleinfo.h"
#include "../texteditor_version.h"
#include <KI18n/KLocalizedString>

QString MauiKitTextEditor::versionString()
{
    return QStringLiteral(TextEditor_VERSION_STRING);
}

QString MauiKitTextEditor::buildVersion()
{
    return GIT_BRANCH+QStringLiteral("/")+GIT_COMMIT_HASH;
}

KAboutComponent MauiKitTextEditor::aboutData()
{
    return KAboutComponent(QStringLiteral("MauiKit TextEditor"),
                         i18n("Text editor controls."),
                         QStringLiteral(TextEditor_VERSION_STRING),
                         QStringLiteral("http://mauikit.org"),
                         KAboutLicense::LicenseKey::LGPL_V3);
}

