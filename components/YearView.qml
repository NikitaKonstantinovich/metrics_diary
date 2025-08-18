import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import "."
import "Sizing.js" as S

Item {
    id: root
    property int year: 2025
    property int viewportWidth: width
    property var metricsByDate: ({})

    readonly property int columns: S.columns(viewportWidth)
    readonly property int outerGap: S.sideMargin(viewportWidth)

    readonly property int vGap: S.monthWidthGap(viewportWidth)
    readonly property int hGap: S.monthHeightGap(viewportWidth)

    readonly property int tileWidth: (width - outerGap*2 - vGap*(columns - 1)) / columns

    ScrollView {
        id: scroller
        anchors.fill: parent
        clip: true
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        GridLayout {
            id: grid
            x: root.outerGap
            y: root.outerGap
            width: scroller.width - root.outerGap*2
            columns: root.columns
            rowSpacing: root.hGap
            columnSpacing: root.vGap

            Repeater {
                model: 12

                delegate: Item {
                    id: tile

                    // ширина «слота» из GridLayout
                    Layout.preferredWidth:  root.tileWidth
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                    MonthGrid {
                        id: monthTile

                        year:  root.year
                        month: index + 1
                         metricsByDate: root.metricsByDate

                        viewportWidth: root.viewportWidth
                        mondayFirst: true

                        onDayActivated: (iso) => {
                            console.log("clicked:", iso)
                        }

                        width:  parent ? parent.width : root.tileWidth
                    }
                    Layout.preferredHeight: monthTile.implicitHeight
                }
            }
        }
    }
}
