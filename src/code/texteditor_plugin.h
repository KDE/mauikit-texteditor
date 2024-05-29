// SPDX-FileCopyrightText: 2020 Carl Schwan <carl@carlschwan.eu>
//
// SPDX-License-Identifier: LGPL-2.1-or-later

#pragma once

#include <QDir>
#include <QQmlExtensionPlugin>

class TextEditorPlugin : public QQmlExtensionPlugin
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID QQmlExtensionInterface_iid)
public:
    void registerTypes(const char *uri) override;

private:    
    QUrl componentUrl(const QString &fileName) const;

    QString resolveFileUrl(const QString &filePath) const
    {
#if defined(Q_OS_ANDROID)
        return QStringLiteral("qrc:/android_rcc_bundle/qml/org/mauikit/texteditor/") + filePath;
#else
        return baseUrl().toString() + QLatin1Char('/') + filePath;
#endif
    }
};
