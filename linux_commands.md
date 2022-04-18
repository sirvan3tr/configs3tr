# Useful Linux Commands
These commands are used here and there.
- `top` provides a real-time view of a running system.
- `ps -aux | grep XYZ`
- `kill -9 PID`
- `pkill -f <application_na>`
- `/etc/X11/xorg.conf`
- i3 config is either at ~/.config/i3/config or /etc/i3:
Using IMWheel to change the settings on scroll speed
- Run with 'imwheel'
- mod+shift+c to reload config
- Use the Arch documentations (they are good).

# Add to path
set PATH /home/sirvan/.local/bin $PATH`

# Make a bootable USB from an ISO file on MACOS

```
# Convert the .iso file to .img
$ hdiutil convert -format UDRW -o TARGET.img SOURCE.iso

# macOS will put a .dmg at the end of the file, so change that
$ mv target.img.dmg target.img

# Find your drive e.g. /dev/disk4
$ diskutil list

# Unmount your disk
$ diskutil unmountDISK /dev/diskN

# Copy the img to the usb and then eject
$ sudo dd if=target.img of=/dev/rdiskN bs=1m
$ diskutil eject /dev/diskN
```

# Find a specific keyword in all files with certain extension
find / -name '*.py' -exec grep -l "keyword" {} \;

# Hardware
## Raspberry pi
### Autostart
Creating autostart scripts: create a file in `sudo vim /etc/xdg/autostart/myapp.desktop`

**Example:**

```
[Desktop Entry]
Exec=lxterminal -e "echo 'hello world'"
```



brew services start postgresql
