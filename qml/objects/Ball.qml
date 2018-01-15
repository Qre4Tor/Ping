import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: ball
    entityType: "ball"
    property int speed: 300
    property bool autoCreated: false

    Rectangle {
      id: ballRect
      width: 10
      height: 10
      anchors.centerIn: parent
      color: "red"
    }


    CircleCollider {
        id: ballCollider
        radius: ballRect.width/2
        //width: ballRect.width
        //height: ballRect.height
        anchors.centerIn: parent


        fixture.friction: 0
        fixture.restitution: 1
        bullet: true
        body.fixedRotation: true

        fixture.onBeginContact: {
            //when on collsion
        }
    }

    // Set the ball to a random angle and start
       function reStart() {
         var angle = getRandomInt(-45, 45)


         // add a toRad() function to the angle, to change the grades to radian
         if (typeof(Number.prototype.toRad) === "undefined") {
           Number.prototype.toRad = function() {
             return this * Math.PI / 180;
           }
         }

         // do the trig to get the x and y components
         var x = Math.cos(angle.toRad())*speed
         var y = Math.sin(angle.toRad())*speed

         // apply physics impulse to start the ball
         ballCollider.applyLinearImpulse(Qt.point(x, y), ballCollider.pos)
       }

       // Random range function returns a random value between min and max
          function getRandomInt(min, max) {
            return Math.floor(Math.random() * (max - min + 1)) + min;
          }

          Component.onCompleted: {
               if (autoCreated)
                   reStart()
             }
}
