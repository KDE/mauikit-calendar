import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Kalendar

ComboBox
{
    id:  control
    enabled: true

    readonly property alias startTime : _picker.startTime

    property alias selectedHour : _picker.selectedHour
    property alias selectedMinute: _picker.selectedMinute

    displayText: _picker.selectedTime
    
    font.bold: true
    font.weight: Font.Bold
    font.family: "Monospace"
    
    icon.source: "clock"

    popupContent: Kalendar.TimePicker
{
        id: _picker
        onAccepted: control.popup.close()
    }

}
