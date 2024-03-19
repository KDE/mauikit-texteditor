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

        headBar.leftContent: ToolButton
        {
            icon.name:"folder-open"
            onClicked: _editor.fileUrl = "file:///home/camiloh/nota/CMakeLists.txt"
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

