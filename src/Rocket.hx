import Vector2d;
import Entity;
import hxd.res.Image;
import hxd.Event;
import hxd.Window;
import h2d.Bitmap;
import EngineA;
class Rocket {

    var maxSpeedDown:Float = 1.00;
    var maxSpeed:Float = -1;
    var gravity:Vector2d;
    public var rocket:Entity;
    var res:hxd.Res;
    var startLogation:Vector2d;
    var rocketImg:h2d.Tile;
    var rocketEngineLeftDown:EngineA;
    var textfeultEngineRight:h2d.Text;

    var rocketEngineRightDown:EngineA;
    var textfeultEngineLeft:h2d.Text;

    var vectorForward:Vector2d;
    var active:Bool;
    public var scale:Float;


    var rocketLocation_1:Vector2d;
    var rocketLocation_2:Vector2d;
    var rocketLocation_3 :Vector2d;
    var rocketLocation_4:Vector2d;
    var rocketHeight:Float;
    var rocketWidth :Int;

    var scene:h2d.Scene;
    var manager:hxd.snd.Manager;
    var particleSystem:Null<Array<Particle>>;
    var statusLife:Bool;

    var startPositon:Vector2d;
    var textPlace:h2d.Bitmap;
    public function new(scene,scale,startLogation,textPlace) {
        this.textPlace = textPlace;
        active = true;
        statusLife = true;
        this.scale = scale;
        this.scene = scene;
        rocketImg = hxd.Res.racket.toTile();
        
        this.startLogation = startLogation;
        startPositon = startLogation.copy();
   

        rocket = new Entity(rocketImg,startLogation,scene,{width: 50,height: 100} );
        //двигатели
        rocketEngineRightDown = new EngineA(hxd.Res.engineRight,{x: 50,y: 50});
        rocket.bm.addChild(rocketEngineRightDown.engine);
        rocketEngineRightDown.turnOn();


        rocketEngineLeftDown = new EngineA(hxd.Res.engineLeft,{x: -14,y: 50});
        rocket.bm.addChild(rocketEngineLeftDown.engine);
        rocketEngineLeftDown.turnOn();

        // текст выводимый на экран
        textfeultEngineRight = new h2d.Text(hxd.res.DefaultFont.get(), textPlace);
        textfeultEngineRight.setPosition(0,scene.getObjectsCount()*20);

        textfeultEngineLeft = new h2d.Text(hxd.res.DefaultFont.get(), textPlace);
        textfeultEngineLeft.setPosition(0,scene.getObjectsCount()*25);
        //для музыки
        manager= hxd.snd.Manager.get();
        
        rocket.bm.setScale(scale);
        //определение крайних точек
        rocketHeight = rocket.bm.height * scale;
        rocketWidth = Std.int( rocket.bm.width * scale);
        rocketLocation_1 = rocket.location;
        rocketLocation_2 = rocketLocation_1.getCoordinatefromAngle(rocket.bm.rotation ,rocketWidth,rocketWidth);
        rocketLocation_3 = rocketLocation_2.getCoordinatefromAngle(rocket.bm.rotation + Math.PI/2,rocketHeight,rocketHeight);
        rocketLocation_4 = rocketLocation_1.getCoordinatefromAngle(rocket.bm.rotation + Math.PI/2,rocketHeight,rocketHeight);
        //нажатие клавиш
        hxd.Window.getInstance().addEventTarget(onEvent);
    }
    
    function start() {
        var parant = rocket.bm.parent;
        rocket.bm.remove();
        rocket =  new Entity(rocketImg,startPositon,scene,{width: 50,height: 100} );
        parant.addChild(rocket.bm);
        rocketEngineRightDown = new EngineA(hxd.Res.engineRight,{x: 50,y: 50});
        rocket.bm.addChild(rocketEngineRightDown.engine);
        rocketEngineRightDown.turnOn();

        rocketEngineLeftDown = new EngineA(hxd.Res.engineLeft,{x: -14,y: 50});
        rocket.bm.addChild(rocketEngineLeftDown.engine);
        rocketEngineLeftDown.turnOn();
        rocket.bm.setScale(scale);

        active = true;
        statusLife = true;
        rocketEngineRightDown.turnOn();
        rocketEngineLeftDown.turnOn();
    }

    public function stopMover() {
        if(active){
            active= false;
            rocketEngineLeftDown.turnOf();
            rocketEngineRightDown.turnOf();
            resultFly();
            rocket.stop();
        }

    }
    public function isInside(surfacePointCenters:Array<Float>){

        //test pont place
        //  var cicle_1 = new h2d.Graphics(scene);
        //  cicle_1.beginFill(0xE91212);
        // cicle_1.drawCircle(rocketLocation_1.x,rocketLocation_1.y,5);
        // cicle_1.drawCircle(rocketLocation_2.x,rocketLocation_2.y,5);
        //  cicle_1.drawCircle(rocketLocation_3.x,rocketLocation_3.y,5);
        //  cicle_1.drawCircle(rocketLocation_4.x,rocketLocation_4.y,5);
     
        if ( rocketLocation_1.y > surfacePointCenters[Std.int(rocketLocation_1.x)] ||  
             rocketLocation_2.y > surfacePointCenters[Std.int(rocketLocation_2.x)] || 
             rocketLocation_3.y > surfacePointCenters[Std.int(rocketLocation_3.x)] || 
             rocketLocation_4.y > surfacePointCenters[Std.int(rocketLocation_4.x)]){
              return true;
        }
        return false;
    }

 
 
