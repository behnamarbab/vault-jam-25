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
                "fade_time": 4.0
            }
        },
        {
            "type": "box",
            "position": [5, 9],
            "properties": {
                "color": "red",
                "fade_time": 2.0
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
- `box`: Physics-based object that follows fading rules and can be pushed.
- `recovery`: Area that restores player opacity over time.

### Properties
| Property | Type | Default | Description |
|---|---|---|---|
| `length` | float | 1 | Horizontal scale multiplier. |
| `height` | float | 1 | Vertical scale multiplier. |
| `color` | string | "white" | Name of the color (e.g., "green", "red"). |
| `movable` | bool | false | (Platforms only) If true, the platform oscillates. |
| `fade_time`| float | 4.0 | Duration for fade-out (platforms/boxes) or restoration (recovery areas). |

## New Mechanics
- **Pushing Boxes**: Walking into a `box` will slide it. Boxes follow match/no-match fading rules just like platforms.
- **Recovery Areas**: Standing in a `recovery` zone will slowly restore your visibility.
