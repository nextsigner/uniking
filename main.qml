import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.0
import LogView 1.0

ApplicationWindow{
    id: uniking
    visible: true//false
    visibility: "Windowed"
    color: c1
    title: 'Uniking'
    width: Screen.width*0.25
    height: Screen.height
    x: 0+Screen.width-width
    //flags: Qt.Tool
    property int fs: width*0.08
    property color c1: 'black'
    property color c2: 'white'

    property string uKey: ''
    property string uLoad: ''
    property var aULoads: []
    onVisibilityChanged: {
        if(visible){
            uniking.requestActivate()
            uniking.raise()
        }
    }
    onClosing: function(close) {
        close.accepted = false;
        // Mostrar un mensaje de confirmación, por ejemplo
//        var confirmClose = confirm("¿Estás seguro que deseas cerrar la aplicación?");

//        // Si el usuario no confirma, evitar el cierre
//        if (!confirmClose) {

//        }
    }
    Connections{
        target: unik
        property string uLoad: ''
        property string uW: ''
        property string uK: ''
        onUWarningChanged: {
            let w=unik.getUWarning()
            if(w===uW && uniking.uKey === uK){
                return
            }else{
                uW=w
            }
            uK=uniking.uKey
            if(uniking.uLoad!==uLoad){
                //ta.text=''+w+'\n'
                log.clear()
                log.lv(w)
                uLoad=uniking.uLoad
            }else{
                log.lv(w)
                //ta.text+=''+w+'\n'
            }

            tHide.restart()
            uniking.visible=true
            uniking.requestActivate()
            uniking.raise()
        }
    }
    Timer{
        id: tHide
        running: false
        repeat: false
        interval: 15000
        onTriggered: uniking.visible=false
    }
    Rectangle{
        id: xApp
        color: 'black'
        anchors.fill: parent
        MouseArea{
            anchors.fill: parent
            onClicked: {
                if (mouse.modifiers & Qt.ControlModifier) {
                    Qt.quit()
                }else{
                    uniking.visible=false
                }

            }
        }
        TextArea{
            id: ta
            width: uniking.width-30
            wrapMode: TextArea.WordWrap
            font.pixelSize: 20
            color: 'white'
            anchors.horizontalCenter: parent.horizontalCenter
            visible: false

        }
        LogView{
            id: log
            app: uniking
            anchors.fill: parent
        }
    }

    Timer{
        id: tCheq
        running: true
        repeat: true
        interval: 1000
        onTriggered: {
            let data=unik.getFile('./key')
            let lineas=data.split('\n')
            let k=lineas[0]
            let p=lineas[1]
            let aP=p.split('/')
            if(aP[aP.length-1].indexOf('uniking')>=0){
                return
            }
            if(k!==uniking.uKey){
                console.log('Nueva clave '+k)
                unik.clearComponentCache()
                let url=p+'/main.qml'
                unik.addImportPath(p+'/modules')
                uniking.uLoad=url
                engine.load(url)
            }
            uniking.uKey=k
        }
    }
    Component.onCompleted: {
        log.lv('Iniciado')
    }
}
