import VPlay 2.0
import QtQuick 2.0

EntityBase {
    id: wall
    entityType: "wall"
    signal collidedWithBall
    property alias collider: wallCollider
    property alias color: wallRect.color


    Rectangle {
      id: wallRect
      color: "#444444"
      anchors.fill: parent
    }

    BoxCollider {
        id: wallCollider
        width: wallRect.width
        height: wallRect.height
        anchors.fill: parent
        bodyType: Body.Static

        fixture.onBeginContact: {
            //when on collision
            collidedWithBall()
        }
    }
}
