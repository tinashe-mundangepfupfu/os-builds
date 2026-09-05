import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import org.kde.kirigami 2.7 as Kirigami

Rectangle {
    color: Kirigami.Theme.backgroundColor
    
    Text {
        text: "Oponn"
        font.pixelSize: 48
        font.bold: true
        anchors.centerIn: parent
        color: Kirigami.Theme.textColor
    }
}
