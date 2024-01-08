import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 

import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Kalendar

import "dateutils.js" as DateUtils

Page
{
    id: control

    signal dateClicked(var date)
    signal dateRightClicked(var date)

    property bool compact : false

    property alias model : _monthModel
    property alias year: _monthModel.year
    property alias month : _monthModel.month

    title : _monthModel.monthName(control.month)

    padding: control.compact ? Maui.Style.space.small : Maui.Style.defaultPadding    

    Kalendar.MonthModel
    {
        id: _monthModel
    }
    
    background: null

    GridLayout
    {
        id: _daysGrid
        anchors.fill: parent

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
                    color: checked ? Maui.Theme.highlightColor : hovered ? Maui.Theme.hoverColor : "transparent"
                    radius: Maui.Style.radiusV
                }
            }
        }
    }
}
