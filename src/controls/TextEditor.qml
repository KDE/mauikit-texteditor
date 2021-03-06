import QtQuick 2.15
import QtQml 2.14
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.15 as T

import org.mauikit.controls 1.3 as Maui
import org.mauikit.texteditor 1.0 as TE


/*!
 * \ since org.mauikit.texteditor 1.0
 * \inqmlmodule org.mauikit.texteditor
 *  \brief Integrated text editor component
 *
 *  A text area for editing text with convinient functions.
 *  The Editor is controlled by the DocumentHandler which controls the files I/O,
 *  the syntax highlighting styles, and many more text editing properties.
 */
Maui.Page
{
    id: control
    
    focus: false
    title: document.fileName
    showTitle: false
    
    /*!
     *      If a small text tooltip should be visible at the editor right bottom area, displaying the
     *      number of count of lines and words.
     */
    property bool showLineCount : true
    
    property bool showFindBar: false
    
    onShowFindBarChanged:
    {
        if(showFindBar)
        {
            _findField.forceActiveFocus()
        }else
        {
            body.forceActiveFocus()
        }
    }
    
    /*!
     *      \qmlproperty TextArea Editor::body
     * Access to the editor text area.
     */
    property alias body : body
    
    /*!
     *      \qmlproperty DocumentHandler Editor::document
     */
    property alias document : document
    
    /*!
     *      \qmlproperty ScrollablePage Editor::scrollView
     */
    property alias scrollView: _scrollView
    
    /*!
     *      \qmlproperty string Editor::text
     */
    property alias text: body.text
    
    /*!
     *      \qmlproperty bool Editor::uppercase
     */
    property alias uppercase: document.uppercase
    
    /*!
     *      \qmlproperty bool Editor::underline
     */
    property alias underline: document.underline
    
    /*!
     *      \qmlproperty bool Editor::italic
     */
    property alias italic: document.italic
    
    /*!
     *      \qmlproperty bool Editor::bold
     */
    property alias bold: document.bold
    
    /*!
     *      \qmlproperty bool Editor::canRedo
     */
    property alias canRedo: body.canRedo
    
    /*!
     *      \qmlproperty url Editor::fileUrl
     *
     *      If a file url is provided the DocumentHandler will try to open its contents and display it.
     */
    property alias fileUrl : document.fileUrl
    
    /*!
     *      \qmlproperty bool Editor::showLineNumbers
     *
     *      If a sidebar listing each line number should be visible.
     */
    property bool showLineNumbers : false
    
    TE.DocumentHandler
    {
        id: document
        document: body.textDocument
        cursorPosition: body.cursorPosition
        selectionStart: body.selectionStart
        selectionEnd: body.selectionEnd
        backgroundColor: control.Maui.Theme.backgroundColor
        enableSyntaxHighlighting: false
        findCaseSensitively:  _findCaseSensitively.checked
        findWholeWords: _findWholeWords.checked
        
        onSearchFound:
        {
            body.select(start, end)
        }
    }
    
    Rectangle
    {
        z: body.z +1
        visible: showLineCount
        anchors
        {
            right: parent.right
            bottom: parent.bottom
            margins: Maui.Style.space.big
        }
        color: Maui.Theme.backgroundColor
        width: _countLabel.implicitWidth
        height: Maui.Style.rowHeight
        radius: Maui.Style.radiusV
        
        Label
        {
            id: _countLabel
            anchors.centerIn: parent
            text: body.length + " / " + body.lineCount
            color: Maui.Theme.textColor
            opacity: 0.5
        }
    }
    
    Maui.ContextualMenu
    {
        id: documentMenu
        
        MenuItem
        {
            text: i18n("Copy")
            onTriggered: body.copy()
            enabled: body.selectedText.length
        }
        
        MenuItem
        {
            text: i18n("Cut")
            onTriggered: body.cut()
            enabled: !body.readOnly && body.selectedText.length
        }
        
        MenuItem
        {
            text: i18n("Paste")
            onTriggered: body.paste()
            enabled: !body.readOnly
        }
        
        MenuItem
        {
            text: i18n("Select All")
            onTriggered: body.selectAll()
        }
        
        MenuItem
        {
            text: i18n("Search Selected Text on Google...")
            onTriggered: Qt.openUrlExternally("https://www.google.com/search?q="+body.selectedText)
            enabled: body.selectedText.length
        }
    }
    
    footerColumn: [
    
    Maui.ToolBar
    {
        id: _findToolBar
        visible: showFindBar
        width: parent.width
        position: ToolBar.Footer
        
        rightContent: ToolButton
        {
            id: _replaceButton
            icon.name: "edit-find-replace"
            checkable: true
            checked: false
        }
        
        leftContent: Maui.ToolButtonMenu
        {
            icon.name: "overflow-menu"
            
            MenuItem
            {
                id: _findCaseSensitively
                checkable: true
                text: i18n("Case Sensitive")
            }
            
            MenuItem
            {
                id: _findWholeWords
                checkable: true
                text: i18n("Whole Words Only")
            }
        }
        
        middleContent: Maui.SearchField
        {
            id: _findField
            Layout.fillWidth: true
            Layout.maximumWidth: 500
            Layout.alignment: Qt.AlignCenter
            placeholderText: i18n("Find")
            
            onAccepted:
            {
                document.find(text)
            }
            
            actions:[
            
            Action
            {
                enabled: _findField.text.length
                icon.name: "arrow-up"
                onTriggered: document.find(_findField.text, false)
            }
            
            //                    Action
            //                    {
            //                        enabled: _findField.text.length
            //                        icon.name: "arrow-down"
            //                        onTriggered: document.find(_findField.text, true)
            //                    }
            ]
        }
    },
    
    Maui.ToolBar
    {
        id: _replaceToolBar
        position: ToolBar.Footer
        visible: _replaceButton.checked && _findToolBar.visible
        width: parent.width
        enabled: !body.readOnly
        
        middleContent: Maui.SearchField
        {
            id: _replaceField
            placeholderText: i18n("Replace")
            Layout.fillWidth: true
            Layout.maximumWidth: 500
            Layout.alignment: Qt.AlignCenter
            icon.source: "edit-find-replace"
            actions: Action
            {
                text: i18n("Replace")
                enabled: _replaceField.text.length
                icon.name: "checkmark"
                onTriggered: document.replace(_findField.text, _replaceField.text)
            }
        }
        
        rightContent: [
        Button
        {
            enabled: _replaceField.text.length
            text: i18n("Replace All")
            onClicked: document.replaceAll(_findField.text, _replaceField.text)
        }
        ]
    }
    ]
    
    ColumnLayout
    {
        anchors.fill: parent
        spacing: 0
        
        Repeater
        {
            model: document.alerts
            
            Maui.ToolBar
            {
                id: _alertBar
                property var alert : model.alert
                readonly property int index_ : index
                Layout.fillWidth: true
                
                Maui.Theme.backgroundColor:
                {
                    switch(alert.level)
                    {
                        case 0: return Maui.Theme.positiveTextColor
                        case 1: return Maui.Theme.neutralTextColor
                        case 2: return Maui.Theme.negativeTextColor
                    }
                }
                
                leftContent: Maui.ListItemTemplate
                {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    
                    label1.text: alert.title
                    label2.text: alert.body
                }
                
                rightContent: Repeater
                {
                    model: alert.actionLabels
                    
                    Button
                    {
                        id: _alertAction
                        property int index_ : index
                        text: modelData
                        onClicked: alert.triggerAction(_alertAction.index_, _alertBar.index_)
                        
                        Maui.Theme.backgroundColor: Qt.lighter(_alertBar.Maui.Theme.backgroundColor, 1.2)
                        Maui.Theme.textColor: Qt.darker(Maui.Theme.backgroundColor)
                    }
                }
            }
        }
        
        Maui.ScrollView
        {
            id: _scrollView
            Layout.fillWidth: true
            Layout.fillHeight: true
            contentWidth: availableWidth
            
            Keys.enabled: true
            Keys.forwardTo: body
            Keys.onPressed:
            {
                if((event.key === Qt.Key_F) && (event.modifiers & Qt.ControlModifier))
                {
                    control.showFindBar = true

                    if(control.body.selectedText.length)
                    {
                        _findField.text =  control.body.selectedText
                    }else
                    {
                        _findField.selectAll()
                    }

                    _findField.forceActiveFocus()
                    event.accepted = true
                }

                if((event.key === Qt.Key_R) && (event.modifiers & Qt.ControlModifier))
                {
                    control.showFindBar = true
                    _replaceButton.checked = true
                    _findField.text = control.body.selectedText
                    _replaceField.forceActiveFocus()
                    event.accepted = true
                }
            }

            Flickable
            {
                id: _flickable
                
                interactive: Maui.Handy.isTouch
                boundsBehavior : Flickable.StopAtBounds
                boundsMovement : Flickable.StopAtBounds
                
                TextArea.flickable: T.TextArea
                {
                    id: body
                    
                    text: document.text
                    
                    placeholderText: i18n("Body")
                    
                    selectByKeyboard: true
                    selectByMouse : !Maui.Handy.isMobile
                    
                    //                     tabStopDistance: 
                    //                     textMargin:
                    
                    persistentSelection: true
                    
                    textFormat: TextEdit.PlainText
                    wrapMode: TextEdit.WrapAnywhere
                    selectionColor: Maui.Theme.highlightColor
                    selectedTextColor: Maui.Theme.textColor
                    opacity: control.enabled ? 1 : 0.6

                    activeFocusOnPress: true
                    activeFocusOnTab: true
                    
                    padding: Maui.Style.space.small
                    leftPadding: _linesCounter.width + Maui.Style.space.small
                    

                    Label
                    {
                        id: placeholder

                        opacity: 0.5

                        x: body.leftPadding
                        y: body.topPadding
                        width: body.width - (body.leftPadding + body.rightPadding)
                        height: body.height - (body.topPadding + body.bottomPadding)

                        text: body.placeholderText
                        font: body.font
                        color: body.color
                        horizontalAlignment: body.horizontalAlignment
                        verticalAlignment: body.verticalAlignment
                        visible: !body.length && !body.preeditText && (!body.activeFocus || body.horizontalAlignment !== Qt.AlignHCenter)
                        elide: Text.ElideRight
                    }
                    color: Maui.Theme.textColor
                    
                    background: Rectangle
                    {
                        color: control.Maui.Theme.backgroundColor
                    }
                    
                    Keys.onPressed:
                    {
                        if(event.key === Qt.Key_PageUp)
                        {
                            _flickable.flick(0,  60*Math.sqrt(_flickable.height))
                            event.accepted = true
                        }
                        
                        if(event.key === Qt.Key_PageDown)
                        {
                            _flickable.flick(0, -60*Math.sqrt(_flickable.height))
                            event.accepted = true
                        }                                    // TODO: Move cursor
                    }
                    
                    onPressAndHold:
                    {
                        if(Maui.Handy.isMobile)
                        {
                            return
                        }
                        
                        documentMenu.show()
                    }
                    
                    onPressed:
                    {
                        if(Maui.Handy.isMobile)
                        {
                            return
                        }
                        
                        if(event.button === Qt.RightButton)
                        {
                            documentMenu.show()
                        }
                    }
                    
                    Loader
                    {
                        id: _linesCounter
                        asynchronous: true
                        active: control.showLineNumbers && !document.isRich
                        
                        anchors.left: parent.left
                        anchors.top: parent.top                        
                        
                        height: Math.max(_flickable.contentHeight, control.height)
                        width: active ? 48 : 0                        
                        sourceComponent: _linesCounterComponent
                    }
                    
                    Component
                    {
                        id: _linesCounterComponent
                        
                        Rectangle
                        {
                            color: Qt.darker(Maui.Theme.backgroundColor, 1)
                            
                            ListView
                            {
                                id: _linesCounterList

                                anchors.fill: parent
                                anchors.topMargin: body.topPadding + body.textMargin
                                
                                model: document.lineCount
                                
                                Binding on currentIndex
                                {
                                    value: document.currentLineIndex
                                    restoreMode: Binding.RestoreBindingOrValue 
                                } 
                                
                                Timer
                                {
                                    id: _lineIndexTimer
                                    interval: 250 
                                    onTriggered: _linesCounterList.currentIndex= document.currentLineIndex
                                }
                                
                                Connections
                                {
                                    target: document
                                    function onLineCountChanged()
                                    {
                                        _lineIndexTimer.restart()
                                    }
                                }
                                
                                orientation: ListView.Vertical
                                interactive: false
                                snapMode: ListView.NoSnap
                                
                                boundsBehavior: Flickable.StopAtBounds
                                boundsMovement :Flickable.StopAtBounds
                                
                                preferredHighlightBegin: 0
                                preferredHighlightEnd: width
                                
                                highlightRangeMode: ListView.StrictlyEnforceRange
                                highlightMoveDuration: 0
                                highlightFollowsCurrentItem: false
                                highlightResizeDuration: 0
                                highlightMoveVelocity: -1
                                highlightResizeVelocity: -1
                                
                                maximumFlickVelocity: 0                               
                                
                                delegate: Row
                                {
                                    id: _delegate
                                    readonly property int line : index
                                    property bool foldable : control.document.isFoldable(line)
                                    width:  ListView.view.width
                                    height: Math.max(fontSize, document.lineHeight(line))
                                    
                                    readonly property real fontSize : control.body.font.pointSize
                                    
                                    readonly property bool isCurrentItem : ListView.isCurrentItem
                                    
                                    Connections
                                    {
                                        target: control.body
                                        
                                        function onContentHeightChanged()
                                        {
                                            if(_delegate.isCurrentItem)
                                            {
                                                console.log("Updating line height")
                                                _delegate.height = control.document.lineHeight(_delegate.line)
                                                _delegate.foldable = control.document.isFoldable(_delegate.line)
                                            }
                                        }
                                    }
                                    
                                    Label
                                    {
                                        width: 32
                                        height: parent.height
                                        opacity: isCurrentItem  ? 1 : 0.7
                                        color:  isCurrentItem ? Maui.Theme.highlightColor : Maui.Theme.textColor
                                        font.pointSize: Math.min(Maui.Style.fontSizes.medium, body.font.pointSize)
                                        horizontalAlignment: Text.AlignHCenter
                                        verticalAlignment: Text.AlignVCenter
                                        //                                         renderType: Text.NativeRendering
                                        font.family: "Monospace"
                                        text: index+1
                                    }
                                    
                                    AbstractButton
                                    {
                                        visible: foldable
                                        anchors.verticalCenter: parent.verticalCenter
                                        height: 8
                                        width: 8
                                        //onClicked: 
                                        //{
                                            //control.goToLine(_delegate.line)
                                            //control.document.toggleFold(_delegate.line)
                                        //}
                                        contentItem: Maui.Icon
                                        {
                                            source: "go-down"
                                        }
                                    }
                                }
                            }
                            
//                            Maui.Separator
//                            {
//                                anchors.top: parent.top
//                                anchors.bottom: parent.bottom
//                                anchors.right: parent.right
//                                width: 0.5
//                                weight: Maui.Separator.Weight.Light
//                            }
                        }
                    }
                }
            }
        }
    }

    function forceActiveFocus()
    {
        body.forceActiveFocus()
    }

    function goToLine(line)
    {
        if(line>0 && line <= body.lineCount)
        {
            body.cursorPosition = document.goToLine(line-1)
            body.forceActiveFocus()
        }
    }
}
