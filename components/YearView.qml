// Components/YearView.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "."
import "Sizing.js" as S

Item {
    id: root
    signal dayActivated(string iso)

    property int year: 2025
    property int viewportWidth: width
    property var metricsByDate: ({})

    readonly property int columns:  S.columns(viewportWidth)
    readonly property int outerGap: S.sideMargin(viewportWidth)

    readonly property int hGap: S.monthWidthGap(viewportWidth)
    readonly property int vGap: S.monthHeightGap(viewportWidth)

    readonly property int tileWidth: Math.floor((width - outerGap*2 - hGap*(columns - 1)) / columns)
    readonly property int gridWidth: (columns * tileWidth) + ((columns - 1) * hGap)

    ScrollView {
        id: scroller
        anchors.fill: parent
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        contentWidth:  Math.max(width, grid.implicitWidth  + outerGap*2)
        contentHeight:  grid.implicitHeight + outerGap*2
        Item {
            id: contentRoot
            width:  scroller.contentWidth
            height: scroller.contentHeight

            Grid {
                id: grid
                width: root.gridWidth
                anchors.top: parent.top
                anchors.topMargin: root.outerGap
                anchors.horizontalCenter: parent.horizontalCenter

                columns: root.columns
                rowSpacing: root.vGap
                columnSpacing: root.hGap

                Repeater {
                    model: 12

                    delegate: Item {
                        id: tile

                        // ширина «слота» из Grid
                        width:  root.tileWidth
                        height: monthTile.implicitHeight

                        MonthGrid {
                            id: monthTile

                            year:  root.year
                            month: index + 1
                            metricsByDate: root.metricsByDate

                            viewportWidth: root.viewportWidth
                            mondayFirst: true

                            onDayActivated: (iso) => root.dayActivated(iso)
                        }
                        Layout.preferredHeight: monthTile.implicitHeight
                    }
                }
            }
        }
    }
}
