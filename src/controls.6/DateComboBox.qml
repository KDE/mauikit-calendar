import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import org.mauikit.controls as Maui
import org.mauikit.calendar as Kalendar

ComboBox
{
    id:  control
    enabled: true

    property alias selectedMonth : _picker.selectedMonth
    property alias selectedYear: _picker.selectedYear
    property alias selectedDay : _picker.selectedDay

    property alias selectedDate : _picker.selectedDate

    displayText: selectedDate.toLocaleDateString()
    
    font.bold: true
    font.weight: Font.Bold
    font.family: "Monospace"
    icon.source: "view-calendar"
    
    signal datePicked(var date)
    
    popupContent: Kalendar.DatePicker
    {
        id: _picker
        implicitHeight: 300
        background: null
        
        onAccepted:
        {
            control.datePicked(date)
            control.accepted()
            control.popup.close()
        }
    }
}
