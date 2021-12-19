///MapLoadEffects();

//Create Effect Instance List
effectInstance = ds_list_create();

//Get Effect Declarations
var arrEffectDecl  = database[3];

for(var i = 0; i < array_length_1d(arrEffectDecl); ++i)
{
    var arrEffectInst = EffectInstantiate(arrEffectDecl[i]);
    
    if(arrEffectInst != null)
    {
        ds_list_add(effectInstance, arrEffectInst);
    }else{
        continue;
    }
}
