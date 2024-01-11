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

        MC.MonthsGrid
        {
            id: _view
            anchors.centerIn: parent
            selectedMonth: 5
        }
    }
}

