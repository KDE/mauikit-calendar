import QtQuick 
import QtQuick.Layouts 
import QtQuick.Controls 

import org.mauikit.controls as Maui
import org.mauikit.calendar as Kalendar

/**
 * @inherit QtQuick.Controls.Page
 * @brief A control for visualizing the months of the year.
 *
 * @image html monthsgrid.png
 *
 * @code
 * MC.MonthsGrid
 * {
 *    id: _view
 *    anchors.centerIn: parent
 *    selectedMonth: 5
 * }
 * @endcode
 */
Page
{
    id:  control
    background: null
    padding: Maui.Style.defaultPadding
    
    /**
     * @brief
     */
    property int selectedMonth
    
    /**
     * @brief
     */
    property alias columns : monthsGrid.columns
    
    /**
     * @brief
     * @param month
     */
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
                
                background: Rectangle
                {
                    visible: checked
                    color: checked ? Maui.Theme.highlightColor : hovered ? Maui.Theme.hoverColor : "transparent"
                    radius: Maui.Style.radiusV
                }
            }
        }
    }
}
