import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Kalendar


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
