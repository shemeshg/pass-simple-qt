import QtQuick
import QtQuick.Controls
import QtQuick.Layouts



    ColumnLayout {
        id: mainLayout
        anchors.fill: parent

        GroupBox {
            id: rowBox
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            title: "File selected"
            Layout.fillWidth: true



            RowLayout {

                id: rowLayout
                anchors.fill: parent

                //TextField {
                    //Layout.alignment: Qt.AlignLeft
                    //Layout.fillHeight: false
                    //placeholderText: "This wants to grow horizontally"
                    //Layout.fillWidth: true
                //}


                TextField {
                    placeholderText: qsTr("Enter name")
                    Layout.fillWidth: true
                }

                Button {
                    text: "Hide/Show treeview"
                }
            }

        }

    }

