# Useful Linux Commands
These commands are used here and there.
- `top` provides a real-time view of a running system.
- `ps -aux | grep XYZ
- kill -9 PID
- pkill -f <application_na>
- /etc/X11/xorg.conf
- i3 config is either at ~/.config/i3/config or /etc/i3:
Using IMWheel to change the settings on scroll speed
- Run with 'imwheel'
- mod+shift+c to reload config
- Use the Arch documentations (they are good).

# Add to path
set PATH /home/sirvan/.local/bin $PATH`

# Find a specific keyword in all files with certain extension
find / -name '*.py' -exec grep -l "keyword" {} \;
