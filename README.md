# Bitmask Calculator - NVIDIA Values

This was meant to be a normal bitmask calculator, but I decided to add features to it that made it possible to directly configure and apply NVIDIA values. And as most of you probably didn't understand anything of [resman](https://discord.com/channels/836870260715028511/1349023856001548338) yet, the tool will make it easy for you. You may have seen people sharing NVIDIA values with weird looking data, example:
```bat
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" /v RMElcg /t REG_DWORD /d 1431655765 /f
```
Ever wondered what the data of `1431655765` does? The tool let's you load bitfield definitions or constant options, shows all options and let's you choose them via a dropdown menu. After selecting a option, it updates the `dec`, `hex`, `bin` data and displays the bit positions. If you want to use the value, you can add it with the `Reg Add` button, which searches for the correct key.

Preview:

The tool currently has a selection of `967` values ([`nvvalues.txt`](https://github.com/5Noxi/NVIDIA-Bitmask-Calc/blob/main/nvvalues.txt)). It works with my own `.json` converted bitfield definitions. This doesn't mean that all of them are configurable or used by your system. List of values, which got read on my system:
> https://discord.com/channels/836870260715028511/1375059420970487838/1375059865667633275

`Reg Add` - Adds the currently selected value to the key

`Reg Del` - Removes the currently selected value from the key

`Disable All` - Enables all `Disable` bits

`Enable All` - Enables all `Enable` bits

`Open Key` - Opens the `HKLM\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}` key which includes a value named `DriverDesc` with a data of `*NVIDIA*`

`Clear` - Reverts bit states to their default

The lower right panel shows the `C Header (.h)` code of the selected value, I used the `Min Dark` theme as template for colors:
> [min-dark.json | miguelsolorio](https://github.com/miguelsolorio/min-theme/blob/master/themes/min-dark.json)

## Bitmask Calculation

Get the lower bit range (`25:24` -> `24`), shift the dec or hex x times to the left (`-shl`). Combine all results with `-bor`, and done.

Example using `RMGC6Parameters` (disabling all):
```json
"Name":  "RMGC6Parameters",
"Elements": [
  {
      "Field":  "SLEEP_AWARE_CALLBACK",
      "Bits":  "1:0",
      "Options":  [
                      { "Name":  "DEFAULT", "Value":  "0" },
                      { "Name":  "DISABLED", "Value":  "1" },
                      { "Name":  "ENABLED", "Value":  "3" }
                  ]
  },
  {
      "Field":  "DEFERRED_PMU_CALLBACK",
      "Bits":  "3:2",
      "Options":  [
                      { "Name":  "DEFAULT", "Value":  "0" },
                      { "Name":  "DISABLED", "Value":  "1" },
                      { "Name":  "ENABLED", "Value":  "3" }
                  ]
  },
  {
      "Field":  "PMU_HANDLE_MODESET",
      "Bits":  "5:4",
      "Options":  [
                      { "Name":  "DEFAULT", "Value":  "0" },
                      { "Name":  "DISABLED", "Value":  "1" },
                      { "Name":  "ENABLED", "Value":  "3" }
                  ]
  },
  {
      "Field":  "BSOD_MODESET",
      "Bits":  "7:6",
      "Options":  [
                      { "Name":  "DEFAULT", "Value":  "0" },
                      { "Name":  "DISABLED", "Value":  "1" },
                      { "Name":  "ENABLED", "Value":  "3" }
                  ]
  }
]
```
1. [`-shl`](https://discord.com/channels/836870260715028511/1361665557581140100/1362011539787481302) using the lower bit range value
```ps
0x00000001 -shl 0
0x00000001 -shl 2
0x00000001 -shl 4
0x00000001 -shl 6
```
would result in `1`, `4`, `16`, `64`

2. Combine them with [`-bor`](https://discord.com/channels/836870260715028511/1361665557581140100/1362011218151215196)
```ps
1 -bor 4 -bor 16 -bor 64
```
Output of `85`, which is the result.

⠀
Different common scenario would be `DisableDynamicPstate`:
```json
"Name":  "DisableDynamicPstate",
"Comment":  [
     "1 = Disable dynamic P-State/adaptive clocking",
     "0 = Do not disable dynamic P-State/adaptive clocking (default)",
 ],
"Elements":  [
      { "Name":  "DISABLE", "Value":  "0" },
      { "Name":  "ENABLE", "Value":  "1" }
  ]
```
The comment shows `1` = `Enabled`, `0` = `Disabled`, means bit 0 gets switched here.

Test yourself with the following example:
```json
"Name":  "RMClkSlowDown",
"Elements":  [
  {
      "Field":  "NV",
      "Bits":  "23:22",
      "Options":  [
                      { "Name":  "DEFAULT", "Value":  "0" },
                      { "Name":  "DISABLE", "Value":  "1" },
                      { "Name":  "ENABLE", "Value":  "3" }
                  ]
  },
  {
      "Field":  "HOST",
      "Bits":  "25:24",
      "Options":  [
                      { "Name":  "DEFAULT", "Value":  "0" },
                      { "Name":  "DISABLE", "Value":  "1" },
                      { "Name":  "ENABLE", "Value":  "3" }
                  ]
  },
  {
      "Field":  "IDLE_PSTATE",
      "Bits":  "27:26",
      "Options":  [
                      { "Name":  "DEFAULT", "Value":  "0" },
                      { "Name":  "DISABLE", "Value":  "1" },
                      { "Name":  "ENABLE", "Value":  "3" }
                  ]
  }
]
```
Try to disable all of them.

Solution:
Dec: `88080384`
Hex: `0x05400000`
Bin: `00000101010000000000000000000000`

```ps
0x00000001 -shl 22
0x00000001 -shl 24
0x00000001 -shl 26
```
```ps
4194304 -bor 16777216 -bor 67108864
-> 88080384
```
More info about `-shl` & `-bor` can be found in the [discord notes channel](https://discord.com/channels/836870260715028511/1361665557581140100/1362011218151215196).
