import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 

import org.mauikit.controls as Maui
import org.mauikit.calendar as Kalendar

import "dateutils.js" as DateUtils

/**
 * @inherit QtQuick.Controls.Page
 * @brief A control for quickly picking a date in the format of year, month and day number.
 * 
 * @image html daysgrid.png
 * 
 * @code 
 *
 * Maui.ApplicationWindow
 * {
 *    id: root
 *    title: _daysGrid.year
 *    Maui.Page
 *    {
 *        anchors.fill: parent
 *        Maui.Controls.showCSD: true
 *        title: root.title
 * 
 *        MC.DaysGrid
 *        {
 *            id: _daysGrid
 *            height: 300
 *            width: 300
 *            anchors.centerIn: parent
 * 
 *            year: 1993
 *            month: 5
 * 
 *            onDateClicked: (date) => root.title = date.toString()
 *        }
 *    }
 * }
 * @endcode
 */
Page
{
    id: control
    
    /**
     * @brief
     */
    property bool compact : false
    
    /**
     * @brief
     */
    readonly property alias model : _monthModel
    
    /**
     * @brief
     */
    property alias year: _monthModel.year
    
    /**
     * @brief
     */
    property alias month : _monthModel.month    
    
    /**
     * @brief
     * @param date
     */
    signal dateClicked(var date)
    
    /**
     * @brief
     * @param date
     */
    signal dateRightClicked(var date)
    
    title : _monthModel.monthName(control.month)
    
    padding: control.compact ? Maui.Style.space.small : Maui.Style.defaultPadding    
    
    Kalendar.MonthModel
    {
        id: _monthModel
    }
    
    background: null
    
    contentItem: GridLayout
    {
        id: _daysGrid
        
        columns: 7
        rows: 7
        
        columnSpacing: control.compact ? 0 : Maui.Style.space.small
        rowSpacing:  control.compact ? 0 : Maui.Style.space.small
        
        ButtonGroup 
        {
            buttons: _daysGrid.children
        }
        
        Repeater
        {
            model: _monthModel
            
            delegate: Button
            {
                Maui.Theme.colorSet: Maui.Theme.View
                Maui.Theme.inherit: false
                
                Layout.fillWidth: true
                Layout.fillHeight: true
                
                padding: 0
                
                highlighted: model.isToday
                
                checkable: true
                checked: model.isToday
                
                opacity: sameMonth ? 1 : 0.7
                
                text: model.dayNumber
                
                font.bold: model.isToday
                font.weight: checked ? Font.Bold : Font.Normal
                font.pointSize: control.compact ? Maui.Style.fontSizes.tiny : Maui.Style.fontSizes.medium
                
                onClicked: control.dateClicked(model.date)
                
                background: Rectangle
                {
                    visible: sameMonth
                    color: checked || pressed ? Maui.Theme.highlightColor : hovered ? Maui.Theme.hoverColor : "transparent"
                    radius: Maui.Style.radiusV
                }
            }
        }
    }
}
