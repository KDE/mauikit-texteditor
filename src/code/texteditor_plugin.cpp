// SPDX-FileCopyrightText: 2020 Carl Schwan <carl@carlschwan.eu>
//
// SPDX-License-Identifier: LGPL-2.1-or-later

#include <QQmlEngine>
#include <QResource>

#include "texteditor_plugin.h"
#include "documenthandler.h"
#include "colorschemesmodel.h"

void TextEditorPlugin::registerTypes(const char *uri)
{
#if defined(Q_OS_ANDROID)
    QResource::registerResource(QStringLiteral("assets:/android_rcc_bundle.rcc"));
#endif

    qmlRegisterType<DocumentHandler>(uri, 1, 0, "DocumentHandler");
    qmlRegisterType<ColorSchemesModel>(uri, 1, 0, "ColorSchemesModel");
    qmlRegisterType(componentUrl(QStringLiteral("TextEditor.qml")), uri, 1, 0, "TextEditor");
}

QUrl TextEditorPlugin::componentUrl(const QString &fileName) const
{
    return QUrl(resolveFileUrl(fileName));
}
