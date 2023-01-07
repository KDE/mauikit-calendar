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

property alias incidence : incidenceWrapper

Cal.IncidenceWrapper
{
    id: incidenceWrapper
    
    onIncidenceStartChanged:
    {
        incidenceStartDateCombo.selectedDate = control.incidence.incidenceStart;
        incidenceStartTimeCombo.selectedTime = incidenceWrapper.incidenceStart;
        incidenceStartDateCombo.displayText = incidenceWrapper.incidenceStartDateDisplay;
        incidenceStartTimeCombo.displayText = incidenceWrapper.incidenceStartTimeDisplay;
    }
    
    onIncidenceEndChanged:
    {
        incidenceEndDateCombo.selectedDate = control.incidence.incidenceEnd;
        incidenceEndTimeCombo.selectedTime = incidenceWrapper.incidenceEnd;
        incidenceEndDateCombo.displayText = incidenceWrapper.incidenceEndDateDisplay;
        incidenceEndTimeCombo.displayText = incidenceWrapper.incidenceEndTimeDisplay;
    }
}


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
            text: incidenceWrapper.summary
                    placeholderText: i18n(`Add a title for your ${incidenceWrapper.incidenceTypeStr.toLowerCase()}`)
                    onTextChanged: incidenceWrapper.summary = text
                    
                    onAccepted : incidenceWrapper.summary = text
        }
    }

    Maui.SettingTemplate
    {
        label1.text: i18n("Calendar")
        
        ComboBox 
        {
            id: calendarCombo
            width: parent.parent.width
            textRole: "display"
            valueRole: "collectionColor"
            
            model: Cal.CollectionComboBoxModel 
            {
                id: collectionComboBoxModel
                onCurrentIndexChanged: calendarCombo.currentIndex = currentIndex
                defaultCollectionId: incidenceWrapper.collectionId;
                
                
                mimeTypeFilter: if (incidenceWrapper.incidenceType === Cal.IncidenceWrapper.TypeEvent) 
                {
                    return [Cal.MimeTypes.calendar]
                } else if (incidenceWrapper.incidenceType === Cal.IncidenceWrapper.TypeTodo) {
                    return [Cal.MimeTypes.todo]
                }
                accessRightsFilter: Cal.Collection.CanCreateItem
                
                
            }
            
            currentIndex: 0
            onCurrentIndexChanged: if (currentIndex !== -1) {
                const collection = model.data(model.index(currentIndex, 0), Cal.Collection.CollectionRole);
                if (collection) {
                    incidenceWrapper.setCollection(collection)
                }
            }
          
        }
    }
}


Maui.SettingsSection
{
    title: i18n("Time")

    Maui.SettingTemplate
    {
        label1.text: i18n("All day")
        enabled: !isNaN(incidenceWrapper.incidenceStart.getTime()) || !isNaN(incidenceWrapper.incidenceEnd.getTime())
        Switch
        {
            id: allDayCheckBox
            checked: incidenceWrapper.allDay
            onToggled: 
            {
                if (!checked)
                {
                    incidenceWrapper.setIncidenceTimeToNearestQuarterHour();
                }
                incidenceWrapper.allDay = checked;
            }
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
               id: incidenceStartDateCombo  
width: parent.width
displayText: incidenceWrapper.incidenceStartDateDisplay
selectedDate: incidenceWrapper.incidenceStart
onDatePicked: 
{
    console.log("DATE PCIKED", date.getDate(), date.getMonth(), date.getYear())
    incidenceWrapper.setIncidenceStartDate(date.getDate(), date.getMonth(), date.getYear())
}

           }

           Cal.TimeComboBox
           {
               id: incidenceStartTimeCombo
width: parent.width
visible: !allDayCheckBox.checked

timeZoneOffset: incidenceWrapper.startTimeZoneUTCOffsetMins
displayText: incidenceWrapper.incidenceEndTimeDisplay
selectedTime: incidenceWrapper.incidenceStart
onTimePicked:
{
    console.log("TIME PICKER", time.getHours(), time.getMinutes())
     incidenceWrapper.setIncidenceStartTime(time.getHours(), time.getMinutes())
}
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
            
            Cal.DateComboBox
            {
                id: incidenceEndDateCombo  
                width: parent.width
                displayText: incidenceWrapper.incidenceStartDateDisplay
                selectedDate: incidenceWrapper.incidenceStart
                onDatePicked: 
                {
                    incidenceWrapper.setIncidenceEndDate(date.getDate(), date.getMonth(), date.getYear())
                }
                
            }
            
            Cal.TimeComboBox
            {
                id: incidenceEndTimeCombo
                width: parent.width
                visible: !allDayCheckBox.checked
                timeZoneOffset: incidenceWrapper.endTimeZoneUTCOffsetMins
                displayText: incidenceWrapper.incidenceEndTimeDisplay
                selectedTime: incidenceWrapper.incidenceEnd
                onTimePicked: 
                {
                    incidenceWrapper.setIncidenceEndTime(hours, minutes)
                }
            }
            
        }
    }

    Maui.SettingTemplate
    {
        label1.text: i18n("TimeZone")

        ComboBox
        {
            width: parent.parent.width
            model: Cal.TimeZoneListModel
            {
                        id: timeZonesModel
            }
            
              textRole: "display"
                    valueRole: "id"
                    currentIndex: model ? timeZonesModel.getTimeZoneRow(incidenceWrapper.timeZone) : -1
                    
                            onActivated: incidenceWrapper.timeZone =  currentValue
        }
    }
}
}

}
