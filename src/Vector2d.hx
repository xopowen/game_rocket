import Random;
class Vector2d {
    public var x:Float;
    public var y:Float;


    public function new(x:Float, y:Float){
        this.x = x;
        this.y = y;
    }
    public static function zero():Vector2d{
        return new Vector2d(0,0);
    }
    public static function random(xmin:Float, xmax:Float, ymin:Float, ymax){
        return new Vector2d(Random.float(xmin,xmax),Random.float(ymin, ymax));
    }

    public function toString() {
        return 'Vecto2d {$x,$y}';
    }
    public function add(other:Vector2d){
        return new Vector2d(x+other.x,y+other.y);
    }
    public function sub(other:Vector2d){
        return new Vector2d(x - other.x,y - other.y);
    }
    public function mul(value:Float){
        return new Vector2d(x*value,y*value);
    }
    public function div(value:Float){
        return new Vector2d(x/value,y/value);
    }
    public function mag(){
        return Math.sqrt(Math.pow(x,2)+Math.pow(y,2));
    }

    public function norm(){
        var m = mag();
        return div(m);
    }

    public function copy(){
        return new Vector2d(x,y);
    }

    public function limit(max:Float){
        var m = mag();
        if(m > max){
            return norm().mul(max);
        }
        return copy();
    }

    public function getCoordinatefromAngle(angle:Float,distanceX:Float, distanceY:Float){
        return new Vector2d(x + distanceX * Math.cos(angle),y + distanceY * Math.sin(angle));
    }

}