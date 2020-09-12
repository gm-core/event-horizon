# Event Horizon

Custom, memory-managed events for GameMaker: Studio and GameMaker: Studio 2

Version 2.0.0

## Usage

To use Event Horizon, download [the latest release](https://github.com/gm-core/event-horizon/releases), and import the `.yymps` package into your project. For detailed instructions, see [this page](https://gmcore.io/installing.html).

Once imported to your project, you can use any of the API functions below. No further setup required.

## API

### `event_add_listener(eventName, eventMethod)`

Add an event listener which will call `eventMethod` when the provided `eventName` event is fired with `event_fire()`.

This function returns a struct to be passed to `event_remove_listener()` to clean up later.

```
@desc Add a listener to an event. Provide the event name, and either a number representing the user event number, or a combo of event category and type. See examples for info.
@param {String} eventName    The name of the event to add a listener to
@param {Method} eventMethod  The method/function to run when the event is fired
@returns {Struct}            A struct describing the listener for use with event_remove_listener()
@example

// Listen for the "hurtPlayer" event and subtract 1 from health when it fires
var listener = event_add_listener("hurtPlayer", function() {
  health -= 1;
});
```

### `event_remove_listener(listener)`

Removes an event listener. Use this to clean up an event listener added with `event_add_listener()`. `listener` is the returned value from `event_add_listener()`.

This should run on the `destroy` or `clean up` event of an object, or when you no longer want the listener to run.

```
@param {Struct} listener  The listener to remove as returned from event_add_listener
@example

// Create and then remove a listener
var listener = event_add_listener("hurtPlayer", function() {
  health -= 1;
});

event_remove_listener(listener);
```

### `event_fire(eventName [, eventData])`

Fires an event, running all listeners that are currently set up for the event. Optionally, provide a value which will be passed in to the method for all listeners as the first argument.

```
@param {String} eventName
@param {Mixed} optionalData
```

### `event_system_debug()`

Prints out debugging information about the event system to the console.

## GM Core

Event Horizon is a part of the [GM Core](https://github.com/gm-core) project.

## License

Copyright (c) 2017 Michael Barrett

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
