/// @desc The opposite of event_add_listener. Use this to clean up event listeners you have set up. Failing to clean up listeners may result in unexpected behavior!
/// It is suggested to run this on the "destroy" or "clean up" event on your object.
/// @param eventName
/// @param userEventOrEventCategory
/// @param optionalEventId

var eventName = argument[0];
var eventPartOne = argument[1];
var eventPartTwo = -1;

if (argument_count > 2) {
    eventPartTwo = argument[2];
}
var eventMap = global.__events_listeners;

if (ds_map_exists(eventMap, eventName)) {
    var listenerList = eventMap[? eventName];
    
    for (var i = 0; i < ds_list_size(listenerList); i++) {
        var listenerData = listenerList[| i];
        
        if (listenerData[@ EventProperties.Instance] == id && listenerData[@ EventProperties.EventNumber] == eventPartOne && listenerData[@ EventProperties.EventNumberSecond] == eventPartTwo) {
            listenerData[@ EventProperties.Active] = false;
            global.__events_deleteCount++;
        }
    }
}
