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
    
    property int selectedMonth
    
    signal monthSelected(var month)
    
    contentItem: GridLayout
    {
        id: monthsGrid
        columns: 3
        
        ButtonGroup 
        {
            buttons: monthsGrid.children
        }        
        
        Repeater
        {
            model: 12
            
            
            delegate: Button
            {
                Layout.fillWidth: true
                text: Qt.locale().standaloneMonthName(index)
                
                checkable: true
                checked: control.selectedMonth === index                
                onClicked: 
                {
                    control.monthSelected(index)
                }
            }
        }
    }
}
