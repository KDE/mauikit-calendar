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

    padding : 0

    readonly property date currentDate: new Date()
    readonly property string title: Qt.formatDate(pathView.currentItem.firstDayOfMonth, "MMM yyyy")

    property var openOccurrence: ({})
    property var filter: {
        "collectionId": -1,
        "tags": [],
        "name": ""
    }

    property alias model :  _monthViewModel
    property date startDate
    property date firstDayOfMonth
    property int month
    property int year
    property bool initialMonth: true

    readonly property bool isLarge: width > Maui.Style.units.gridUnit * 40
    readonly property bool isTiny: width < Maui.Style.units.gridUnit * 18

    property date selectedDate : currentDate

    property bool dragDropEnabled: true

    background: Rectangle
    {
        color: Maui.Theme.backgroundColor
    }

    Kalendar.InfiniteCalendarViewModel
    {
        id: _monthViewModel
        scale: Kalendar.InfiniteCalendarViewModel.MonthScale
        //        calendar: CalendarManager.calendar
        //        filter: root.filter
    }


    function setToDate(date, isInitialMonth = true)
    {
        control.initialMonth = isInitialMonth;
        let monthDiff = date.getMonth() - pathView.currentItem.firstDayOfMonth.getMonth() + (12 * (date.getFullYear() - pathView.currentItem.firstDayOfMonth.getFullYear()))
        let newIndex = pathView.currentIndex + monthDiff;

        let firstItemDate = pathView.model.data(pathView.model.index(1,0), Kalendar.InfiniteCalendarViewModel.FirstDayOfMonthRole);
        let lastItemDate = pathView.model.data(pathView.model.index(pathView.model.rowCount() - 1,0), Kalendar.InfiniteCalendarViewModel.FirstDayOfMonthRole);

        while(firstItemDate >= date) {
            pathView.model.addDates(false)
            firstItemDate = pathView.model.data(pathView.model.index(1,0), Kalendar.InfiniteCalendarViewModel.FirstDayOfMonthRole);
            newIndex = 0;
        }
        if(firstItemDate < date && newIndex === 0) {
            newIndex = date.getMonth() - firstItemDate.getMonth() + (12 * (date.getFullYear() - firstItemDate.getFullYear())) + 1;
        }

        while(lastItemDate <= date) {
            pathView.model.addDates(true)
            lastItemDate = pathView.model.data(pathView.model.index(pathView.model.rowCount() - 1,0), Kalendar.InfiniteCalendarViewModel.FirstDayOfMonthRole);
        }
        pathView.currentIndex = newIndex;
    }



   contentItem:  PathView
    {
        id: pathView

        flickDeceleration: Maui.Style.units.longDuration


        preferredHighlightBegin: 0.5
                   preferredHighlightEnd: 0.5

//                   highlightRangeMode: ListView.StrictlyEnforceRange
                   highlightMoveDuration: 0


        //        spacing: 10
        snapMode: PathView.SnapToItem
        focus: true
        //        interactive: Kirigami.Settings.tabletMode

        path: Path {
            startX: - pathView.width * pathView.count / 2 + pathView.width / 2
            startY: pathView.height / 2
            PathLine {
                x: pathView.width * pathView.count / 2 + pathView.width / 2
                y: pathView.height / 2
            }
        }

        model: control.model

        property int startIndex

        Component.onCompleted:
        {
            startIndex = count / 2;
            currentIndex = startIndex;
        }

        onCurrentIndexChanged:
        {
            control.startDate = currentItem.startDate;
            control.firstDayOfMonth = currentItem.firstDayOfMonth;
            control.month = currentItem.month;
            control.year = currentItem.year;

            if(currentIndex >= count - 2) {
                model.addDates(true);
            } else if (currentIndex <= 1) {
                model.addDates(false);
                startIndex += model.datesToAdd;
            }
        }

        delegate: Loader
        {
            id: viewLoader

            property date startDate: model.startDate
            property date firstDayOfMonth: model.firstDay
            property int month: model.selectedMonth - 1 // Convert QDateTime month to JS month
            property int year: model.selectedYear

            property bool isNextOrCurrentItem: index >= pathView.currentIndex -1 && index <= pathView.currentIndex + 1
            property bool isCurrentItem: PathView.isCurrentItem

            active: isNextOrCurrentItem
            asynchronous: !isCurrentItem
            visible: status === Loader.Ready

            sourceComponent: Kalendar.DayGridView
            {
                id: dayView
                objectName: "monthView"

                width: pathView.width
                height: pathView.height

                //                model: monthViewModel // from control model
                isCurrentView: viewLoader.isCurrentItem
                dragDropEnabled: control.dragDropEnabled

                startDate: viewLoader.startDate
                currentDate: control.currentDate
                month: viewLoader.month

                onDateClicked: control.selectedDate = date

                dayHeaderDelegate: QQC2.Control
                {
                    leftPadding: Maui.Style.units.smallSpacing
                    rightPadding: Maui.Style.units.smallSpacing

                    contentItem: Maui.LabelDelegate
                    {
                        label:
                        {
                            let longText = day.toLocaleString(Qt.locale(), "dddd");
                            let midText = day.toLocaleString(Qt.locale(), "ddd");
                            let shortText = midText.slice(0,1);


                            return control.isTiny ? shortText : midText;
                        }


                        labelTxt.horizontalAlignment: Text.AlignRight
                        labelTxt.font.bold: true
                        labelTxt.font.weight: Font.Bold
                        labelTxt.font.pointSize: Maui.Style.fontSizes.big

                    }
                }

                weekHeaderDelegate: Maui.LabelDelegate
                {
                    padding: Maui.Style.units.smallSpacing
                    //                                        verticalAlignment: Qt.AlignTop
                    labelTxt.horizontalAlignment: Qt.AlignHCenter
                    label: DateUtils.getWeek(startDate, Qt.locale().firstDayOfWeek)
                    //                    background: Rectangle {
                    //                        Kirigami.Theme.inherit: false
                    //                        Kirigami.Theme.colorSet: Kirigami.Theme.View
                    //                        color: Kirigami.Theme.backgroundColor
                    //                    }
                }

                openOccurrence: control.openOccurrence
            }
        }
    }

    function resetDate()
    {
        setToDate(new Date())
    }

    function nextDate()
    {
        setToDate(DateUtils.addMonthsToDate(pathView.currentItem.firstDayOfMonth, 1))
    }

    function previousDate()
    {
        setToDate(DateUtils.addMonthsToDate(pathView.currentItem.firstDayOfMonth, -1))
    }

    function addMonthsToDate(date, days)
    {
        return DateUtils.addMonthsToDate(date, days)
    }
}

