import QtQuick 2.15
import QtQml 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Cal

Pane
{
id: control
implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
padding: 0
background: null

contentItem: ColumnLayout
{
    id: _layout
 spacing: Maui.Style.space.huge
Maui.SettingsSection
{
    title: i18n("Info")

    Maui.SettingTemplate
    {
        label1.text: i18n("Description")

        TextField
        {
            width: parent.parent.width
            height: 80
            placeholderText: i18n("Event description ...")
        }
    }

    Maui.SettingTemplate
    {
        label1.text: i18n("Calendar")

        ComboBox
        {
            width: parent.parent.width
        }
    }
}


Maui.SettingsSection
{
    title: i18n("Time")

    Maui.SettingTemplate
    {
        label1.text: i18n("All day")

        Switch
        {
        }
    }

    Maui.SettingTemplate
    {
        label1.text: i18n("Start")

       Column
       {
           spacing: Maui.Style.space.medium
           width: parent.parent.width

           Cal.DateComboBox
           {
width: parent.width
           }

           Cal.TimeComboBox
           {
width: parent.width
           }

       }
    }

    Maui.SettingTemplate
    {
        label1.text: i18n("End")

        Column
        {
            spacing: Maui.Style.space.medium
            width: parent.parent.width

            ComboBox
            {
 width: parent.width
            }

            ComboBox
            {
 width: parent.width
            }

        }
    }

    Maui.SettingTemplate
    {
        label1.text: i18n("TimeZone")

        ComboBox
        {
            width: parent.parent.width
        }
    }
}
}

}
