import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import org.mauikit.controls as Maui
import org.mauikit.texteditor as TE

/**
 * @brief A settings page with the available color schemes for the syntax highlighting.
 * 
 * @image html colors.png
 * 
 * @code
 * Maui.SettingsDialog
 * {
 *    id: _settings
 *    Component
 *    {
 *        id: _colorsComponent
 *        TE.ColorSchemesPage
 *        {
 *            backgroundColor: _editor.document.backgroundColor
 *            currentTheme: _editor.document.theme
 * 
 *            onCurrentThemeChanged: _editor.document.theme = currentTheme
 *            onColorsPicked: (background, text) =>
 *                            {
 *                                _editor.Maui.Theme.backgroundColor = background
 *                                _editor.body.color = text
 *                            }
 *        }
 *    }
 * 
 *    Maui.SectionItem
 *    {
 *        text: "Color scheme"
 *        onClicked: _settings.addPage(_colorsComponent)
 *    }
 * }
 * 
 * TE.TextEditor
 * {
 *    id: _editor
 *    anchors.fill: parent
 *    body.wrapMode: Text.NoWrap
 *    document.enableSyntaxHighlighting: true
 * }
 * @endcode
 */
Maui.SettingsPage
{
    id: control
    title: i18n("Colors")
    
    /**
     * @brief The current theme being used or currently picked by the user
     */
    property string currentTheme
    
    /**
     * The current background color used in the text area or the one currently picked by the user
     */
    property color backgroundColor
    
    /**
     * @brief Emitted when a new background color has been picked
     * @param backgroundColor the picked background color
     * @param textColor a suited text color for the background color picked
     */
    signal colorsPicked(string backgroundColor, string textColor)
    
    Maui.SectionGroup
    {
        title: i18n("Colors")
        description: i18n("Configure the style of the syntax highlighting. This configuration in not applied for rich text formats.")
        
        Maui.SectionItem
        {
            label1.text: i18n("Color")
            label2.text: i18n("Editor background color.")
            
            Maui.ColorsRow
            {
                spacing: Maui.Style.space.medium
                currentColor: control.backgroundColor
                colors: ["#333", "#fafafa", "#fff3e6", "#4c425b"]
                
                onColorPicked:
                {
                    currentColor = color
                    
                    var textColor
                    
                    switch(color)
                    {
                        case "#333": textColor = "#fafafa"; break;
                        case "#fafafa": textColor = "#333"; break;
                        case "#fff3e6": textColor = Qt.darker(color, 2); break;
                        case "#4c425b": textColor = Qt.lighter(color, 2.5); break;
                        default: textColor = Maui.Theme.textColor;
                    }
                    
                    control.colorsPicked(color, textColor)
                }
            }
        }
        
        Maui.SectionItem
        {
            label1.text:  i18n("Theme")
            label2.text: i18n("Editor color scheme style.")
            
            GridLayout
            {
                columns: 3
                Layout.fillWidth: true
                opacity: enabled ? 1 : 0.5
                
                Repeater
                {
                    model: TE.ColorSchemesModel {}
                    
                    delegate: Maui.GridBrowserDelegate
                    {
                        Layout.fillWidth: true
                        checked: model.name === control.currentTheme
                        onClicked: control.currentTheme = model.name
                        label1.text: model.name
                        
                        template.iconComponent: Rectangle
                        {
                            implicitHeight: Math.max(_layout.implicitHeight + topPadding + bottomPadding, 64)
                            
                            color: control.backgroundColor
                            radius: Maui.Style.radiusV
                            
                            Column
                            {
                                id: _layout
                                anchors.fill: parent
                                anchors.margins: Maui.Style.space.small
                                
                                spacing: 2
                                
                                Text
                                {
                                    wrapMode: Text.NoWrap
                                    elide: Text.ElideLeft
                                    width: parent.width
                                    text: "QWERTY { @ }"
                                    color: model.foreground
                                    font.family: "Monospace"
                                }
                                
                                Rectangle
                                {
                                    radius: 2
                                    height: 8
                                    width: parent.width
                                    color: model.highlight
                                }
                                
                                Rectangle
                                {
                                    radius: 2
                                    height: 8
                                    width: parent.width
                                    color: model.color3
                                }
                                
                                Rectangle
                                {
                                    radius: 2
                                    height: 8
                                    width: parent.width
                                    color: model.color4
                                }
                                
                                Rectangle
                                {
                                    radius: 2
                                    height: 8
                                    width: parent.width
                                    color: model.color5
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
