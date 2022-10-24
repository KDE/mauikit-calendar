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



    popupContent: SwipeView
    {
        implicitHeight: 300

        Pane
        {
            id: _yearPane

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
                            }
                        }
                    }
                }
            }
        }

        Pane
        {
            id: _monthPage

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

                    }
                }
            }
        }

        Pane
        {
            id: _daysPane

            contentItem: Kalendar.Month
            {
                month: control.selectedMonth+1
                year: control.selectedYear
            }
        }
    }

}
