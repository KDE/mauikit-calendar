// Copyright (C) 2018 Michael Bohlender, <bohlender@kolabsys.com>
// Copyright (C) 2018 Christian Mollekopf, <mollekopf@kolabsys.com>
// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15 as QQC2

import org.mauikit.controls 1.3 as Maui
import org.maui.calendar 1.0 as Kalendar

import "dateutils.js" as DateUtils

QQC2.Pane
{
    id: control


    property date selectedDate: currentDate
    readonly property date currentDate: new Date()

    Timer
    {
        interval: 5000;
        running: true
        repeat: true
        onTriggered: currentDate = new Date()
    }

    signal monthClicked(var date)

    property date startDate
    property date firstDayOfMonth

    property int year : currentDate.getUTCFullYear()

    property bool initialMonth: true
    readonly property bool isLarge: width > Maui.Style.units.gridUnit * 40
    readonly property bool isTiny: width <= Maui.Style.units.gridUnit * 40

    property alias gridView : _gridView

    readonly property string title: control.year

   contentItem: Maui.GridView
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

            sourceComponent: Kalendar.Month
            {
                year: control.year
                month: modelData+1
                compact: control.isTiny
                onDateClicked: control.selectedDate = date
                onMonthClicked: control.monthClicked(date)
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

