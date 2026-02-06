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
        z: -1                               // 确保下拉框展开时不会被遮挡
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

    // 风机开关
    ESwitchButton {
        id: fanSwitch
        text: "风机开关"
        size: "s"                          // 小号尺寸
        containerColor: theme.secondaryColor // 背景颜色
        textColor: theme.textColor          // 文字颜色
        thumbColor: "#FFFFFF"               // 滑块颜色（白色）
        trackUncheckedColor: theme.isDark ? "#555555" : "#CCCCCC"  // 轨道未选中颜色
        trackCheckedColor: theme.isDark ? "#66BB6A" : "#4CAF50"    // 轨道选中颜色（绿色）
        shadowEnabled: true                 // 启用阴影效果
        anchors.top: serialPortSwitch.bottom
        anchors.topMargin: 8
        anchors.right: parent.right
        anchors.rightMargin: 16
        onToggled: {
            console.log("风机开关状态:", checked ? "开启" : "关闭")
        }
    }

    // 电气参数卡片 - 显示电压、电流、功率
    EHoverCard {
        id: electricCard
        width: 120                              // 卡片宽度
        height: 250                             // 卡片高度
        anchors.bottom: parent.bottom           // 底部对齐
        anchors.bottomMargin: 16                // 底部边距
        anchors.right: parent.right             // 右侧对齐
        anchors.rightMargin: 16                 // 右边距

        // === 内容布局：垂直排列三个参数 ===
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // --- 电压参数组 ---
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 4

                Text {
                    text: "电压"
                    color: theme.textColor
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Text {
                    text: "220.0 V"
                    color: theme.textColor
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }

            // --- 分隔线 ---
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.textColor
                opacity: 0.3
            }

            // --- 电流参数组 ---
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 4

                Text {
                    text: "电流"
                    color: theme.textColor
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Text {
                    text: "2.5 A"
                    color: theme.textColor
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }

            // --- 分隔线 ---
            Rectangle {
                Layout.fillWidth: true
                height: 1
                color: theme.textColor
                opacity: 0.3
            }

            // --- 功率参数组 ---
            ColumnLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 4

                Text {
                    text: "功率"
                    color: theme.textColor
                    font.pixelSize: 14
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
                Text {
                    text: "0.55 kW"
                    color: theme.textColor
                    font.pixelSize: 16
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }
            }
        }
    }

    property int selectedValue: 0

    function getButtonColor(bitMask) {
        return (selectedValue & bitMask) ? theme.focusColor : theme.secondaryColor
    }

    Row {
        id: valueButtonsRow
        spacing: 12
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -80
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -90

        EButton {
            id: btn1
            text: "1"
            size: "m"
            width: 48
            height: 48
            radius: 24
            containerColor: getButtonColor(1)
            textColor: theme.textColor
            shadowEnabled: true
            onClicked: {
                selectedValue ^= 1
                centralSlider.value = selectedValue
            }
        }

        EButton {
            id: btn2
            text: "2"
            size: "m"
            width: 48
            height: 48
            radius: 24
            containerColor: getButtonColor(2)
            textColor: theme.textColor
            shadowEnabled: true
            onClicked: {
                selectedValue ^= 2
                centralSlider.value = selectedValue
            }
        }

        EButton {
            id: btn4
            text: "4"
            size: "m"
            width: 48
            height: 48
            radius: 24
            containerColor: getButtonColor(4)
            textColor: theme.textColor
            shadowEnabled: true
            onClicked: {
                selectedValue ^= 4
                centralSlider.value = selectedValue
            }
        }

        EButton {
            id: btn8
            text: "8"
            size: "m"
            width: 48
            height: 48
            radius: 24
            containerColor: getButtonColor(8)
            textColor: theme.textColor
            shadowEnabled: true
            onClicked: {
                selectedValue ^= 8
                centralSlider.value = selectedValue
            }
        }

        EButton {
            id: btn16
            text: "16"
            size: "m"
            width: 48
            height: 48
            radius: 24
            containerColor: getButtonColor(16)
            textColor: theme.textColor
            shadowEnabled: true
            onClicked: {
                selectedValue ^= 16
                centralSlider.value = selectedValue
            }
        }

        EButton {
            id: btn32
            text: "32"
            size: "m"
            width: 48
            height: 48
            radius: 24
            containerColor: getButtonColor(32)
            textColor: theme.textColor
            shadowEnabled: true
            onClicked: {
                selectedValue ^= 32
                centralSlider.value = selectedValue
            }
        }

        EButton {
            id: btn64
            text: "64"
            size: "m"
            width: 48
            height: 48
            radius: 24
            containerColor: getButtonColor(64)
            textColor: theme.textColor
            shadowEnabled: true
            onClicked: {
                selectedValue ^= 64
                centralSlider.value = selectedValue
            }
        }
    }

    // 中央滑块组件
    ESlider {
        id: centralSlider
        text: "输入电流I/A "
        width: 450
        minimumValue: 0
        maximumValue: 127
        decimals: 0
        stepSize: 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -80
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -30
        onUserValueChanged: {
            console.log("Slider value changed:", value)
        }
    }

    // 载入按钮
    EButton {
        id: loadButton
        text: "载入"
        iconCharacter: "\uf019"
        size: "s"
        containerColor: theme.secondaryColor
        textColor: theme.textColor
        iconColor: theme.textColor
        shadowEnabled: true
        anchors.top: centralSlider.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -140
        onClicked: {
            console.log("载入电流值:", centralSlider.value)
            selectedValue = centralSlider.value
        }
    }

    // 卸载按钮
    EButton {
        id: unloadButton
        text: "卸载"
        iconCharacter: "\uf1f8"
        size: "s"
        containerColor: theme.secondaryColor
        textColor: theme.textColor
        iconColor: theme.textColor
        shadowEnabled: true
        anchors.top: centralSlider.bottom
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -20
        onClicked: {
            console.log("卸载电流值")
        }
    }

    EAnimatedWindow {
        id: animationWrapper
    }
}
