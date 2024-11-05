// Copyright (C) 2018 Michael Bohlender, <bohlender@kolabsys.com>
// Copyright (C) 2018 Christian Mollekopf, <mollekopf@kolabsys.com>
// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick
import QtQuick.Layouts 
import QtQuick.Controls 

import org.mauikit.controls as Maui
import org.mauikit.calendar as Kalendar

import "dateutils.js" as DateUtils

/**
 * @inherit QtQuick.Controls.Pane
 * @brief A browsing view of the calendar organized by years.
 *
 * @image html yearview.png
 *
 * @code
 * Maui.ApplicationWindow
 * {
 *    id: root
 *    title: _view.title
 *
 *    Maui.Page
 *    {
 *        anchors.fill: parent
 *        Maui.Controls.showCSD: true
 *        title: root.title
 *
 *        MC.YearView
 *        {
 *            id: _view
 *            anchors.fill: parent
 *
 *            onSelectedDateChanged: root.title = selectedDate.toString()
 *
 *            onMonthClicked: (month) => console.log("Month Clicked, ", month)
 *        }
 *    }
 * }
 * @endcode
 */
Pane
{
    id: control
    
    /**
     * @brief
     */
    property date selectedDate: currentDate
    
    /**
     * @brief
     */
    readonly property date currentDate: new Date()

    /**
     * @brief
     */
    property date startDate
    
    /**
     * @brief
     */
    property date firstDayOfMonth
    
    /**
     * @brief
     */
    property int year : currentDate.getUTCFullYear()
    
    /**
     * @brief
     */
    property bool initialMonth: true
    
    /**
     * @brief
     */
    readonly property bool isLarge: width > Maui.Style.units.gridUnit * 40
    
    /**
     * @brief
     */
    readonly property bool isTiny: width <= Maui.Style.units.gridUnit * 40
    
    /**
     * @brief
     */
    readonly property alias gridView : _gridView
    
    /**
     * @brief
     */
    readonly property string title: control.year
    
    /**
     * @brief
     * @param date
     */
    signal monthClicked(var date)
    
    contentItem: Maui.GridBrowser
    {
        id: _gridView
        
        itemHeight: Math.max(itemSize, 160)
        itemSize: Math.min(width/3, 400)
        
        currentIndex: currentDate.getUTCMonth()
        model: 12
        
        delegate: Loader
        {
            id: viewLoader
            
            property bool isNextOrCurrentItem: index >= _gridView.currentIndex -1 && index <= _gridView.currentIndex + 1
            property bool isCurrentItem: GridView.isCurrentItem
            
            active: true
            asynchronous: !isCurrentItem
            visible: status === Loader.Ready
            
            width: GridView.view.cellWidth - (control.isTiny ? 0 : Maui.Style.space.small)
            height: GridView.view.cellHeight - (control.isTiny ? 0 : Maui.Style.space.small)
            
            sourceComponent: Kalendar.DaysGrid
            {
                //                 Maui.Theme.colorSet: Maui.Theme.Button
                //                 Maui.Theme.inherit: false
                //
                id: _monthDelegate
                year: control.year
                month: modelData+1
                compact: control.isTiny
                onDateClicked: (date) => control.selectedDate = date
                header: Maui.LabelDelegate
                {
                    width: parent.width
                    isSection: true
                    color: Maui.Theme.textColor
                    text: _monthDelegate.title
                }
                
                background: Rectangle
                {
                    color:  _monthDelegate.month === control.currentDate.getUTCMonth()+1 ? Maui.Theme.alternateBackgroundColor : (_monthDelegate.hovered ? Maui.Theme.hoverColor : Maui.Theme.backgroundColor)
                    radius: Maui.Style.radiusV
                    
                    MouseArea
                    {
                        id: _mouseArea
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: control.monthClicked(new Date(_monthDelegate.year, _monthDelegate.month))
                    }
                }
            }
        }
        
        Component.onCompleted: _gridView.flickable.positionViewAtIndex(_gridView.currentIndex, GridView.Visible)
    }
    
    function resetDate()
    {
        control.year = control.currentDate.getUTCFullYear()
    }
    
    function nextDate()
    {
        control.year++
    }
    
    function previousDate()
    {
        control.year--
    }
}

