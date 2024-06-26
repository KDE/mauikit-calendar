// Copyright (C) 2018 Michael Bohlender, <bohlender@kolabsys.com>
// Copyright (C) 2018 Christian Mollekopf, <mollekopf@kolabsys.com>
// SPDX-FileCopyrightText: 2021 Claudio Cambra <claudio.cambra@gmail.com>
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.mauikit.controls as Maui

import org.mauikit.calendar as Kalendar
import "dateutils.js" as DateUtils
import "labelutils.js" as LabelUtils

QQC2.Pane
{
    id: root

    property var openOccurrence
    property var model

    property int daysToShow: daysPerRow * 6
    property int daysPerRow: 7
    property double weekHeaderWidth: root.showWeekNumbers ? Maui.Style.units.gridUnit * 1.5 : 0
    property date currentDate

    property int currentDay: currentDate ? currentDate.getDate() : null
    property int currentMonth: currentDate ? currentDate.getMonth() : null
    property int currentYear: currentDate ? currentDate.getFullYear() : null

    property date startDate
    
    property bool paintGrid: true
    property bool showDayIndicator: true

    property Component dayHeaderDelegate
    property Component weekHeaderDelegate

    property int month
    property alias bgLoader: backgroundLoader.item
    property bool isCurrentView: true
    property bool dragDropEnabled: true
    property bool showWeekNumbers : false

    //Internal
    property int numberOfLinesShown: 0
    property int numberOfRows: (daysToShow / daysPerRow)

    property int dayWidth: (root.showWeekNumbers ?
                                ((width - weekHeaderWidth) / daysPerRow) - spacing : // No spacing on right, spacing in between weekheader and monthgrid
                                (width -  rightPadding  - leftPadding - weekHeaderWidth - (spacing * (daysPerRow - 1))) / daysPerRow) // No spacing on left or right of month grid when no week header

    property int dayHeight: ((height - topPadding - bottomPadding - bgLoader.dayLabelsBar.height) / numberOfRows) - spacing

    readonly property bool isDark: KalendarUiUtils.darkMode
    //    readonly property int mode: Kalendar.KalendarApplication.Event

    //    implicitHeight: (numberOfRows > 1 ? Maui.Style.units.gridUnit * 10 * numberOfRows : numberOfLinesShown * Maui.Style.units.gridUnit) + bgLoader.dayLabelsBar.height +topPadding + bottomPadding
    //    height: implicitHeight
    readonly property bool isWide : dayWidth > Maui.Style.units.gridUnit * 5

    padding: Maui.Style.space.medium
    spacing: Maui.Style.space.small
    background: null
    
    signal dateClicked(var date)
    signal dateDoubleClicked(var date)
    
    contentItem: Loader
    {
        id: backgroundLoader
        asynchronous: !root.isCurrentView
        sourceComponent: Column
        {
            id: rootBackgroundColumn
            spacing: root.spacing

            property alias dayLabelsBar: dayLabelsBarComponent
            Kalendar.DayLabelsBar
            {
                id: dayLabelsBarComponent
                delegate: root.dayHeaderDelegate
                startDate: root.startDate
                dayWidth: root.dayWidth
                daysToShow: root.daysPerRow
                spacing: root.spacing
                anchors.leftMargin: root.showWeekNumbers ? weekHeaderWidth + root.spacing : 0
                anchors.left: parent.left
                anchors.right: parent.right
            }

            Repeater
            {
                model: root.numberOfRows

                //One row => one week
                Item
                {
                    width: parent.width
                    height: root.dayHeight
                    clip: true

                    RowLayout
                    {
                        width: parent.width
                        height: parent.height
                        spacing: root.spacing

                        Loader
                        {
                            id: weekHeader
                            sourceComponent: root.weekHeaderDelegate
                            property date startDate: DateUtils.addDaysToDate(root.startDate, index * 7)
                            Layout.preferredWidth: weekHeaderWidth
                            Layout.fillHeight: true
                            active: root.showWeekNumbers
                            visible: root.showWeekNumbers
                        }

                        Item
                        {
                            id: dayDelegate
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            property date startDate: DateUtils.addDaysToDate(root.startDate, index * 7)

                            //Grid
                            Row
                            {
                                spacing: root.spacing
                                height: parent.height

                                Repeater
                                {
                                    id: gridRepeater
                                    model: root.daysPerRow

                                    QQC2.Button
                                    {
                                        id: gridItem
                                        Maui.Theme.colorSet: Maui.Theme.View
                                        Maui.Theme.inherit: false

                                        height: root.dayHeight
                                        width: root.dayWidth
                                        enabled: root.daysToShow > 1
                                        visible: root.showDayIndicator
                                        padding: Maui.Style.space.small
                                        onClicked: root.dateClicked(gridItem.date)
                                        onDoubleClicked: root.dateDoubleClicked(gridItem.date)

                                        property date gridSquareDate: date
                                        property date date: DateUtils.addDaysToDate(dayDelegate.startDate, modelData)
                                        property int day: date.getDate()
                                        property int month: date.getMonth()
                                        property int year: date.getFullYear()
                                        property bool isToday: day === root.currentDay && month === root.currentMonth && year === root.currentYear
                                        property bool isCurrentMonth: month === root.month

                                        background: Rectangle
                                        {
                                            visible: gridItem.isCurrentMonth
                                            color: gridItem.isToday ? Maui.Theme.activeBackgroundColor :
                                                                      gridItem.hovered ? Maui.Theme.hoverColor : Maui.Theme.alternateBackgroundColor
                                            radius: Maui.Style.radiusV
                                        }

                                        contentItem: ColumnLayout
                                        {
                                            spacing: Maui.Style.space.medium
                                            RowLayout
                                            {
                                                id: dayNumberLayout
                                                Layout.fillWidth: true
                                                visible: root.showDayIndicator


                                                QQC2.Label
                                                {
                                                    Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                                                    text: i18n("Today")
                                                    renderType: Text.QtRendering
                                                    color: Maui.Theme.highlightedTextColor
                                                    visible: gridItem.isToday && root.isWide
                                                    font.bold: root.isWide
                                                    font.weight: root.isWide ? Font.Bold : Font.Normal
                                                    font.pointSize: root.isWide ? Maui.Style.fontSizes.big : Maui.Style.fontSizes.small
                                                }

                                                QQC2.Label
                                                {
                                                    Layout.alignment: gridItem.width > Maui.Style.units.gridUnit * 5 ? Qt.AlignRight | Qt.AlignTop : Qt.AlignCenter

                                                    text: gridItem.date.toLocaleDateString(Qt.locale(), gridItem.day == 1 && root.isWide ? "d MMM" : "d")
                                                    renderType: Text.QtRendering
                                                    horizontalAlignment: Qt.AlignHCenter

                                                    color: gridItem.isToday ?
                                                               Maui.Theme.highlightedTextColor :
                                                               (!gridItem.isCurrentMonth ? Maui.Theme.disabledTextColor : Maui.Theme.textColor)
                                                    font.bold: root.isWide
                                                    font.weight: root.isWide ? Font.Bold : Font.Normal
                                                    font.pointSize: root.isWide ? Maui.Style.fontSizes.big : Maui.Style.fontSizes.small

                                                }
                                            }


                                            Flow
                                            {
                                                width: parent.width
                                                Layout.alignment: Qt.AlignBottom
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true
                                                spacing: Maui.Style.space.tiny
                                                clip: true

                                                Repeater
                                                {
                                                    model: Kalendar.IncidenceOccurrenceModel
                                                    {
                                                        start: gridItem.date
                                                        length: 0
                                                        calendar: Kalendar.CalendarManager.calendar
                                                        filter: Kalendar.Filter
                                                    }




                                                    delegate: Rectangle
                                                    {
                                                        radius: height
                                                        height: 10
                                                        width: height
                                                        color: randomColor(150)

                                                        function randomColor(brightness){
                                                            function randomChannel(brightness){
                                                                var r = 255-brightness;
                                                                var n = 0|((Math.random() * r) + brightness);
                                                                var s = n.toString(16);
                                                                return (s.length==1) ? '0'+s : s;
                                                            }
                                                            return '#' + randomChannel(brightness) + randomChannel(brightness) + randomChannel(brightness);
                                                        }

                                                    }
                                                }
                                            }

                                        }

                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    //    Loader {
    //        id: foregroundLoader
    //        anchors.fill: parent
    //        asynchronous: !root.isCurrentView
    //        sourceComponent: Column {
    //            id: rootForegroundColumn
    //            spacing: root.spacing
    //            anchors {
    //                fill: parent
    //                topMargin: root.bgLoader.dayLabelsBar.height + root.spacing
    //                leftMargin: root.showWeekNumbers ? weekHeaderWidth + root.spacing : 0
    //            }

    //            //Weeks
    //            Repeater {
    //                model: root.model
    //                //One row => one week
    //                Item {
    //                    width: parent.width
    //                    height: root.dayHeight
    //                    clip: true
    //                    RowLayout {
    //                        width: parent.width
    //                        height: parent.height
    //                        spacing: root.spacing
    //                        Item {
    //                            id: dayDelegate
    //                            Layout.fillWidth: true
    //                            Layout.fillHeight: true
    //                            property date startDate: periodStartDate

    //                            ListView {
    //                                id: linesRepeater

    //                                anchors {
    //                                    fill: parent
    //                                    // Offset for date
    //                                    topMargin: root.showDayIndicator ? Kirigami.Units.gridUnit + Kirigami.Units.largeSpacing * 1.5 : 0
    //                                    rightMargin: spacing
    //                                }

    //                                // DO NOT use a ScrollView as a bug causes this to crash randomly.
    //                                // So we instead make the ListView act like a ScrollView on desktop. No crashing now!
    //                                flickableDirection: Flickable.VerticalFlick
    //                                boundsBehavior: Kirigami.Settings.isMobile ? Flickable.DragAndOvershootBounds : Flickable.StopAtBounds
    //                                QQC2.ScrollBar.vertical: QQC2.ScrollBar {}

    //                                clip: true
    //                                spacing: root.listViewSpacing

    //                                DayMouseArea {
    //                                    id: listViewMenu
    //                                    anchors.fill: parent
    //                                    z: -1

    //                                    function useGridSquareDate(type, root, globalPos) {
    //                                        for(var i in root.children) {
    //                                            var child = root.children[i];
    //                                            var localpos = child.mapFromGlobal(globalPos.x, globalPos.y);

    //                                            if(child.contains(localpos) && child.gridSquareDate) {
    //                                                KalendarUiUtils.setUpAdd(type, child.gridSquareDate);
    //                                            } else {
    //                                                useGridSquareDate(type, child, globalPos);
    //                                            }
    //                                        }
    //                                    }

    //                                    onAddNewIncidence: useGridSquareDate(type, applicationWindow().contentItem, this.mapToGlobal(clickX, clickY))
    //                                    onDeselect: KalendarUiUtils.appMain.incidenceInfoDrawer.close()
    //                                }

    //                                model: incidences
    //                                onCountChanged: {
    //                                    root.numberOfLinesShown = count
    //                                }

    //                                delegate: Item {
    //                                    id: line
    //                                    height: Kirigami.Units.gridUnit + Kirigami.Units.smallSpacing

    //                                    //Incidences
    //                                    Repeater {
    //                                        id: incidencesRepeater
    //                                        model: modelData

    //                                        DayGridViewIncidenceDelegate {
    //                                            id: incidenceDelegate
    //                                            dayWidth: root.dayWidth
    //                                            height: line.height
    //                                            parentViewSpacing: root.spacing
    //                                            horizontalSpacing: linesRepeater.spacing
    //                                            openOccurrenceId: root.openOccurrence ? root.openOccurrence.incidenceId : ""
    //                                            isDark: root.isDark
    //                                            dragDropEnabled: root.dragDropEnabled
    //                                        }
    //                                    }
    //                                }
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //    }
}
