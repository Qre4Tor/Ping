import VPlay 2.0
import QtQuick 2.0
import "objects"

GameWindow {
    id: gameWindow
    activeScene: playfield
    screenWidth: 640
    screenHeight: 960
    displayFpsEnabled: true

    EntityManager { //manages the objects that interact in the game
        id: entityManager
        entityContainer: playfield
    }

    Scene { //Playing field
        id: playfield
        width: 320
        height: 480
        property int points: 0
        property int max: 0
        anchors.fill: gameWindowAnchorItem

        property int wallHeight: gameWindowAnchorItem.height
        property int wallWidth: gameWindowAnchorItem.width

        Rectangle {
            //anchors.fill: playfield
            width: playfield.width
            height: playfield.height
            color: "#FFFFFF"
            z: 0
        }

        Text {
            id: textPoints
            text: "Balls: " + playfield.points
            color: "#000000"
            x: playfield.x + 20
            y: playfield.y + 20
        }

        Text {
            id: textMax
            text: "Record: " + playfield.max
            color: "#000000"
            x: playfield.width - width - 20
            y: playfield.y + 20
        }


        Rectangle {
            id: buttonStart
            width: playfield.width-20
            height: textStart.height + 10
            //color: "#DDDDDD"
            color: mouseArea.containsMouse ? "#666666" : "#DDDDDD"
            anchors.centerIn: playfield
            z: 1

            Text {
                id: textStart
                text: "Start the game"
                color: "#000000"
                anchors.centerIn: parent
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                onClicked: {
                    buttonStart.visible = false;
                    //ball.reStart();

                    var newEntites = {
                        x: playfield.width/2,
                        y: playfield.height/2,
                        autoCreated: true
                    }

                    entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("objects/Ball.qml"), newEntites);
                    timer.restart()
                }
            }
        }// Start button

        Rectangle {
            width: parent.width
            height: 70
            anchors.bottom: parent.bottom
            color: "#DDDDDD"
            z: 0
        }

        //is being created in the buttonClicked
        /*Ball {
            id: ball
            x: parent.width/2
            y: parent.height/2
        }*/

        Player {
            id: player
            x: parent.width/2
            y: parent.height-20

            onCollidedWithBall: {
                //playfield.points++
            }
        }

        Wall {
            id: wallTop
            width: playfield.width
            height: 10
            anchors {
                top: playfield.top
                left: playfield.left
            }
        }

        Wall {
            id: wallBottom
            width: playfield.width
            height: 10
            anchors {
                bottom: playfield.bottom
                left: playfield.left
            }
            color: "red"

            onCollidedWithBall: {
                //A ball (or the player) has entered the Red Zone
                entityManager.removeEntitiesByFilter(["ball"]);
                if (playfield.points > playfield.max)
                    playfield.max = playfield.points
                playfield.points = 0;
                timer.stop()
                buttonStart.visible = true;
            }
        }

        Wall {
            id: wallLeft
            width: 10
            height: playfield.height
            anchors {
                left: playfield.left
                top: playfield.top
            }
        }

        Wall {
            id: wallRight
            width: 10
            height: playfield.height
            anchors {
                right: playfield.right
                top: playfield.top
            }
        }


        PhysicsWorld {
            //needed to bounce the ball within walls and player
            id:physicsWorld
            updatesPerSecondForPhysics: 60
            velocityIterations: 5
            positionIterations: 5
            //debugDrawVisible: true
        }

        Component {
              id: mouseJoint
              Item {
                id: jointItem

                // make important joint properties accessible
                property alias bodyB: joint.bodyB
                property alias target: joint.target

                // set up the mouse joint
                MouseJoint {
                  id: joint
                  // make this high enough so the box with its density is moved quickly
                  maxForce: 30000 * physicsWorld.pixelsPerMeter
                  // The damping ratio. 0 = no damping, 1 = critical damping. Default is 0.7
                  dampingRatio: 1
                  // The response speed, default is 5
                  frequencyHz: 2
                }

                // also destroy joint if a box is destroyed
                Connections {
                  // joint.bodyB.target is the box entity connected with the joint
                  target: joint.bodyB !== null ? joint.bodyB.target : null
                  onEntityDestroyed: { joint.bodyB = null; jointItem.destroy() }
                }
            }
        }

        // when the user presses a box, move it towards the touch position
        MouseArea {
           anchors.fill: parent

           property Body selectedBody: null
           property Item mouseJointWhileDragging: null

           onPressed: {

              selectedBody = physicsWorld.bodyAt(Qt.point(mouseX, mouseY));
              console.debug("selected body at position", mouseX, mouseY, ":", selectedBody);
              // if the user selected a body, this if-check is true
              if(selectedBody) {
                // create a new mouseJoint
                var properties = {
                  // set the target position to the current touch position (initial position)
                  target: Qt.point(mouseX, mouseY),
                  // body B is the one that actually moves -> connect the joint with the body
                  bodyB: selectedBody
                }
                mouseJointWhileDragging = mouseJoint.createObject(physicsWorld, properties)
              }
            }

            onPositionChanged: {
              // this check is necessary, because the user might also drag when no initial body was selected
              if (mouseJointWhileDragging)
                mouseJointWhileDragging.target = Qt.point(Math.min(Math.max(mouseX,65),playfield.width-65), Math.min(Math.max(mouseY, parent.height-63), parent.height-22))
            }
            onReleased: {
              // if the user pressed a body initially, remove the created MouseJoint
              if(selectedBody) {
                selectedBody = null
                if (mouseJointWhileDragging)
                  mouseJointWhileDragging.destroy()
              }
           }
        }

        Timer {
               id: timer
               interval: 5000
               running: false
               repeat: true

               onTriggered: {
                   var newEntites = {
                       x: parent.width/2,
                       y: parent.height/2,
                       autoCreated: true
                   }

                   entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("objects/Ball.qml"), newEntites);
                   playfield.points++;
                   timer.restart();
             }
        }
    }//Scene
}
