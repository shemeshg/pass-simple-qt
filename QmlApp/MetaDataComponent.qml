import QtQuick
import QmlApp
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Dialogs

import DropdownWithList

ColumnLayout {
    property alias nearestGitId: nearestGitId
    property alias getDecryptedSignedById: getDecryptedSignedById
    property alias waitItemsId: waitItemsId
    property alias noneWaitItemsId: noneWaitItemsId

    Text {
        text: "<h1>Meta data<h1>"
    }

    Text {
        id: nameId
        text:"File : " + filePath
    }
    Text {
        id: nearestGitId
        text:"Git : "
    }
    Text {
        id: nearestGpgIdId
        text:"GpgId : " + nearestGpg
    }
    Text {
        id: getDecryptedSignedById
        text:"DecryptedSignedBy : "
    }
    Text {
        id: waitItemsId
        text:"waitItems" + JSON.stringify(waitItems)
    }
    Text {
        id: noneWaitItemsId
        text:"noneWaitItems" + JSON.stringify(noneWaitItems)
    }
}
