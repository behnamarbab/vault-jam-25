# Level Design Documentation (Object-Based)

Plat Fader uses an object-oriented JSON format for level design. Levels are stored in `res://levels/`.

## File Structure

Levels are JSON objects containing metadata and a list of `objects`.

```json
{
    "level_name": "Level 1",
    "size": [1920, 1080],
    "objects": [
        {
            "type": "platform",
            "position": [0, 10],
            "properties": {
                "length": 20,
                "color": "green",
                "movable": false
            }
        },
        {
            "type": "player",
            "position": [2, 8],
            "properties": {
                "color": "purple"
            }
        }
    ]
}
```

### Object Types
- `player`: The character controlled by the player.
- `platform`: Solid ground or floating ledges.
- `goal`: The victory zone.
- `button`: Interactive triggers for color changes.
- `obstacles`: Visual or physical hazards (same as platform but usually with specific interactions).

### Properties
| Property | Type | Default | Description |
|---|---|---|---|
| `length` | float | 1 | Horizontal scale multiplier. |
| `height` | float | 1 | Vertical scale multiplier. |
| `color` | string | "white" | Name of the color (e.g., "green", "red"). |
| `movable` | bool | false | If true, the object can move (specifically for platforms). |

## Coordinate System
- `position`: `[x, y]` relative to the grid (1 unit = 64 pixels).
- Scale is applied relative to the base sprite size.
