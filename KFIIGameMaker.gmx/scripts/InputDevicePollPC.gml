///InputDevicePollPC(InputDevice);

var devLastState = argument0[@ 3];
var devCurrState = argument0[@ 4];
var devMappings  = argument0[@ 5];

var mapping;
for(var i = 0; i < array_length_1d(devMappings); ++i)
{
    mapping = devMappings[i];
    
    if(mapping == null)
        continue; 
    
    
    var mapType  = mapping[0];
    
    //Switch based on mapping type
    switch(mapping[0])
    {
        //Buttons. Keys/Mouse buttons
        case InputType.Button:
            devLastState[@ i] = devCurrState[i];
            devCurrState[@ i] = InputPCGet(mapping[1]);                        
        break;
        
        //True Axis. Used for Mouse
        case InputType.Axis:   
            devLastState[@ i] = devCurrState[i];            
            var Axis = array_create(3);
                Axis[@ 0] = InputPCGet(mapping[1]);
                Axis[@ 1] = InputPCGet(mapping[2]);       
                Axis[@ 2] = Axis[@ 0] != 0 | Axis[@ 1] != 0; 
                
            devCurrState[@ i] = Axis;
        break;
        
        //Fake Axis. Used for keys
        case InputType.FakeAxis: 
            devLastState[@ i] = devCurrState[i];            
            var Axis = array_create(3);            
                Axis[@ 0] = InputPCGet(mapping[4]) - InputPCGet(mapping[3]);
                Axis[@ 1] = InputPCGet(mapping[2]) - InputPCGet(mapping[1]);
                Axis[@ 2] = Axis[@ 0] != 0 | Axis[@ 1] != 0;  
                    
                //Stop diagnols being faster.
                if(Axis[@ 0] != 0 && Axis[@ 1] != 0)
                {           
                    Axis[@ 0] *= 0.70710678118;
                    Axis[@ 1] *= 0.70710678118;
                }
                
            devCurrState[@ i] = Axis;
                             
        break
    }
}
