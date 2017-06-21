/// @desc Print the current event system state to the console

var eventMap = global.__events_listeners;
var eventKey = ds_map_find_first(eventMap);

while (!is_undefined(eventKey)) {
    show_debug_message("Event Mapping: " + eventKey);
    var listenerList = eventMap[? eventKey];
    
    for (var i = 0; i < ds_list_size(listenerList); i++) {
        var listenerData = listenerList[| i];
        var listenerInstance = listenerData[@ EventProperties.Instance];
        var listenerObjectName = "Deleted Instance";
        if (instance_exists(listenerInstance)) {
            listenerObjectName = object_get_name(listenerInstance.object_index);
        }
        var listenerEventNum = listenerData[@ EventProperties.EventNumber];
        var listenerActive = listenerData[@ EventProperties.Active];
        
        var listenerString = string(listenerData[@ EventProperties.Instance]) + "/" + listenerObjectName + 
            " - User Event " + string(listenerEventNum) + " - Active: " + string(listenerActive);
        show_debug_message("|-> " + listenerString);
    }
    
    eventKey = ds_map_find_next(eventMap, eventKey);
}

show_debug_message("Event Stats:");
show_debug_message("|-> Disabled event listeners: " + string(global.__events_deleteCount));
show_debug_message("|-> Garbage collecting threshold: " + string(EventSystem.GarbageCollectThreshold));
show_debug_message("|-> Last fired event: " + string(global.__events_lastFired));
