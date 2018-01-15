import VPlay 2.0
import QtQuick 2.0

EntityBase {
   id: player
   entityType: "player"
   signal collidedWithBall

   property alias collider : playerCollider

   Rectangle {
       id: playerRect
       width: 100
       height: 10
       color: "#444444"
       anchors.centerIn: parent
   }

   BoxCollider {
     id: playerCollider
     width: playerRect.width
     height: playerRect.height

     anchors.centerIn: parent
     fixture.friction: 0
     fixture.restitution: 0
     bodyType: Body.Dynamic

     fixture.onBeginContact: {
         //when on collision
         playerCollider.bodyType = Body.Static
         collidedWithBall()
         timer.start()
     }
   }

   Timer {
       id: timer
       interval: 10

       onTriggered: {
           if (playerCollider.bodyType === Body.Dynamic) {
               console.debug("Body was Dynamic")
               playerCollider.bodyType = Body.Static
           }else {
               console.debug("Body was static")
               playerCollider.bodyType = Body.Dynamic
               timer.stop()
           }
       }

   }
}
