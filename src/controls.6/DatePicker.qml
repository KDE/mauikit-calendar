import QtQuick
import QtQuick.Layouts
import QtQuick.Controls 

import org.mauikit.controls 1.3 as Maui
import org.mauikit.calendar 1.0 as Kalendar

/**
 * @inherit QtQuick.Controls.Page
 * @brief A control for quickly picking a date in the format of year, month and day number.
 * 
 * @image html datepicker.png
 * 
 * @code 
 * Maui.ApplicationWindow
 * {
 *    id: root
 *    
 *    Maui.Page
 *    {
 *        anchors.fill: parent
 *        Maui.Controls.showCSD: true
 *        title: root.title
 *        
 *        MC.DatePicker
 *        {
 *            id: _datePicker
 *            height: 300
 *            width: 300
 *            anchors.centerIn: parent
 *            
 *            onAccepted: (date) => root.title = date.toLocaleString()
 *        }
 *    }
 * }
 * @endcode
 */
Page
{
    id:  control
    
    /**
     * @brief
     */
    readonly property date startDate : new Date()
    
    /**
     * @brief
     */
    property int selectedMonth : selectedDate.getUTCMonth()
    
    /**
     * @brief
     */
    property int selectedYear: selectedDate.getUTCFullYear()
    
    /**
     * @brief
     */
    property int selectedDay : selectedDate.getDate()
    
    /**
     * @brief
     */
    property date selectedDate : startDate
    
    /**
     * @brief
     * 
     */
    signal accepted(var date)
    
    padding: 0
    
    header: Maui.ToolBar
    {
        width: parent.width
        
        background: null
        
        leftContent: Maui.ToolActions
        {
            autoExclusive: true
            
            Action
            {
                text: control.selectedDay
                checked: _swipeView.currentIndex === 0
                onTriggered: _swipeView.currentIndex = 0
            }
            
            Action
            {
                text: Qt.locale().standaloneMonthName(control.selectedMonth) 
                checked: _swipeView.currentIndex === 1
                onTriggered: _swipeView.currentIndex = 1
                
            }
            
            Action
            {
                text: control.selectedYear
                checked: _swipeView.currentIndex === 2
                onTriggered: _swipeView.currentIndex = 2                
            }
        }
        
        rightContent: Button
        {
            text: i18n("Done")
            onClicked: control.accepted(control.selectedDate)
        }        
    }    
    
    contentItem: SwipeView
    {
        id: _swipeView
        background: null
        clip: true
        
        Kalendar.DaysGrid
        {
            id: _daysPane
            month: control.selectedMonth+1
            year: control.selectedYear
            
            onDateClicked: (date) =>
            {
                control.updateSelectedDate(date.getDate(), control.selectedMonth, control.selectedYear)               
            }            
        }        
        
        Kalendar.MonthsGrid
        {
            id: _monthPage
            selectedMonth: control.selectedMonth
            onMonthSelected: (month) => control.updateSelectedDate(control.selectedDay, month, control.selectedYear)            
        }
        
        Kalendar.YearsGrid
        {
            id: _yearPane
            selectedYear: control.selectedYear           
            onYearSelected: (year) => control.updateSelectedDate(control.selectedDay, control.selectedMonth, year)
        }
    }
    
    /**
     * @brief
     */
    function updateSelectedDate(day, month, year)
    {
        control.selectedDay = day
        control.selectedMonth = month
        control.selectedYear = year
        
        console.log("CREATING A NEW DATE WITH", day, month, year)
        control.selectedDate = new Date(year, month, day)
        _swipeView.incrementCurrentIndex()
    } 
}