    function resultFly(){   
        var angle =Math.abs( (rocket.bm.rotation*180/Math.PI) % 360);
        var endText = new h2d.Text(hxd.res.DefaultFont.get(), textPlace);
        var interactiveText = new h2d.Interactive(20,20,endText);
        interactiveText.backgroundColor=0x34F80000;
        interactiveText.onCheck = function(event:Event){
            start();
            interactiveText.remove();
            endText.remove();
        }
        endText.text = 'restart?';
        endText.setPosition(400, 400);
        interactiveText.setPosition(20,40);
        if(angle>355 || angle < 5){
            if( Math.abs(rocket.velocity.x)<0.05 &&
                Math.abs(rocket.velocity.y)<0.05 ){
                    //выиграл
                    endText.text ="you won \n " + endText.text;
                    return;
                }
                endText.text ="Explosion engines \n " + endText.text;
                statusLife=false;
                rocketEngineLeftDown.explosion(rocket.velocity);
                rocketEngineRightDown.explosion(rocket.velocity);
                //взорвались двишки
                return;
        }
        endText.text ="Explosion engines \n " + endText.text;
        statusLife=false;
       
        rocketEngineLeftDown.explosion(rocket.velocity);
        rocketEngineRightDown.explosion(rocket.velocity);
          //взорвались двишки
    }
    public function getMinDistance(surfacePointCenters:Array<Float>){
        var arraySurfaceY =  new Array() ;
        arraySurfaceY.push( surfacePointCenters[Std.int(rocketLocation_1.x)] - rocketLocation_1.y);
        arraySurfaceY.push( surfacePointCenters[Std.int(rocketLocation_2.x)]- rocketLocation_2.y);
        arraySurfaceY.push( surfacePointCenters[Std.int(rocketLocation_3.x)]- rocketLocation_3.y);
        arraySurfaceY.push( surfacePointCenters[Std.int(rocketLocation_4.x)]- rocketLocation_4.y);
        var minYdistant = arraySurfaceY[0];

        for ( i in arraySurfaceY){
            if(minYdistant > i){
                minYdistant = i;
            }
        }
       return minYdistant;
    }

    public function setScale(scale){
        this.scale = scale;
        rocket.bm.setScale(scale);
    }


    function updateRocketLocation(){
        rocketHeight = rocket.bm.height * scale;
        rocketWidth = Std.int( rocket.bm.width * scale);
        rocketLocation_1 = rocket.location;
        rocketLocation_2 = rocketLocation_1.getCoordinatefromAngle(rocket.bm.rotation ,rocketWidth,rocketWidth);
        rocketLocation_3 = rocketLocation_2.getCoordinatefromAngle(rocket.bm.rotation + Math.PI/2,rocketHeight,rocketHeight);
        rocketLocation_4 = rocketLocation_1.getCoordinatefromAngle(rocket.bm.rotation + Math.PI/2,rocketHeight,rocketHeight);
    }

    function move(){
 
        var force =  new Vector2d(0,0);

        gravity = new Vector2d(0,0.0009);
        if(rocket.velocity.y < maxSpeedDown){
            force = force.add(gravity);
        }
       
        var y:Float = 0.01 *  -Math.cos( rocket.bm.rotation );
        var x:Float =  0.01 *  Math.sin( rocket.bm.rotation );
       
        if(rocket.velocity.y>maxSpeed &&rocket.velocity.x >maxSpeed){
            if(rocket.velocity.y<maxSpeedDown && rocket.velocity.x < maxSpeedDown){
                //force = force.add();
                vectorForward = new Vector2d(x,y);
            }else{
                vectorForward = new Vector2d(0,y);
            }
            
        }else{
            vectorForward = new Vector2d(x,0);
        }
        rocket.applyForce(force);
        updateRocketLocation();
      
       
    }

    public function update(dt:Float) {
        rocket.update(dt);
        rocketEngineLeftDown.update(dt);
        rocketEngineRightDown.update(dt);
        textfeultEngineRight.text = Std.string(rocketEngineRightDown.feul );
        textfeultEngineLeft.text = Std.string(rocketEngineLeftDown.feul);
        if(active){
            move();
        }
        if(!statusLife){
            rocket.bm.alpha-=0.01;
        }
       
        
    }

    function onEvent(event:Event){
     
        switch(event.kind){
          case EKeyDown:{
            switch (event.keyCode){
              case hxd.Key.W:
                if(active){
                    rocket.applyForce(vectorForward);
                    if(rocketEngineLeftDown.feul<=0 && rocketEngineRightDown.feul > 0){
                        rocket.bm.rotate(-2*Math.PI/180);
                    }
                    if(rocketEngineRightDown.feul<=0 && rocketEngineLeftDown.feul >0){
                        rocket.bm.rotate(2*Math.PI/180);
                    }
                    rocketEngineLeftDown.speedUp(); 
                    rocketEngineRightDown.speedUp();
                }  
              case hxd.Key.D:  
                if(active){
                    rocket.bm.rotate(2*Math.PI/180);
                    rocketEngineLeftDown.speedUp(); 
                }

              case hxd.Key.A:  
                if(active){
                    rocket.bm.rotate(-2*Math.PI/180);
                    rocketEngineRightDown.speedUp(); 
                }  
              case hxd.Key.S:  stopMover();//rocketEngineRightDown.speedUp(); 
              case _:
            }
          }
          case _:
        }
      }
}