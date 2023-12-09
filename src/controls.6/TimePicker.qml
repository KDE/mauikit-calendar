import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Kalendar


Page
{
    id:  control
    
    readonly property date startTime : new Date()
    
    property int selectedMinute: selectedTime.getMinutes()
    property int selectedHour: selectedTime.getHours()
    property int timeZoneOffset : 0
    property date selectedTime : startTime
    
    property string format: control.selectedHour < 12 ? "AM" : "PM"
    
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
                    control.updateSelectedTime(minutesTumbler.currentIndex, hoursTumbler.currentIndex, control.format)
                     control.accepted(control.selectedTime)
                }
            }
        }
    }    
    
    contentItem: Item
    {
        
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
                    currentIndex: formatUTCHour(control.selectedHour)                                      
                    
                    delegate:  Button 
                    {
                        font.bold: checked
                        
                        checked : index === Tumbler.tumbler.currentIndex
                        text: formatText(Tumbler.tumbler.count, modelData)
                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                        
                        onClicked: 
                        {
                            Tumbler.tumbler.currentIndex = modelData
                            control.updateSelectedTime(minutesTumbler.currentIndex, hoursTumbler.currentIndex)
                        }
                        
                        background: Rectangle
                        {
                            visible: checked
                            color: checked ? Maui.Theme.highlightColor : hovered ? Maui.Theme.focusColor : "transparent"
                            radius: Maui.Style.radiusV
                        }
                    }
                    
                }
                
                Tumbler 
                {
                    id: minutesTumbler
                    model: 60
                    spacing: Maui.Style.space.medium
                                        
                    currentIndex: control.selectedMinute
                    
                    Label
                    {
                        text: minutesTumbler.currentIndex
                        color: "yellow"
                    }
                    
                    delegate:  Button 
                    {
                        font.bold: checked
                        checked : index === Tumbler.tumbler.currentIndex
                        text: formatText(Tumbler.tumbler.count, modelData)
                        opacity: 1.0 - Math.abs(Tumbler.displacement) / (Tumbler.tumbler.visibleItemCount / 2)
                        
                        onClicked: 
                        {
                            Tumbler.tumbler.currentIndex = modelData
                            control.updateSelectedTime(minutesTumbler.currentIndex, hoursTumbler.currentIndex)
                        }
                        
                        background: Rectangle
                        {
                            visible: checked
                            color: checked ? Maui.Theme.highlightColor : hovered ? Maui.Theme.focusColor : "transparent"
                            radius: Maui.Style.radiusV
                        }
                    }                    
                }
            } 
            
            // Label
            // {
            //     text: hoursTumbler.currentIndex + " / " + control.selectedTime.getUTCHours()
            //     color: "yellow"
            // }
    }
    
    
    function formatUTCHour(hour : int)
    {
        if(hour > 12)
        {
            return hour - 12;
        }
        
        return hour
    }
    
    function formatHourToUTC(hour, format)
    {
        if(format == "AM")
        {
            if(hour >= 11)
            {
                return 0;
            }
            
            return hour + 1
        }
        
        
        if(hour >= 11)
        {
            return 23
        }
        
        return 12 + hour +1;
    }
    
    function formatText(count : int, modelData : int)
    {
        var data = count === 12 ? modelData + 1 : modelData;
        return data.toString().length < 2 ? "0" + data : data;
    }
    
    function updateSelectedTime(minute, hour, format = control.format)
    {
        control.selectedMinute = minute
        control.selectedHour = formatHourToUTC(hour, format)        
        
        var newdate = new Date()
        
        newdate.setHours(control.selectedHour)
       newdate.setMinutes(control.selectedMinute) 
       
       control.selectedTime = newdate
       
        console.log("UPDATING TIMEW", control.selectedTime.getHours(), control.selectedTime.getMinutes(), hour, minute, format, control.selectedTime.toLocaleTimeString())
    }   
    
}
