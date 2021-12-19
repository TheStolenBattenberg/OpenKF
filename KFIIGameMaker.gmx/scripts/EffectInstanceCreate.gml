///EffectInstanceCreate();

enum EffectInstance 
{
    IsEnabled = 0,
    IsVisible = 1,
    Type      = 2,
    Data      = 3,
    PositionX = 4,
    PositionY = 5,
    PositionZ = 6,
    RotationX = 7,
    RotationY = 8,
    RotationZ = 9
}

var arrEffectInstance = array_create(10);
    arrEffectInstance[EffectInstance.IsEnabled] = true;
    arrEffectInstance[EffectInstance.IsVisible] = false;
    arrEffectInstance[EffectInstance.Type]      = 0;
    arrEffectInstance[EffectInstance.Data]      = null;
    arrEffectInstance[EffectInstance.PositionX] = 0;
    arrEffectInstance[EffectInstance.PositionY] = 0;
    arrEffectInstance[EffectInstance.PositionZ] = 0;
    arrEffectInstance[EffectInstance.RotationX] = 0;
    arrEffectInstance[EffectInstance.RotationY] = 0;
    arrEffectInstance[EffectInstance.RotationZ] = 0;
    
return arrEffectInstance;
