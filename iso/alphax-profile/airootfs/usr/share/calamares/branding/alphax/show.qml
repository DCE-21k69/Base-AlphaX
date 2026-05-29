import QtQuick 2.0
import calamares.slideshow 1.0

Presentation {
    id: presentation

    Slide {
        anchors.fill: parent
        Rectangle {
            anchors.fill: parent
            color: "#1a1b26"
        }
        Column {
            anchors.centerIn: parent
            spacing: 24
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "AlphaX Linux"
                color: "#7aa2f7"
                font.pixelSize: 48
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Gaming · Arch · Wayland"
                color: "#bb9af7"
                font.pixelSize: 20
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Instalando tu sistema..."
                color: "#565f89"
                font.pixelSize: 16
            }
        }
    }

    Slide {
        anchors.fill: parent
        Rectangle { anchors.fill: parent; color: "#1a1b26" }
        Column {
            anchors.centerIn: parent
            spacing: 20
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Codex WM"
                color: "#bb9af7"
                font.pixelSize: 36
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Window Manager Wayland propio de AlphaX\nTiling y Mosaico · Barra superior · Workspaces"
                color: "#c0caf5"
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Slide {
        anchors.fill: parent
        Rectangle { anchors.fill: parent; color: "#1a1b26" }
        Column {
            anchors.centerIn: parent
            spacing: 20
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Gaming Ready"
                color: "#9ece6a"
                font.pixelSize: 36
                font.bold: true
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Steam · Lutris · Wine · GameMode · MangoHud\nTodo listo desde el primer arranque"
                color: "#c0caf5"
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Timer {
        interval: 5000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }
}
