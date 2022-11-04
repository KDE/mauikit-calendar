import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Kalendar


Page
{
    id:  control
    background: null
    padding: Maui.Style.space.medium
    
    property int from : 1999
    property int to : 2100
    
    property int selectedYear : to
    
    signal yearSelected(var year)
    
    contentItem: ScrollView
    {
        Flickable
        {
            contentHeight: _yearsGrid.implicitHeight
            contentWidth: availableWidth
            
            GridLayout
            {
                anchors.fill: parent
                id: _yearsGrid
                columns: 3
                
                ButtonGroup 
                {
                    buttons: _yearsGrid.children
                }
                
                Repeater
                {
                    model: control.to - control.from
                    delegate: Button
                    {
                        property int year :  control.from + modelData
                        Layout.fillWidth: true
                        
                        text: year
                        
                        checkable: true
                        checked: year === control.selectedYear
                        onClicked: control.yearSelected(year) 
                        
                        background: Rectangle
                        {
                            visible: checked
                            color: checked ? Maui.Theme.highlightColor : hovered ? Maui.Theme.focusColor : "transparent"
                            radius: Maui.Style.radiusV
                        }
                    }
                }
            }
        }
    }
}
