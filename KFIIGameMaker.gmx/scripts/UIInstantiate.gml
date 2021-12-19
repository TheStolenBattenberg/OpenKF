///UIInstantiate(uiObj);

var uiTemp = instance_create(0, 0, argument0);

ds_list_add(global.UIManager.uiList, uiTemp);

//We also set this new UI as the focused UI in conUI

conUI.uiFocus = uiTemp;

with(uiTemp)
    event_perform(ev_other, ev_user0);  //Run Custom Create
    
return uiTemp;
