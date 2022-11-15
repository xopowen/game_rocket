import Vector2d;
import Entity;
import hxd.res.Image;
import hxd.Event;
import hxd.Window;
import h2d.Bitmap;
import Particle;
class EngineA {
    public var feul(default,set):Float;
    public var engine:Bitmap;
    var soundVolume(default,set):Float;//громкость музыки
    var sound:Null<hxd.res.Sound>;
    var manager:hxd.snd.Manager;
    var particleSystem:Null<Array<Particle>>;
    var img:h2d.Tile;
 
    public function new(img , place){
        this.img = img.toTile();
        engine = new Bitmap(this.img);
        engine.width = 15;
        engine.height = 50;
        engine.setPosition(place.x, place.y);
        feul = 100.0;
        manager = hxd.snd.Manager.get();
        manager.masterVolume = 0;
        particleSystem = [];
    }

    public function turnOn(){
        if(hxd.res.Sound.supportedFormat(Mp3)){
            @:privateAccess haxe.MainLoop.add(() -> {});
            sound = hxd.Res.rocketSound;
            sound.play(true,1);
        }  
    }

    public function turnOf(){
        sound.play(false,0);
        manager.stopAll();
        manager.masterVolume = 1;
       
    }
    public function update(dt:Float){
        soundVolume -= 0.01;
        if(sound != null && soundVolume>0){
            manager.masterVolume = soundVolume;
        }
        if(particleSystem.length>0){
           for (particle in particleSystem){
            particle.update();
            if(!particle.statysLife){
                particleSystem.remove(particle);
            }
           }
        }
 

    }
    
    public function explosion(vector:Vector2d){
        var width = engine.width;
        var height = engine.height;
        sound = hxd.Res.explosion;
        sound.play(false,1);
        soundVolume = 0.5;
        for(  i in 0...1000 ){
            particleSystem.push(new Particle(new Vector2d((width+i) % width,
                                                                      (height+i) % height),
            Vector2d.random(vector.x-2,vector.x+2,vector.y-2,vector.y+2),
            engine,
            100));
        }
     
    }

    public function speedUp(){
        if(feul>0){
            feul -=0.1;
            soundVolume += 0.1;
            if(particleSystem.length<30 && soundVolume >0){
                var maxDistance = soundVolume*200 - 50*Math.random();
                particleSystem.push(new Particle(new Vector2d(0 + Math.random()*engine.width, 
                                                            engine.height),
                                    new Vector2d(0,-1),
                                    engine,
                                    maxDistance));
            }
           
        }
       
    }
    function set_feul(newFuelMass){
        if(newFuelMass <= 0.0){
            
            return feul = 0.0;
        }
        return feul = newFuelMass;
    }
    function set_soundVolume(newSoundVolume){
       
        if(newSoundVolume <= 0.0){
            return soundVolume = 0.0;
        }
        if(newSoundVolume >=0.5){
            return soundVolume = 0.5;
        }
        return soundVolume = newSoundVolume;
    }
 
}