# Event Horizon

Custom, memory-managed event firing for GameMaker: Studio and GameMaker: Studio 2

## Usage

To use Event Horizon, download [the latest release](https://github.com/gm-core/event-horizon/releases), and add the scripts to your project. At the very beginning of your game, before you use any event code, run `event_sysem_init()` to initialize the event system.

## API

### `event_system_init()`

Initializes the event system. Run this before any other code in your game that uses the event system. A great place for this is on the creation code of your first room.

### `event_add_listener(eventName, userEventOrEventCategory [, eventNumber])`

Add an event listener to the object that calls this function.

This can be used two ways. The first is to only pass two arguments: The event to listen for, and the user event to run in response.

The other is to pass three arguments: The event to listen for, the category of event to run, and the number of the event to run. This works just like `event_perform` in response to an event firing. See the [event_perform docs](https://docs.yoyogames.com/source/dadiospice/002_reference/objects%20and%20instances/objects/generating%20events/event_perform.html) for more information on how that can work.

```
@param eventName {String} The event to listen for
@param userEventOrEventCategory {Real or Constant} The user event number to run, OR the category of event to run (see event_perform for more information)
@param eventNumber {Real or Constant} OPTIONAL The specific event to run if you specified the category as the second parameter. (see event_perform for more information)
