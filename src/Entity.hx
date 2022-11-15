
import hxd.res.Image;
import h2d.Bitmap;
import Vector2d;

class Entity{

    public var location(default,null):Vector2d;
    public var velocity(default,null):Vector2d =  Vector2d.zero();
    public var acceleration(default,default):Vector2d = Vector2d.zero();
    public var bm:h2d.Bitmap;

    public var EffectTouchLeft:Null<Void->Void>;
    public var EffectTouchRight:Null<Void->Void>;
    public var EffectTouchUp:Null<Void->Void>;
    public var EffectTouchDown:Null<Void->Void>;


    public function new(image,location,scene,size ){
        bm = new h2d.Bitmap(image,scene);
        bm.height = size.height;
        bm.width = size.width;
        //bm.tile.dx = -bm.tile.width*0.5;
        //bm.tile.dy = -bm.tile.height*0.5;
        this.location = location;
        bm.setPosition(location.x, location.y);
        

    }

    public function update(dt:Float){

        velocity = velocity.add(acceleration.mul(dt));
        location  = location.add(velocity);
        acceleration = acceleration.mul(0);
        bm.setPosition(location.x, location.y);
    }


    public function applyForce(force:Vector2d){
        acceleration = acceleration.add(force.div(bm.scaleX /10));
    }

    public function removeImage(){
        bm.remove();
    }



    public function applyBoundaries(xmin,xmax,ymin,ymax){
        var hwind = bm.tile.width/2 * bm.scaleX ;
        var height = bm.tile.height / 2* bm.scaleY ;

         

        if (location.x - bm.width/2 < xmin){
            velocity.x = - velocity.x;
            if(EffectTouchLeft != null ){
                EffectTouchLeft();
            }
        }else if (location.x + bm.width/2 > xmax){
            velocity.x = -velocity.x;
            if(EffectTouchRight != null ){
                EffectTouchRight();
            }
        }
        if (location.y - bm.height/2 < ymin){
            velocity.y = -   velocity.y;
            if(EffectTouchUp != null ){
                EffectTouchUp();
            }
        }else if (location.y + bm.height/2 > ymax){
            velocity.y = -velocity.y;
            if(EffectTouchDown != null ){
                EffectTouchDown();
            }
        }



    }
    public function  getBoundingBox(){
        return [location.x - bm.width/2,
                location.x + bm.width/2,
                location.y - bm.height/2,
                location.y + bm.height/2];
    }
    
    public function toString(){
        return location;
    }


    public function stop(){
        velocity = Vector2d.zero();
        acceleration= Vector2d.zero();
    }
    
    function delit(){}

}