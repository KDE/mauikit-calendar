import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui
import org.mauikit.calendar as MC

import org.mauikit.dummy2 as Dummy

Maui.ApplicationWindow
{
    id: root
    title: _view.title

    Maui.Page
    {
        anchors.fill: parent
        Maui.Controls.showCSD: true
        title: root.title

        MC.YearView
        {
            id: _view
            anchors.fill: parent

            onSelectedDateChanged: root.title = selectedDate.toString()

            onMonthClicked: (month) => console.log("Month Clicked, ", month)
        }
    }
}

