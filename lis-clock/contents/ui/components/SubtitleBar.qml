import QtQuick
import QtQuick.Effects

Item {
    id: subtitleRoot
    
    property string subtitleText: "This action will have consequences..."
    property color subtitleColor: "#dff2ff"
    property color neonColor: "#00aaff"
    property int glowStrength: 16
    property int floatDuration: 2800
    property int flickerInterval: 5000
    property string fontName: ""
    property bool isVisible: true
    property bool lowPowerMode: false
    
    visible: isVisible
    
    implicitWidth: subtitleRow.width
    implicitHeight: subtitleRow.height
    
    Row {
        id: subtitleRow
        anchors.centerIn: parent
        spacing: 16
        
        Item {
            id: b3Container
            width: 22; height: 22
            anchors.verticalCenter: parent.verticalCenter
            
            Image {
                id: butterfly3
                source: "../../assets/darkroombutterfly3.png"
                width: 22; height: 22
                sourceSize.width: 22
                sourceSize.height: 22
                cache: true
                asynchronous: true
                x: 0; y: 0
            }
            
            // Periodic burst animation instead of infinite loop
            ParallelAnimation {
                id: b3BurstAnim
                SequentialAnimation {
                    YAnimator { target: butterfly3; from: 0; to: -6; duration: 300; easing.type: Easing.InOutSine }
                    YAnimator { target: butterfly3; from: -6; to: 0; duration: 400; easing.type: Easing.InOutSine }
                }
                SequentialAnimation {
                    OpacityAnimator { target: butterfly3; to: 0.3; duration: 100 }
                    OpacityAnimator { target: butterfly3; to: 1.0; duration: 200 }
                }
            }
            
            Timer {
                id: b3BurstTimer
                interval: Math.max(2000, subtitleRoot.flickerInterval)
                repeat: true
                running: !subtitleRoot.lowPowerMode
                onTriggered: b3BurstAnim.restart()
            }
        }
        
        Text {
            id: subText
            text: subtitleRoot.subtitleText
            font.family: subtitleRoot.fontName
            font.pixelSize: 16
            color: subtitleRoot.subtitleColor
            opacity: 0.85
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    
    MultiEffect {
        source: subtitleRow; anchors.fill: subtitleRow
        shadowEnabled: true; shadowColor: subtitleRoot.neonColor
        shadowBlur: Math.min(1.0, subtitleRoot.glowStrength / 25.0)
        blurMax: 32
        autoPaddingEnabled: true
    }
    
    function restartFloat() {
        if (!subtitleRoot.lowPowerMode) b3BurstAnim.restart()
    }
    
    function restartFlickerTimer() {
        if (!subtitleRoot.lowPowerMode) b3BurstTimer.restart()
    }
    
    onLowPowerModeChanged: {
        if (lowPowerMode) {
            b3BurstTimer.stop()
            b3BurstAnim.stop()
            butterfly3.y = 0
            butterfly3.opacity = 1.0
        } else {
            b3BurstTimer.start()
        }
    }
    
    Component.onCompleted: {
        if (!lowPowerMode) {
            b3BurstTimer.start()
        }
    }
}
