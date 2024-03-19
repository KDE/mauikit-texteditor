import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui

import org.mauikit.texteditor as TE

Maui.ApplicationWindow
{
    id: root

    Maui.Page
    {
        Maui.Controls.showCSD: true
        anchors.fill: parent

        headBar.leftContent:
        [
            ToolButton
            {
                icon.name: "folder-open"
                onClicked: _editor.fileUrl = "file:///home/camiloh/nota/CMakeLists.txt"
            },

            ToolButton
            {
                icon.name: "settings-configure"
                onClicked: _settings.open()
            }
        ]

        Maui.SettingsDialog
        {
            id: _settings
            Component
            {
                id: _colorsComponent
                TE.ColorSchemesPage
                {
                    backgroundColor: _editor.document.backgroundColor
                    currentTheme: _editor.document.theme

                    onCurrentThemeChanged: _editor.document.theme = currentTheme
                    onColorsPicked: (background, text) =>
                                    {
                                        _editor.Maui.Theme.backgroundColor = background
                                        _editor.body.color = text
                                    }
                }
            }

            Maui.SectionItem
            {
                text: "Color scheme"
                onClicked: _settings.addPage(_colorsComponent)
            }
        }

        TE.TextEditor
        {
            id: _editor
            anchors.fill: parent
            body.wrapMode: Text.NoWrap
            document.enableSyntaxHighlighting: true
        }
    }
}

