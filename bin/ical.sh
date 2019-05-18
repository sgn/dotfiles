#!/bin/sh

khal import --batch "$@" >/dev/null 2>&1
khal printics --format='
Event:       {title}
Start:       {start}
End:         {end}
Location:    {location}
Description:
{description}' "$@" 2>/dev/null | sed '1,2d'
