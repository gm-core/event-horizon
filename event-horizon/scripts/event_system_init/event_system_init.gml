global.__events_listeners = ds_map_create();
global.__events_deleteCount = 0;
global.__events_lastFired = "";

enum EventProperties {
    Instance = 0,
    EventNumber = 1,
    EventNumberSecond = 2,
    Active = 3
}

enum EventSystem {
    GarbageCollectThreshold = 50
}
