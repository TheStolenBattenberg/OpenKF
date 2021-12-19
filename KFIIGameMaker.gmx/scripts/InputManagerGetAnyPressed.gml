///InputManagerGetAnyPressed(exclude);

var dev = global.IM[1];
var devMappings  = dev[5];

var pressedState = false;

for(var i = 0; i < array_length_1d(devMappings); ++i)
{
    var mapping = devMappings[i];
    
    if(i == argument0)
        continue;
    
    if(mapping == null)
        continue;   
    
    switch(mapping[0])
    {
        case InputType.Button:
            pressedState |= InputManagerGetPressed(i);
        break;
        
        case InputType.Axis:        
        case InputType.FakeAxis:
            pressedState |= InputManagerGetAxisPressed(i);
        break;
    }
}

return pressedState;
