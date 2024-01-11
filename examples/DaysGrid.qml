import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui
import org.mauikit.calendar as MC

import org.mauikit.dummy2 as Dummy

Maui.ApplicationWindow
{
    id: root
    title: _daysGrid.year

    Maui.Page
    {
        anchors.fill: parent
        Maui.Controls.showCSD: true
        title: root.title

        MC.DaysGrid
        {
            id: _daysGrid
            height: 300
            width: 300
            anchors.centerIn: parent

            year: 1993
            month: 5

            onDateClicked: (date) => root.title = date.toString()
        }
    }
}

