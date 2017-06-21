/// @desc Add a listener to an event. Provide the event name, and either a number representing the user event number, or a combo of event category and type. See examples for info.
/// @param eventName
/// @param userEventOrEventCategory
/// @param optionalEventId
/// @example event_add_listener("example", 0) // Run User Event 0 when "example" fires
/// @example event_add_listener("example", ev_other, ev_room_start) // Run the Room Start event when "example" fires

var eventName = argument[0];
var eventPartOne = argument[1];
var eventPartTwo = -1;

if (argument_count > 2) {
    eventPartTwo = argument[2];
}

var eventMap = global.__events_listeners;

var listenerData;
listenerData[EventProperties.Instance] = id;
listenerData[EventProperties.EventNumber] = eventPartOne;
listenerData[EventProperties.EventNumberSecond] = eventPartTwo;
listenerData[EventProperties.Active] = true;

if (ds_map_exists(eventMap, eventName)) {
    var listenerList = eventMap[? eventName];
    ds_list_add(listenerList, listenerData);
} else {
    eventMap[? eventName] = ds_list_create();
    ds_list_add(eventMap[? eventName], listenerData);
}
