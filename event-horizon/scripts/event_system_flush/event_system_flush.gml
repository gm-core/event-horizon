/// @desc Clears disabled events from the system to reduce memory usage
/// This is an internal use function and you shouldn't have to call it
/// You can customize how often this runs by changing the "GarbageCollectThreshold" value in event_system_init

var eventMap = global.__events_listeners;
var eventKey = ds_map_find_first(eventMap);
var deleteKeys;
deleteKeys[0] = undefined;
var deleteIdx = 0;

// Clear out inactive listeners
while (!is_undefined(eventKey)) {
    var listenerList = eventMap[? eventKey];
    
    for (var i = 0; i < ds_list_size(listenerList); i++) {
        var listenerData = listenerList[| i];
        
        if (!listenerData[@ EventProperties.Active]) {
            ds_list_delete(listenerList, i);
            i--;
        }
    }
    
    if (ds_list_size(listenerList) == 0) {
        ds_list_destroy(listenerList);
        deleteKeys[deleteIdx++] = eventKey;
    }
    
    eventKey = ds_map_find_next(eventMap, eventKey);
}

// Delete now-empty event keys
if (!is_undefined(deleteKeys[0])) {
    for (var i = 0; i < deleteIdx; i++) {
        ds_map_delete(eventMap, deleteKeys[i]);
    }
}

global.__events_deleteCount = 0;
