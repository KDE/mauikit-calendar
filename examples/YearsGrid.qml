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

        headBar.leftContent: Maui.ToolButtonMenu
        {
            icon.name: "application-menu"

            MenuItem
            {
                text: "About"
                onTriggered: root.about()
            }
        }

        MC.YearsGrid
        {
            anchors.fill: parent

            from: 2010
            to: 2029
        }
    }
}

