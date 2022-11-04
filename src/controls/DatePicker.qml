import QtQuick 2.4
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.15

import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Kalendar


Page
{
    id:  control

    readonly property date startDate : new Date()

    property int selectedMonth : selectedDate.getUTCMonth()
    property int selectedYear: selectedDate.getUTCFullYear()
    property int selectedDay : selectedDate.getDate()

    property date selectedDate : startDate
    
    signal accepted(var date)
    
    header: ToolBar
    {
        width: parent.width
        background: null
        
        contentItem: RowLayout
        {
            spacing: 0
            
//             Maui.ToolActions
//             {
//                 autoExclusive: false
//                 
//             Action
//             {
//                 icon.name: "go-previous"
//                 onTriggered: 
//                 {
//                     control.updateSelectedDate(control.selectedDay, Math.max(control.selectedMonth-1, 0), control.selectedYear)
//                     _swipeView.currentIndex = 0
//                 }
//             }
            
            // Action
            // {
            //     icon.name: "go-next"
            //     onTriggered: 
            //     {
            //         control.updateSelectedDate(control.selectedDay, Math.min(control.selectedMonth+1, 11), control.selectedYear)
            //         _swipeView.currentIndex = 0
            //     }
            // }
            // }
            
            // Item {Layout.fillWidth: true}
            
            Maui.ToolActions
            {
                id: _dateGroup
                autoExclusive: true
                currentIndex: _stackView.currentIndex
                
            Action
            {
                text: control.selectedDay
                // onTriggered: _swipeView.currentIndex = 0
            }
            
            Action
            {
                text: Qt.locale().standaloneMonthName(control.selectedMonth) 
                // onTriggered: _swipeView.currentIndex = 1
            }
            
            Action
            {
                text: control.selectedYear
                // onTriggered: _swipeView.currentIndex = 2
            }
            }
            Item {Layout.fillWidth: true}
            
           Button
           {
               text: i18n("Done")
               onClicked: control.accepted(control.selectedDate)
        }
        }
    }    
    
    contentItem: SwipeView
    {
        id: _swipeView
        background: null
        currentIndex: _dateGroup.currentIndex 
        Kalendar.DaysGrid
        {
            id: _daysPane
            month: control.selectedMonth+1
            year: control.selectedYear
            
            onDateClicked: 
            {
                control.updateSelectedDate(date.getDate(), control.selectedMonth, control.selectedYear)               
            }            
        }
        
        
        Kalendar.MonthsGrid
        {
            id: _monthPage
            selectedMonth: control.selectedMonth
            onMonthSelected: control.updateSelectedDate(control.selectedDay, month, control.selectedYear)            
        }
        
        Kalendar.YearsGrid
        {
            id: _yearPane
           selectedYear: control.selectedYear           
           onYearSelected: control.updateSelectedDate(control.selectedDay, control.selectedMonth, year)
        }
    }
    
    function updateSelectedDate(day, month, year)
    {
        control.selectedDay = day
        control.selectedMonth = month
        control.selectedYear = year
        
        console.log("CREATING A NEW DATE WITH", day, month, year)
        control.selectedDate = new Date(year, month, day)
        _swipeView.setCurrentIndex(0)
    }
    

}
