import Vector2d;
import Entity;
import hxd.res.Image;
import hxd.Event;
import hxd.Window;
import h2d.Bitmap;

class Engine {
    var defaultMass:Float;

    var mass(default,set):Float;
    var fuelMass(default,set):Float;

    var enginePower:Float;
    public var engine:Bitmap;


    public var fullMass:Float;
    public function new(img:hxd.res.Image,tupeEngine:String,place){
        
        switch(tupeEngine){
            case "main":
                mass = 500;
                fuelMass = 50;
            case 'rule':
                mass = 50;
                fuelMass = 5;
        }
        enginePower = mass/25;
        defaultMass = mass;
        engine = new Bitmap(img.toTile());
        engine.width = 15;
        engine.height = 50;
        engine.setPosition(place.x, place.y);

        fullMass = mass + fuelMass;
    }


    public function update(dt:Float){
        if(mass<defaultMass){
            mass +=1;
        }
        fullMass = mass + fuelMass;
       
    }

    public function speedUp(){
   
        if(fuelMass>0){
            mass -= defaultMass;
            fuelMass -=0.1;
        }
    }


    function set_mass(newMass){
        if(newMass < -(defaultMass)){
            return -defaultMass;
        }
        return mass = newMass;
    }
    function set_fuelMass(newFuelMass){
        if(newFuelMass <= 0.0){
            return fuelMass = 0.0;
        }
        return fuelMass = newFuelMass;
    }

    public function toString(){
        return "mass: "+ mass +' fuelMass:'+ fuelMass;
    }
}