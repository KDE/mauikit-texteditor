import QtQuick 2.15
import QtQml 2.14
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3
import QtQuick.Templates 2.15 as T

import org.mauikit.controls 1.3 as Maui
import org.mauikit.texteditor 1.0 as TE

import org.kde.sonnet 1.0 as Sonnet

/*!
 * \ since org.mauikit.texteditor 1.0
 * \inqmlmodule org.mauikit.texteditor
 *  \brief Integrated text editor component
 *
 *  A text area for editing text with convinient functions.
 *  The Editor is controlled by the DocumentHandler which controls the files I/O,
 *  the syntax highlighting styles, and many more text editing properties.
 */
Page
{
    id: control
    padding: 0
    focus: false
    clip: false
    title: document.fileName + (document.modified ? "*" : "")
    //     showTitle: false
    
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
    
    property bool spellcheckEnabled: false
    
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
    
    Loader
    {
        id: spellcheckhighlighterLoader
        property bool activable: control.spellcheckEnabled
        property Sonnet.Settings settings: Sonnet.Settings {}
        active: activable && settings.checkerEnabledByDefault
        onActiveChanged: if (active) {
            item.active = true;
        }
        sourceComponent: Sonnet.SpellcheckHighlighter {
            id: spellcheckhighlighter
            document:  body.textDocument
            cursorPosition: body.cursorPosition
            selectionStart: body.selectionStart
            selectionEnd: body.selectionEnd
            misspelledColor: Maui.Theme.negativeTextColor
            active: spellcheckhighlighterLoader.activable && settings.checkerEnabledByDefault
            
            onChangeCursorPosition: {
                body.cursorPosition = start;
                body.moveCursorSelection(end, TextEdit.SelectCharacters);
            }
        }
    }
    
    Maui.ContextualMenu
    {
        id: documentMenu
        property var spellcheckhighlighter: null
        property var spellcheckhighlighterLoader: null
        property int restoredCursorPosition: 0
        property int restoredSelectionStart
        property int restoredSelectionEnd
        property var suggestions: []
        property bool deselectWhenMenuClosed: true
        property var runOnMenuClose: () => {}
        property bool persistentSelectionSetting
        Component.onCompleted: persistentSelectionSetting = body.persistentSelection              
      
        Maui.MenuItemActionRow
        {
            Action 
            {
                icon.name: "edit-undo-symbolic"
                text: qsTr("Undo")
                shortcut: StandardKey.Undo
                
                onTriggered: 
                {
                    documentMenu.deselectWhenMenuClosed = false;
                    documentMenu.runOnMenuClose = () => body.undo();
                }
            }            
            
            Action 
            {
                icon.name: "edit-redo-symbolic"
                text: qsTr("Redo")
                shortcut: StandardKey.Redo
                
                onTriggered:
                {
                    documentMenu.deselectWhenMenuClosed = false;
                    documentMenu.runOnMenuClose = () => body.redo();
                }
            }            
        }        
        
        MenuItem
        {
            action: Action {
                icon.name: "edit-copy-symbolic"
                text: qsTr("Copy")
                shortcut: StandardKey.Copy
            }
            onTriggered:
            {
                documentMenu.deselectWhenMenuClosed = false;
                documentMenu.runOnMenuClose = () => control.body.copy();
            }         
            enabled: body.selectedText.length
        }
        
        MenuItem
        {
            action: Action {
                icon.name: "edit-cut-symbolic"
                text: qsTr("Cut")
                shortcut: StandardKey.Cut
            }
            onTriggered:
            {
                documentMenu.deselectWhenMenuClosed = false;
                documentMenu.runOnMenuClose = () => control.body.cut();
            }       
            enabled: !body.readOnly && body.selectedText.length
        }
        
        MenuItem
        {
            action: Action {
                icon.name: "edit-paste-symbolic"
                text: qsTr("Paste")
                shortcut: StandardKey.Paste
            }
            onTriggered:
            {
                documentMenu.deselectWhenMenuClosed = false;
                documentMenu.runOnMenuClose = () => control.body.paste();
            }          
            enabled: !body.readOnly
        }
        
        
        MenuItem
        {
            action: Action {
                icon.name: "edit-select-all-symbolic"
                text: qsTr("Select All")
                shortcut: StandardKey.SelectAll
            }
            onTriggered: 
            {
                documentMenu.deselectWhenMenuClosed = false
                documentMenu.runOnMenuClose = () => control.body.selectAll();
            }
        }       
        
        MenuItem
        {
            text: i18nd("mauikittexteditor","Search Selected Text on Google...")
            onTriggered: Qt.openUrlExternally("https://www.google.com/search?q="+body.selectedText)
            enabled: body.selectedText.length
        }
        
        MenuItem 
        {
            enabled: !control.body.readOnly && control.body.selectedText
            action: Action {
                icon.name: "edit-delete-symbolic"
                text: qsTr("Delete")
                shortcut: StandardKey.Delete
            }
            onTriggered: {
                documentMenu.deselectWhenMenuClosed = false;
                documentMenu.runOnMenuClose = () => control.body.remove(control.body.selectionStart, control.body.selectionEnd);
            }
        }   
        
        
        MenuSeparator 
        {
        }
        
        Menu
        {
            id: _spellingMenu
            title: i18nd("mauikittexteditor","Spelling")
            enabled: control.spellcheckEnabled
           
            Instantiator
            {
                id: _suggestions
                active: !control.body.readOnly && documentMenu.spellcheckhighlighter !== null && documentMenu.spellcheckhighlighter.active && documentMenu.spellcheckhighlighter.wordIsMisspelled
                model: documentMenu.suggestions
                delegate: MenuItem 
                {
                    text: modelData
                    onClicked:
                    {
                        documentMenu.deselectWhenMenuClosed = false;
                        documentMenu.runOnMenuClose = () => documentMenu.spellcheckhighlighter.replaceWord(modelData);
                    }
                }
                onObjectAdded: 
                {
                    _spellingMenu.insertItem(0, object)
                }
                onObjectRemoved: _spellingMenu.removeItem(0)
            }            
            
            MenuSeparator 
            {
                enabled: !control.body.readOnly && ((documentMenu.spellcheckhighlighter !== null && documentMenu.spellcheckhighlighter.active && documentMenu.spellcheckhighlighter.wordIsMisspelled) || (documentMenu.spellcheckhighlighterLoader && documentMenu.spellcheckhighlighterLoader.activable))
            }
            
            MenuItem {
                enabled: !control.body.readOnly && documentMenu.spellcheckhighlighter !== null && documentMenu.spellcheckhighlighter.active && documentMenu.spellcheckhighlighter.wordIsMisspelled && documentMenu.suggestions.length === 0
                action: Action {
                    text: documentMenu.spellcheckhighlighter ? qsTr("No suggestions for \"%1\"").arg(documentMenu.spellcheckhighlighter.wordUnderMouse) : ''
                    enabled: false
                }
            }
            MenuItem {
                enabled: !control.body.readOnly && documentMenu.spellcheckhighlighter !== null && documentMenu.spellcheckhighlighter.active && documentMenu.spellcheckhighlighter.wordIsMisspelled
                action: Action {
                    text: documentMenu.spellcheckhighlighter ? qsTr("Add \"%1\" to dictionary").arg(documentMenu.spellcheckhighlighter.wordUnderMouse) : ''
                    onTriggered: {
                        documentMenu.deselectWhenMenuClosed = false;
                        documentMenu.runOnMenuClose = () => spellcheckhighlighter.addWordToDictionary(documentMenu.spellcheckhighlighter.wordUnderMouse);
                    }
                }
            }
            
            MenuItem {
                enabled: !control.body.readOnly && documentMenu.spellcheckhighlighter !== null && documentMenu.spellcheckhighlighter.active && documentMenu.spellcheckhighlighter.wordIsMisspelled
                action: Action {
                    text: qsTr("Ignore")
                    onTriggered: {
                        documentMenu.deselectWhenMenuClosed = false;
                        documentMenu.runOnMenuClose = () => documentMenu.spellcheckhighlighter.ignoreWord(documentMenu.spellcheckhighlighter.wordUnderMouse);
                    }
                }
            }
            
            MenuItem 
            {
                enabled: !control.body.readOnly && documentMenu.spellcheckhighlighterLoader && documentMenu.spellcheckhighlighterLoader.activable
                checkable: true
                checked: documentMenu.spellcheckhighlighter ? documentMenu.spellcheckhighlighter.active : false
                text: qsTr("Enable Spellchecker")
                onCheckedChanged: {
                    spellcheckhighlighterLoader.active = checked;
                    documentMenu.spellcheckhighlighter = documentMenu.spellcheckhighlighterLoader.item;
                }
            }
        }
        
        function targetClick(spellcheckhighlighter, mousePosition)
        {
            control.body.persistentSelection = true; // persist selection when menu is opened
            documentMenu.spellcheckhighlighterLoader = spellcheckhighlighter;
            if (spellcheckhighlighter && spellcheckhighlighter.active) {
                documentMenu.spellcheckhighlighter = spellcheckhighlighter.item;
                documentMenu.suggestions = mousePosition ? spellcheckhighlighter.item.suggestions(mousePosition) : [];
            } else {
                documentMenu.spellcheckhighlighter = null;
                documentMenu.suggestions = [];
            }
            
            storeCursorAndSelection();            
            documentMenu.show()            
        }
        
        function storeCursorAndSelection()
        {
            documentMenu.restoredCursorPosition = control.body.cursorPosition;
            documentMenu.restoredSelectionStart = control.body.selectionStart;
            documentMenu.restoredSelectionEnd = control.body.selectionEnd;
        }        
        
        onOpened: 
        {
            runOnMenuClose = () => {};
        }
        
        onClosed: 
        {
            // restore text field's original persistent selection setting
            body.persistentSelection = documentMenu.persistentSelectionSetting
            // deselect text field text if menu is closed not because of a right click on the text field
            if (documentMenu.deselectWhenMenuClosed) 
            {
                body.deselect();
            }
            documentMenu.deselectWhenMenuClosed = true;
            
            // restore cursor position
            body.forceActiveFocus();
            body.cursorPosition = documentMenu.restoredCursorPosition;
            body.select(documentMenu.restoredSelectionStart, documentMenu.restoredSelectionEnd);
            
            // run action, and free memory
            runOnMenuClose();
            runOnMenuClose = () => {};
        }
    }
    
    footer: Column
    {
        width: parent.width
        
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
                    text: i18nd("mauikittexteditor","Case Sensitive")
                }
                
                MenuItem
                {
                    id: _findWholeWords
                    checkable: true
                    text: i18nd("mauikittexteditor","Whole Words Only")
                }
            }
            
            middleContent: Maui.SearchField
            {
                id: _findField
                Layout.fillWidth: true
                Layout.maximumWidth: 500
                Layout.alignment: Qt.AlignCenter
                placeholderText: i18nd("mauikittexteditor","Find")
                
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
        }
        
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
                placeholderText: i18nd("mauikittexteditor","Replace")
                Layout.fillWidth: true
                Layout.maximumWidth: 500
                Layout.alignment: Qt.AlignCenter
                icon.source: "edit-find-replace"
                actions: Action
                {
                    text: i18nd("mauikittexteditor","Replace")
                    enabled: _replaceField.text.length
                    icon.name: "checkmark"
                    onTriggered: document.replace(_findField.text, _replaceField.text)
                }
            }
            
            rightContent: [
            Button
            {
                enabled: _replaceField.text.length
                text: i18nd("mauikittexteditor","Replace All")
                onClicked: document.replaceAll(_findField.text, _replaceField.text)
            }
            ]
        }
    }
    
    header: Column
    {
        width: parent.width
        
        Repeater
        {
            model: document.alerts
            
            Maui.ToolBar
            {
                id: _alertBar
                property var alert : model.alert
                readonly property int index_ : index
                width: parent.width
                
                Maui.Theme.backgroundColor:
                {
                    switch(alert.level)
                    {
                        case 0: return Maui.Theme.positiveBackgroundColor
                        case 1: return Maui.Theme.neutralBackgroundColor
                        case 2: return Maui.Theme.negativeBackgroundColor
                    }
                }
                
                Maui.Theme.textColor:
                {
                    switch(alert.level)
                    {
                        case 0: return Maui.Theme.positiveTextColor
                        case 1: return Maui.Theme.neutralTextColor
                        case 2: return Maui.Theme.negativeTextColor
                    }
                }
                
                forceCenterMiddleContent: false
                    middleContent: Maui.ListItemTemplate
                    {
                        Maui.Theme.inherit: true
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
                            Maui.Theme.hoverColor: Qt.lighter(_alertBar.Maui.Theme.backgroundColor, 1)
                            Maui.Theme.textColor: Qt.darker(Maui.Theme.backgroundColor)
                        }
                    }
            }
        }    
    }
    
    contentItem: Item
    {   
        clip: false                   
        
        ScrollView
        {
            id: _scrollView
            anchors.fill: parent
            clip: false
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
                clip: false
                interactive: true
                boundsBehavior : Flickable.StopAtBounds
                boundsMovement : Flickable.StopAtBounds
                
                TextArea.flickable: TextArea
                {
                    id: body
                    Maui.Theme.inherit: true
                    text: document.text
                    
                    placeholderText: i18nd("mauikittexteditor","Body")
                    
                    textFormat: TextEdit.PlainText
                    
                    leftPadding: _linesCounter.width + padding
                    
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
//                         if(Maui.Handy.isMobile)
//                         {
//                             return
//                         }
//                         
                        documentMenu.targetClick(spellcheckhighlighterLoader, body.positionAt(point.position.x, point.position.y));
                    }
                    
                    onPressed:
                    {
                        if(Maui.Handy.isMobile)
                        {
                            return
                        }
                        
                        if(event.button === Qt.RightButton)
                        {
                            documentMenu.targetClick(spellcheckhighlighterLoader, body.positionAt(event.x, event.y))
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
                                        color: isCurrentItem ? control.Maui.Theme.highlightColor : control.body.color
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

            
            Maui.FloatingButton
            {
                visible: Maui.Handy.isTouch
                icon.name: "edit-menu"
                onClicked: documentMenu.targetClick(spellcheckhighlighterLoader, body.cursorPosition)
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.margins: Maui.Style.space.big
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
