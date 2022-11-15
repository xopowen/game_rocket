import h2d.Tile;
import h2d.Bitmap;
import Vector2d;

class Particle{
    public var bitmap:h2d.Bitmap;
    var position:Vector2d;
    var maxDistanceFlay:Float;
    var texsture:Tile;
    var direction:Vector2d;
    public var statysLife:Bool;
    public function new (position,direction,parant:h2d.Bitmap,maxDistanceFlay:Float){
        this.maxDistanceFlay = maxDistanceFlay;
        this.direction = direction;
        this.position = position;
        texsture = Tile.fromColor(0xF80000,4,4);
        bitmap =  new h2d.Bitmap(texsture);
        bitmap.setPosition(position.x, position.y);
 
        parant.addChild(bitmap);
        statysLife = true;
        
    }

    public function update(){
        position = position.sub(direction);
        maxDistanceFlay -=1;
        bitmap.setPosition(position.x, position.y);
        if(maxDistanceFlay<=0){
    
            statysLife = false;
 
            bitmap.remove();
        }
    }

}