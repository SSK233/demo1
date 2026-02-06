import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import EvolveUI

Page {
    id: window
    property alias animatedWindow: animationWrapper
    background: Rectangle {
        color: "transparent"
    }

    EAnimatedWindow {
        id: animationWrapper
    }
}
