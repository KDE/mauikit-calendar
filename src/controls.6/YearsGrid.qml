import QtQuick
import QtQuick.Layouts 
import QtQuick.Controls 

import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Kalendar

/**
 * @inherit QtQuick.Controls.Page
 * @brief A view for browsing calendar years.
 *  
 * @image html yearsgrid.png "Years view control"
 * 
 * @code
 * YearsGrid
 * {
 *    anchors.fill: parent
 * 
 *    from: 2010
 *    to: 2029
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
    property int from : 1999
    
    /**
     * @brief
     */
    property int to : 2100
    
    /**
     * @brief
     */
    property int selectedYear : 
    {
        var date = new Date()
        return date.getFullYear()
    }
    
    /**
     * @brief
     */
    property alias columns : _yearsGrid.columns
    
    /**
     * @brief
     * @param year
     */
    signal yearSelected(var year)
    
    contentItem: ScrollView
    {
        Flickable
        {
            contentHeight: _yearsGrid.implicitHeight
            contentWidth: availableWidth
            
            GridLayout
            {
                id: _yearsGrid
                
                anchors.fill: parent
                columns: Math.max(3, width/80)
                
                ButtonGroup 
                {
                    buttons: _yearsGrid.children
                }
                
                Repeater
                {
                    model: control.to - control.from + 1
                    delegate: Button
                    {
                        property int year :  control.from + modelData
                        Layout.fillWidth: true
                        Layout.maximumWidth: 80
                        text: year
                        
                        checkable: true
                        checked: year === control.selectedYear
                        onClicked: control.yearSelected(year) 
                        
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
    }
}
