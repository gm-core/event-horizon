/// @desc Internal function for intializing the event system.
function event_system_init() {
	if (!variable_global_exists("__events_listeners")) {
		global.__events_listeners = ds_map_create();
		global.__events_deleteCount = 0;
		global.__events_lastFired = "";
		global.__events_garbageCollectThreshold = 50;
		global.__events_listener_id = 0;
	}
}


/// @desc Internal function for generating a unique ID for event listeners
function _event_get_id() {
	return global.__events_listener_id++;
}


/// @desc Fires an event, optionally passing in data
/// @param {String} eventName
/// @param {Mixed}  optionalData
function event_fire() {
	// Initialize the event system if it hasn't been initialized yet
	event_system_init();
	
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
    
	    if (listenerData.active) {
			var eventMethod = listenerData.eventMethod;
			with (listenerData.instance) {
				eventMethod(eventDataRaw);
			}
	    }
	}

	if (global.__events_deleteCount > global.__events_garbageCollectThreshold) {
	    event_system_flush();
	}
}


/// @desc Add a listener to an event. Provide the event name, and either a number representing the user event number, or a combo of event category and type. See examples for info.
/// @param {String} eventName    The name of the event to add a listener to
/// @param {Method} eventMethod  The method/function to run when the event is fired
/// @returns {Struct}            A struct describing the listener for use with event_remove_listener()
/// @example var listener = event_add_listener("example", function() {event_user(0)}) // Run User Event 0 when "example" fires
function event_add_listener(eventName, eventMethod) {
	
	// Initialize the event system if it hasn't been initialized yet
	event_system_init();
	
	var eventMap = global.__events_listeners;
	
	if (typeof(eventName) != "string") {
		throw "Event Horizon Error: Event name must be a string";
	}
	
	if (typeof(eventMethod) != "method") {
		throw "Event Horizon Error: Event handler must be a method";
	}
	
	var listenerId = _event_get_id();

	var listenerData = {
		instance: self,
		eventMethod: eventMethod,
		active: true,
		listenerId: listenerId,
	};

	if (ds_map_exists(eventMap, eventName)) {
	    var listenerList = eventMap[? eventName];
	    ds_list_add(listenerList, listenerData);
	} else {
	    eventMap[? eventName] = ds_list_create();
	    ds_list_add(eventMap[? eventName], listenerData);
	}
	
	return {
		eventName: eventName,
		listenerId: listenerId,
	};
}


/// @desc The opposite of event_add_listener. Use this to clean up event listeners you have set up. Failing to clean up listeners may result in unexpected behavior!
/// It is suggested to run this on the "destroy" or "clean up" event on your object.
/// @param {Struct} listener
function event_remove_listener(listener) {
	// Initialize the event system if it hasn't been initialized yet
	event_system_init();
	
	var eventMap = global.__events_listeners;

	if (ds_map_exists(eventMap, listener.eventName)) {
	    var listenerList = eventMap[? listener.eventName];
	    for (var i = 0; i < ds_list_size(listenerList); i++) {
	        var listenerData = listenerList[| i];
        
	        if (listenerData.listenerId == listener.listenerId) {
	            listenerData.active = false;
	            global.__events_deleteCount++;
	        }
	    }
	}
}


/// @desc Clears disabled events from the system to reduce memory usage
/// This is an internal use function and you shouldn't have to call it
/// You can customize how often this runs by changing the "GarbageCollectThreshold" value in event_system_init
function event_system_flush() {
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
        
	        if (!listenerData.active) {
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
}


/// @desc Print the current event system state to the console
function event_system_debug() {
	// Initialize the event system if it hasn't been initialized yet
	event_system_init();

	var eventMap = global.__events_listeners;
	var eventKey = ds_map_find_first(eventMap);

	while (!is_undefined(eventKey)) {
	    show_debug_message("Event Mapping: " + eventKey);
	    var listenerList = eventMap[? eventKey];
    
	    for (var i = 0; i < ds_list_size(listenerList); i++) {
	        var listenerData = listenerList[| i];
	        var listenerInstance = listenerData.instance;
	        var listenerObjectName = "Deleted Instance";
	        if (instance_exists(listenerInstance)) {
	            listenerObjectName = object_get_name(listenerInstance.object_index);
	        }

	        var listenerActive = listenerData.active;
			
			var listenerString = string(listenerData.instance) + "/" + listenerObjectName + " - Active: " + string(listenerActive);

	        show_debug_message("|-> " + listenerString);
	    }
    
	    eventKey = ds_map_find_next(eventMap, eventKey);
	}

	show_debug_message("Event Stats:");
	show_debug_message("|-> Disabled event listeners: " + string(global.__events_deleteCount));
	show_debug_message("|-> Garbage collecting threshold: " + string(global.__events_garbageCollectThreshold));
	show_debug_message("|-> Last fired event: " + string(global.__events_lastFired));
}
