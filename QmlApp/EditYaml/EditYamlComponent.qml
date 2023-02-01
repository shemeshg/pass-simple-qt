import QtQuick
import EditYaml

Text {
    EditYamlType {
        id: editYamlType
    }

    text: editYamlType.getYamlFields()
}
