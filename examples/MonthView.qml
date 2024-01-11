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

        title: _monthsView.title

        headBar.rightContent: Maui.ToolActions
        {
            checkable: false
            Action
            {
                icon.name: "go-previous"
                onTriggered: _monthsView.previousDate()
            }

            Action
            {
                icon.name: "go-next"
                onTriggered: _monthsView.nextDate()

            }
        }

        MC.MonthView
        {
            id: _monthsView
            anchors.fill: parent
        }
    }
}

