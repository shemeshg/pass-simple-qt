import QtQuick
import EditYaml

Text {
    EditYamlType {
        id: editYamlType
    }

    text: JSON.stringify( editYamlType.getYamlFmodel() )
}
