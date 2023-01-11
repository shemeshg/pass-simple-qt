import QtQuick
import QtQuick.Controls
import QtQuick.Layouts



    ColumnLayout {


        id: mainLayout
        anchors.fill: parent


        Text {
            id: filepansizeId
            text:"FilePanSize : " + mainqmltype.filePanSize


        }

            Text {
                id: nameId
                text:"File : " + mainqmltype.filePath


            }


        GroupBox {
            id: rowBox
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            title: "File selected"
            Layout.fillWidth: true



            RowLayout {

                id: rowLayout
                anchors.fill: parent






                TextField {
                    placeholderText: qsTr("Enter name")
                    Layout.fillWidth: true
                }

                Button {
                    text: "Hide/Show treeview"
                    onClicked: { mainqmltype.toggleFilepan();}
                }
            }

        }

    }

