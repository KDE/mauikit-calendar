import QtQuick
import QtQuick.Layouts 
import QtQuick.Controls

import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Kalendar

/**
 * @inherit QtQuick.Controls.ComboBox
 * @brief A combobox designed for picking a time using a hour and minute format.
 * 
 * @image html timecombobox.png
 * 
 * @code
 * MC.TimeComboBox
 * {
 *    id: _view
 *    anchors.centerIn: parent
 *    onTimePicked: (time) => console.log("Time Picked, ", time)
 * }
 * @endcode
 */
ComboBox
{
    id:  control
    
    enabled: true
    
    /**
     * @brief
     */
    property alias selectedHour : _picker.selectedHour
    
    /**
     * @brief
     */
    property alias selectedMinute: _picker.selectedMinute
    
    /**
     * @brief
     */
    property alias timeZoneOffset : _picker.timeZoneOffset
    
    /**
     * @brief
     */
    property alias selectedTime : _picker.selectedTime 
    
    /**
     * @brief
     * @param time
     */
    signal timePicked(var time)
    
    displayText: _picker.selectedTime    
    
    font.bold: true
    font.weight: Font.Bold
    font.family: "Monospace"
    
    icon.source: "clock"   
    
    popupContent: Kalendar.TimePicker
    {
        id: _picker
        onAccepted:
        {
            control.timePicked(time)
            control.accepted()
            control.popup.close()
        }
    }    
}
