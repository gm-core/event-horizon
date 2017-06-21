/// @param eventName
/// @param optionalData

var eventName = argument[0];
var eventDataRaw = argument_count > 1 ? argument[1] : "";
var eventMap = global.__events_listeners;
global.__events_lastFired = eventName;

if (!ds_map_exists(eventMap, eventName)) {
    return;
}

var eventList = eventMap[? eventName];
var eventListLength = ds_list_size(eventList);
        
for (var i = 0; i < eventListLength; i++) {
    var listenerData = eventList[| i];
    
    if (listenerData[@ EventProperties.Active]) {
        if (listenerData[@ EventProperties.EventNumberSecond] != -1) {
            var eventOne = listenerData[@ EventProperties.EventNumber];
            var eventTwo = listenerData[@ EventProperties.EventNumberSecond];
            with (listenerData[EventProperties.Instance]) {
                eventData = eventDataRaw;
                event_perform(eventOne, eventTwo);
            }
        } else {
            with (listenerData[EventProperties.Instance]) {
                eventData = eventDataRaw;
                event_user(listenerData[@ EventProperties.EventNumber]);
            }
        }
    }
}

if (global.__events_deleteCount > EventSystem.GarbageCollectThreshold) {
    event_system_flush();
}
