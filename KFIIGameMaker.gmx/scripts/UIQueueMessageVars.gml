///UIQueueMessageVars(message, var1, var2, ...);

var FinalMessage = argument[0];

for(var i = 1; i < argument_count; ++i)
{
    FinalMessage = string_replace(FinalMessage, "\v"+string(i-1), argument[i]);
}

ds_queue_enqueue(conUI.messageQueue, FinalMessage);
