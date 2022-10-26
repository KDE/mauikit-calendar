import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Kalendar


Page
{
    id:  control
    
    readonly property string startTime : "12:00" + format
    
    property int selectedMinute: 0
    property int selectedHour: 12
    
    property string selectedTime : startTime
    
    property string format: "AM"
    
    signal accepted(var time)
    
    background: null
    
    header: ToolBar
    {
        width: parent.width
        background: null
        
        contentItem: RowLayout
        {
            spacing: 0
            
            Maui.ToolActions
            {
                id: _dateGroup
                autoExclusive: true
                
                Action
                {
                    text: i18n("AM")
                    checked: control.format === text
                    onTriggered: control.format = text
                }
                
                Action
                {
                    text: i18n("PM")
                    checked: control.format === text
                    
                    onTriggered: control.format = text
                }
            }
            
            Item {Layout.fillWidth: true}
            
            Button
            {
                text: i18n("Done")
                onClicked:
                {
                    control.updateSelectedTime(minutesTumbler.currentIndex, hoursTumbler.currentIndex-1, control.format)
                     control.accepted(control.selectedTime)
                }
            }
        }
    }    
    
    contentItem: Item
    {
        function formatText(count, modelData) {
            var data = count === 12 ? modelData + 1 : modelData;
            return data.toString().length < 2 ? "0" + data : data;
        }
        
        
        Component 
        {
            id: delegateComponent
            
            Button 
            {
                text: formatText(Tumbler.tumbler.count, modelData)
                opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
               
                onClicked: 
                {
                    Tumbler.tumbler.currentIndex = modelData
                    control.updateSelectedTime(minutesTumbler.currentIndex, hoursTumbler.currentIndex)
                }
            }
        }
        
       
            Row
            {
                id: row
                height: parent.height
                anchors.horizontalCenter: parent.horizontalCenter
                
                spacing: Maui.Style.space.medium
                
                Tumbler
                {
                    id: hoursTumbler
                    spacing: Maui.Style.space.medium
                    model: 12
                    currentIndex: control.selectedHour - 1
                    delegate: delegateComponent
                    
                }
                
                Tumbler 
                {
                    id: minutesTumbler
                    model: 60
                    spacing: Maui.Style.space.medium
                    
                    currentIndex: control.selectedMinute
                    delegate: delegateComponent
                    
                }
            }
        
    }
    
    function formatText(count, modelData)
    {
        var data = count === 12 ? modelData + 1 : modelData;
        return data.toString().length < 2 ? "0" + data : data;
    }
    
    function updateSelectedTime(minute, hour, format)
    {
        control.selectedMinute = minute
        control.selectedHour = hour
        
        control.selectedTime= formatText(12, hour)+":"+formatText(60, minute) + control.format
    }
    
    
}
