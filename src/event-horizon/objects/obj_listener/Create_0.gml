/// @desc Set up listener
//event_add_listener("exampleEvent", 0);
listener = event_add_listener("exampleEvent", function(eventData) {
	message = "You clicked it recently! That is click #" + string(eventData);
	alarm[0] = 60;
});

message = "You haven't clicked it recently!";