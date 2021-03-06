/*
 * Author: Titan
 * Handle throttling of positional update logging
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call FUNC(trackLoop);
 *
 * Public: No
 */

#include "script_component.hpp"
private _functionLogName = "AAR > trackLoop";

DBUG("Starting track loop", _functionLogName);

private _timeSinceLastInfantryInsert = time;
private _timeSinceLastGroundVehicleInsert = time;
private _timeSinceLastAirVehicleInsert = time;
private _timeSinceLastMarkerInsert = time;

while { true } do {

    if (GVAR(logEvents)) then {

        // We only want to log movements if there are players in the map
        private _playerCount = 0;

        {
            if (isPlayer _x) then {
                _playerCount = _playerCount + 1;
            };

        } forEach playableUnits;

        if (_playerCount > 0) then {

            // We save unit positions at different frequencies depending on their vehicle

            if (time >= _timeSinceLastInfantryInsert + GVAR(insertFrequencyInfantry)) then {
                call FUNC(trackInfantry);
                _timeSinceLastInfantryInsert = time;
            };

            if (time >= _timeSinceLastGroundVehicleInsert + GVAR(insertFrequencyGroundVehicle)) then {
                ["ground"] call FUNC(trackVehicles);
                _timeSinceLastGroundVehicleInsert = time;
            };

            if (time >= _timeSinceLastAirVehicleInsert + GVAR(insertFrequencyAirVehicle)) then {
                ["air"] call FUNC(trackVehicles);
                _timeSinceLastAirVehicleInsert = time;
            };

            if (time >= _timeSinceLastMarkerInsert + GVAR(insertFrequencyMarkers)) then {
                call FUNC(trackMarkers);
                _timeSinceLastMarkerInsert = time;
            };
        };
    };

    sleep (0.2);
};
