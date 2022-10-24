import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Kalendar


ComboBox
{
    id:  control
    enabled: true

    readonly property date startDate : new Date()

    property int selectedMonth : startDate.getUTCMonth()
    property int selectedYear: startDate.getUTCFullYear()
    property int selectedDay : startDate.getUTCDay()

    property date selectedDate : startDate

    displayText: selectedDate.toLocaleDateString()
    font.bold: true
    font.weight: Font.Bold
    font.family: "Monospace"



    popupContent: Page
    {
        id: _popup
        implicitHeight: 300
        background: null
        header: ToolBar
        {
            width: parent.width
            
            Button
            {
                text: Qt.locale().standaloneMonthName(control.selectedMonth) 
                onClicked: _swipeView.currentIndex = 1
            }
            
            Button
            {
                text: control.selectedYear
                onClicked: _swipeView.currentIndex = 2
                
            }
        }
        
        contentItem: SwipeView
    {
        id: _swipeView
         background: null
         
         Kalendar.Month
            {
                id: _daysPane
                month: control.selectedMonth+1
                year: control.selectedYear
                
                onDateClicked: 
                {
                    console.log("day clicked:", date, date.getDay(), Qt.formatDateTime(date, "dd,MM,yyyy"))
                    control.updateSelectedDate(date.getDay(), control.selectedMonth, control.selectedYear)
                    control.accepted()
                    control.popup.close()
                }
                
            }
        
        
        Pane
        {
            id: _monthPage
             background: null
            contentItem: GridLayout
            {
                id: monthsGrid
                columns: 3
                ButtonGroup {
                    buttons: monthsGrid.children
                }
                
                
                Repeater
                {
                    model: 12
                    
                    
                    delegate: Button
                    {
                        Layout.fillWidth: true
                        text: Qt.locale().standaloneMonthName(index)
                        
                        checkable: true
                        checked: control.selectedMonth === index
                        
                        onClicked: control.updateSelectedDate(control.selectedDay, index, control.selectedYear)
                    }
                }
            }
        }
        Pane
        {
            id: _yearPane
            background: null
            contentItem: ScrollView
            {
                Flickable
                {
                    contentHeight: _yearsGrid.implicitHeight
                    contentWidth: availableWidth

                    GridLayout
                    {
                        anchors.fill: parent
                        id: _yearsGrid
                        columns: 3
                        ButtonGroup {
                            buttons: _yearsGrid.children
                        }

                        Repeater
                        {
                            model: 40
                            delegate: Button
                            {
                                property int year :  1999 + modelData
                                Layout.fillWidth: true
                                text: year
                                checkable: true
                                checked: year === control.selectedYear
                                onClicked: control.updateSelectedDate(control.selectedDay, control.selectedMonth, year)
                                                                
                            }
                        }
                    }
                }
            }
        }

       
    }
       
    }
    
    function updateSelectedDate(day, month, year)
    {
        control.selectedDay = day
        control.selectedMonth = month
        control.selectedYear = year
        
        console.log("CREATING A NEW DATE WITH", day, month, year)
        control.selectedDate = new Date(year, month, day)
        _swipeView.currentIndex = 0
    }

}
