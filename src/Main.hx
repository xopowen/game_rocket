import hxd.Event;
import hxd.Window;
import h2d.Console;
import Vector2d;
import Entity;
import Rocket;

class Main extends hxd.App {

  var width: Int;
  var height: Int;

  var sky: h2d.Bitmap;
  var center: Vector2d;
  var tf:h2d.Text;

  var entity:Entity;
 
  var rocket:Rocket;
  var surfacePointCenters:Array<Float>;
  var surface:h2d.Graphics ;

  var surfaceBitMap:h2d.Bitmap;

  var textPlace:h2d.Bitmap;
  var textSpeedVertical:h2d.Text;
  var textSpeedHorizontal:h2d.Text;
  override function init():Void {
    hxd.Res.initEmbed();
    intitScene();
  }

  function intitScene():Void{
    var bg:h2d.Bitmap = new h2d.Bitmap(hxd.Res.skybox.toTile(), s2d);
    bg.alpha = 0;
    width = Std.int(bg.getBounds().width);
    height = Std.int(bg.getBounds().height);
    //s2d.scaleMode = ScaleMode.Stretch(width, height);
    center = new Vector2d(width / 2, height / 2);
    Window.getInstance().resize(width,height);
    textPlace= new h2d.Bitmap();

    rocket = new Rocket(s2d,0.2,new Vector2d(width/5, height/5),textPlace);
    surfaceBitMap = new h2d.Bitmap(s2d);
    this.drowSurface(0,width, height , 0.1 );
    surfaceBitMap.addChild(rocket.rocket.bm);
    surfaceBitMap.setScale(1);

    textSpeedVertical= new h2d.Text(hxd.res.DefaultFont.get(), textPlace);
    textSpeedVertical.setPosition(0,0);

    textSpeedHorizontal =  new h2d.Text(hxd.res.DefaultFont.get(), textPlace);
    textSpeedHorizontal.setPosition(0,30);
    surfaceBitMap.addChild(textPlace);


  }

  function drowSurface(start,end,height,scale:Float){
    
    //рисуем поверхность.  
    surfacePointCenters = new Array<Float>();
    surface = new h2d.Graphics(surfaceBitMap);
    for(x in Std.int(start)...Std.int( end)){
        surface.beginTileFill(0x131212);
        var diver = 1000 * scale;
        var y = diver * Math.sin(x/diver)+height/2;
        if(y>height/2 +90){
            y = height/2 + 90;
        }else if(y<height/2-90){
            y = height/2 - 90;
        }
        surface.drawCircle(x, y ,1,0);
        surfacePointCenters.push(y);
    }
  }

  function isCheacTouchSurfase(rocketActive:Rocket){
    if (rocketActive.isInside(surfacePointCenters)){
        rocketActive.stopMover();
    }
 
}


  override function update(dt:Float) {
     rocket.update(dt);
     isCheacTouchSurfase(rocket);
     textSpeedHorizontal.text = Std.string(Math.round( rocket.rocket.velocity.x*100));
     textSpeedVertical.text =  Std.string( Math.round( rocket.rocket.velocity.y*100));
     if(rocket.getMinDistance(surfacePointCenters)<50){
         s2d.camera.setPosition( rocket.rocket.location.x-250,  height*1.3 -height);
         textPlace.setPosition(rocket.rocket.location.x-250,  height*1.3 -height);
        surfaceBitMap.setScale(1.3);
      }else{
        textPlace.setPosition(0 ,0);
        s2d.camera.setPosition( 0 ,0);
        surfaceBitMap.setScale(1);
      }
    }

    static function main() {
      trace('start' );
      new Main();
    }
 
}