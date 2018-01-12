import VPlay 2.0
import QtQuick 2.0

GameWindow {
    id: gameWindow
    activeScene: playfield
    screenWidth: 640
    screenHeight: 960

    Scene {
        id: playfield
        width: 320
        height: 480

        Rectangle {
            id: buttonStart
            width: textStart.width + 10
            height: textStart.height + 10
            color: "#DDDDDD"
            anchors.centerIn: parent
            Text {
                id: textStart
                text: "Start the game"
                color: "#000000"
                anchors.centerIn: parent
            }

            MouseArea {
                anchors.fill: buttonStart

                // when the rectangle that fits the whole scene is pressed, change the background color and the text
                onClicked: {
                    buttonStart.visible = false;
                    //console.debug("Clicked Button")
                }
            }
        }// Start button

        EntityBase {
            entityType: "Border"

            BoxCollider {
                 width: gameScene.width * 5 // use large width to make sure the frog can't fly past it
                 height: 50
                 bodyType: Body.Static // this body shall not move

                 collisionTestingOnlyMode: true

                 // a Rectangle to visualize the border
                 Rectangle {
                   anchors.fill: parent
                   color: "red"
                   visible: false // set to false to hide
                 }
        }

        Image {
            id: vplayLogo
            source: "../assets/vplay-logo.png"


            // 50px is the "logical size" of the image, based on the scene size 480x320
            // on hd or hd2 displays, it will be shown at 100px (hd) or 200px (hd2)
            // thus this image should be at least 200px big to look crisp on all resolutions
            // for more details, see here: https://v-play.net/doc/vplay-different-screen-sizes/
            width: 50
            height: 50

            // this positions it absolute right and top of the GameWindow
            // change resolutions with Ctrl (or Cmd on Mac) + the number keys 1-8 to see the effect
            anchors.right: playfield.gameWindowAnchorItem.right
            anchors.top: playfield.gameWindowAnchorItem.top

            // this animation sequence fades the V-Play logo in and out infinitely (by modifying its opacity property)
            SequentialAnimation on opacity {
                loops: Animation.Infinite
                PropertyAnimation {
                    to: 0
                    duration: 1000 // 1 second for fade out
                }
                PropertyAnimation {
                    to: 1
                    duration: 1000 // 1 second for fade in
                }
            }
        }

    }
}
