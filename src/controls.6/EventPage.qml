import QtQuick
import QtQml
import QtQuick.Controls 
import QtQuick.Layouts 
import org.mauikit.controls as Maui
import org.mauikit.calendar as Cal

/**
 * @inherit QtQuick.Controls.Pane
 * @brief A view field for creating a new calendar event.
 *
 * @image html eventpage.png
 *
 * @code
 *
 * @endcode
 */
Pane
{
    id: control
    
    implicitHeight: _layout.implicitHeight + topPadding + bottomPadding
    
    padding: 0
    background: null
    
    /**
     * @brief
     */
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
    
    contentItem: Maui.ScrollColumn
    {
        id: _layout
        
        Maui.SectionGroup
        {
            title: i18n("Info")
            
            Maui.SectionItem
            {
                label1.text: i18n("Description")
                
                TextField
                {
                    Layout.fillWidth: true
                    height: 80
                    text: incidenceWrapper.summary
                    placeholderText: i18n(`Add a title for your ${incidenceWrapper.incidenceTypeStr.toLowerCase()}`)
                    onTextChanged: incidenceWrapper.summary = text
                    
                    onAccepted : incidenceWrapper.summary = text
                }
            }
            
            Maui.SectionItem
            {
                label1.text: i18n("Calendar")
                
                ComboBox
                {
                    id: calendarCombo
                    Layout.fillWidth: true
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
        
        
        Maui.SectionGroup
        {
            title: i18n("Time")
            
            Maui.FlexSectionItem
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
            
            Maui.SectionItem
            {
                label1.text: i18n("Start")
                
                Cal.DateComboBox
                {
                    id: incidenceStartDateCombo
                    Layout.fillWidth: true
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
                    Layout.fillWidth: true
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
            
            Maui.SectionItem
            {
                label1.text: i18n("End")
                
                Cal.DateComboBox
                {
                    id: incidenceEndDateCombo
                    Layout.fillWidth: true
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
                    Layout.fillWidth: true
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
            
            Maui.SectionItem
            {
                label1.text: i18n("TimeZone")
                
                ComboBox
                {
                    Layout.fillWidth: true
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
