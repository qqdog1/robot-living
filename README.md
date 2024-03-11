# robot-living

{
"name": "",
"triggered": [true, false, false, true, true, true, true],
"tasks": [
{
"name": "早睡早起",
"type": "durationTask",
"start": "22:00",
"end": "06:00"
},
{
"name": "喝水",
"type": "segmentedTask",
"start": "06:00",
"end": "20:00",
"loopMin": 30
},
{
"name": "關瓦斯",
"type": "oneTimeTask",
"time": "21:00"
}
]
}