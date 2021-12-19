///EffectInstantiate(effectDeclaration);

if(argument0[0] == $FFFF)
    return null;

//Get tile this effect is 'on'
var arrTile = tilemap[argument0[4], argument0[5]];

//Store Effect Instance Parameters
var IsEnabled = true, IsVisible = false;
var Type = argument0[0], Data = null;
var PositionX = 0, PositionY = 0, PositionZ = 0;
var RotationX = 0, RotationY = 0, RotationZ = 0;

//Fill Effect Data we already know
PositionX = argument0[9]  + argument0[4];
PositionZ = argument0[10] + argument0[5];
PositionY = argument0[11] + arrTile[(5 * argument0[3]) + 1];

//Switch based on effect ID
switch(argument0[0])
{
    //Flame
    case 0:
    case 1:
        //Create Effect Data
        Data = array_create(2);
        Data[0] = ParticleSystemCreate(128);
        Data[1] = ParticleEmitterSphereCreate(1, 3);
        
        //Setup Particle Emitter
        ParticleEmitterSphereSetOrigin(Data[1], 0, -0.08, 0);
        ParticleEmitterSphereSetRadius(Data[1], 0.08);
        
        ParticleEmitterSetMinMaxLife(Data[1], 15, 30);
        ParticleEmitterSetMinMaxVelocity(Data[1], 0, 0.007, 0, 0, 0.01, 0);
        ParticleEmitterSetMinMaxColour(Data[1], 0.95, 0.603, 0.0, 0.5, 1.0, 0.603, 0.0, 0.75);
        ParticleEmitterSetMinMaxSize(Data[1], 0.05, 0.08);
        
        //Setup Particle System
        ParticleSystemSetTexture(Data[0], conRenderer.texPartFire);
        ParticleSystemAddEmitter(Data[0], Data[1]);
    break;
    
    default:
        show_debug_message("Unidentified Effect Declaration Type: " + string(argument0[0]));
        return null;
}

var arrEffectInstance = EffectInstanceCreate();
    arrEffectInstance[EffectInstance.IsEnabled] = true;
    arrEffectInstance[EffectInstance.IsVisible] = true;
    arrEffectInstance[EffectInstance.Type]      = 1;
    arrEffectInstance[EffectInstance.Data]      = Data;
    arrEffectInstance[EffectInstance.PositionX] = PositionX;
    arrEffectInstance[EffectInstance.PositionY] = PositionY;
    arrEffectInstance[EffectInstance.PositionZ] = PositionZ;
    arrEffectInstance[EffectInstance.RotationX] = RotationX;
    arrEffectInstance[EffectInstance.RotationY] = RotationY;
    arrEffectInstance[EffectInstance.RotationZ] = RotationZ; 
    
return arrEffectInstance;
