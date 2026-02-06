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

    // 刷新串口按钮 - 位于页面右上角
    EButton {
        id: refreshSerialButton
        text: "刷新串口"
        iconCharacter: "\uf021"           // Font Awesome 刷新图标
        iconRotateOnClick: true            // 点击时图标旋转
        size: "s"                          // 小号尺寸
        containerColor: theme.secondaryColor // 背景颜色（自适应深色模式）
        textColor: theme.textColor         // 文字颜色（自适应深色模式）
        iconColor: theme.textColor         // 图标颜色（自适应深色模式）
        shadowEnabled: true                // 启用阴影效果
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: 16                // 与边缘之间的间距
        onClicked: {
            console.log("刷新串口")
        }
    }

    // 串口选择下拉框
    EDropdown {
        id: serialPortDropdown
        title: "选择串口"                   // 默认提示文字
        width: 140                          // 宽度
        headerHeight: 40                    // 头部高度（与按钮一致）
        radius: 20                          // 圆角半径
        containerColor: theme.secondaryColor // 背景颜色
        textColor: theme.textColor          // 文字颜色
        shadowEnabled: true                 // 启用阴影效果
        model: [
            { text: "COM1" },
            { text: "COM2" },
            { text: "COM3" },
            { text: "COM4" }
        ]
        anchors.top: refreshSerialButton.bottom
        anchors.topMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 16
        onSelectionChanged: {
            console.log("选择串口:", index, item.text)
        }
    }

    // 串口开关
    ESwitchButton {
        id: serialPortSwitch
        text: "串口开关"
        size: "s"                          // 小号尺寸
        containerColor: theme.secondaryColor // 背景颜色
        textColor: theme.textColor          // 文字颜色
        thumbColor: "#FFFFFF"               // 滑块颜色（白色）
        trackUncheckedColor: theme.isDark ? "#555555" : "#CCCCCC"  // 轨道未选中颜色
        trackCheckedColor: theme.isDark ? "#66BB6A" : "#4CAF50"    // 轨道选中颜色（绿色）
        shadowEnabled: true                 // 启用阴影效果
        anchors.top: serialPortDropdown.bottom
        anchors.topMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 16
        onToggled: {
            console.log("串口开关状态:", checked ? "开启" : "关闭")
        }
    }

    EAnimatedWindow {
        id: animationWrapper
    }
}
