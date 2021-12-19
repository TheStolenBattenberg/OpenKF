///MusicQueueAdd(file, loop);

var arrMusic = array_create(2);
    arrMusic[0] = global.FS[1] + "Streams\" + argument0; //Stream to load
    arrMusic[1] = argument1;                             //Weather this music should loop or not.
    
ds_queue_enqueue(conAudio.musicQueue, arrMusic);
