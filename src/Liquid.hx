class Liquid{

    public var c = 0.25;
    var xmin:Int;
    var xmax:Int;
    var ymin:Int;
    var ymax:Int;

    public function new(xmin,xmax,ymin,ymax){
        this.xmax = xmax;
        this.ymin = ymin;
        this.ymax = ymax;
        this.xmin = xmin;
    }

    public function isInside(entity:Entity) {
        
    }


}