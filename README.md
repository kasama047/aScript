# Aorus Linux Control Script

An interactive Fish script for controlling certain parameters on Aorus/Gigabyte laptops under Linux via the `sysfs` interface provided by the [gigabyte-laptop-wmi](https://github.com/tangalbert919/gigabyte-laptop-wmi) driver.

The script was developed and tested on an **Aorus 7 9MF**. It simplifies working with the driver: instead of manually typing long commands with `grep` and `tee`, you can pick an action from a simple menu.

## Why this exists

The `gigabyte-laptop-wmi` driver exposes fan modes and other parameters through files in `/sys`. Setting values manually is inconvenient, especially if you do it regularly. This script automates typical operations:

- switching fan modes;
- changing screen brightness;
- changing the default TTL;
- applying ready-made presets.

## Features

- **`fan_mode`** - select a fan mode:
  - normal;
  - silent;
  - gaming;
  - custom;
  - auto;
  - fixed.
- **`brightness_of_screen`** - write a brightness value to `sysfs`.
- **`change_TTL`** - switch `net.ipv4.ip_default_ttl` between `64` and `65`.
- **`presets`** - ready-made combinations of settings:
  - gaming;
  - standard;
  - power_efficiency;
  - GSU.

The script runs interactively: it starts, shows a menu, and asks you to choose an action.

## Requirements

- Linux.
- The `fish` shell installed.
- `sudo` privileges to write to `/sys` and change `sysctl`.
- The [gigabyte-laptop-wmi](https://github.com/tangalbert919/gigabyte-laptop-wmi) driver installed and loaded.
- The expected paths present:
  - `/sys/devices/platform/aorus_laptop/fan_mode`;
  - `/sys/class/backlight/nvidia_0/brightness`.

> The backlight path may differ depending on your laptop model and NVIDIA driver version. You can check available devices with:
>
> ```bash
> ls /sys/class/backlight/
> ```
>
> If your device has a different name, such as `nvidia_1` or `amdgpu_bl0`, adjust the path in the `brightness_of_screen` function and in the presets.

## Driver installation

First, install the `gigabyte-laptop-wmi` driver by following the instructions in its repository:

https://github.com/tangalbert919/gigabyte-laptop-wmi

After installation, make sure the file exists:

```bash
cat /sys/devices/platform/aorus_laptop/fan_mode
```

If the file exists and is readable, you can use the script.

## Script installation

```bash
git clone https://github.com/kasama047/aScript.git
cd aScript
chmod +x aorus.fish
```

## Running

```bash
./aorus.fish
```

If `fish` is not your current shell:

```bash
fish aorus.fish
```

The script will then show a menu:

```text
what do you want to change?
1) presets
2) fan_mode
3) brightness_of_screen
4) change_TTL
```

Choose the number of the desired item and follow the prompts.

## Presets

In the current version of the script, the presets set the following values:

| Preset | Fan mode | Brightness | TTL |
|---|---:|---:|---:|
| gaming | `2` | `100` | `64` |
| standard | `3` | `100` | `64` |
| power_efficiency | `1` | `70` | `64` |
| GSU | `1` | `70` | `65` |

The fan mode values correspond to the driver's raw values. If the driver or firmware on your model uses different numbering, verify the mapping manually and adjust the arrays in the `presets` function.

## Important notes

- The script writes to `/sys` and changes `sysctl` via `sudo`. Review the code before running it and make sure the paths and values are suitable for your model.
- The brightness value is written directly to `brightness`. In `sysfs`, brightness is usually not a percentage but a value in the range from `0` to `max_brightness`. You can check the maximum with:

  ```bash
  cat /sys/class/backlight/nvidia_0/max_brightness
  ```

- Changing TTL may affect network behavior. Use this feature deliberately.
- The script is not affiliated with Gigabyte/Aorus and is provided as is, without warranty.

## Project status

This is a small personal tool that has proven convenient in practice. The project does not aim to be universal: it is primarily designed for the Aorus 7 9MF and similar models using the `gigabyte-laptop-wmi` driver.

## Roadmap

- Rewrite the script in Bash.
- Add more features and presets.
- Add input validation and clearer error messages.
- Detect `sysfs` file paths automatically where possible.
- Add a non-interactive mode and command-line flags.

## Acknowledgements

- [tangalbert919/gigabyte-laptop-wmi](https://github.com/tangalbert919/gigabyte-laptop-wmi) - the driver that provides the `sysfs` interface for controlling the hardware.

## License

This project is distributed under the MIT License. See the [LICENSE](LICENSE) file for details.