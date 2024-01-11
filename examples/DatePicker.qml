import QtQuick
import QtQuick.Controls

import org.mauikit.controls as Maui
import org.mauikit.calendar as MC

import org.mauikit.dummy2 as Dummy

Maui.ApplicationWindow
{
    id: root

    Maui.Page
    {
        anchors.fill: parent
        Maui.Controls.showCSD: true
        title: root.title

        MC.DatePicker
        {
            id: _datePicker
            height: 300
            width: 300
            anchors.centerIn: parent

            onAccepted: (date) => root.title = date.toLocaleString()
        }
    }
}

