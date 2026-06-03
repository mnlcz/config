# Usage

**Important**: these files should be **copied** to their respective locations, using SYMLINKS breaks FreeBSD.

## Summary

- rc.conf — what to enable and how to configure it
- sysctl.conf — kernel tunables
- rc.local — quick one-off boot commands
- rc.d/ scripts — structured services with dependencies

## `/etc/rc.conf`

Main system configuration file. It stores key-value pairs that control which services start at boot and how the system behaves.

## `/etc/sysctl.conf`

Controls kernel parameters that are applied at boot. Tunable values that contrast system set behavior set in `rc.conf`.

## `/etc/rc.local`

Shell script that runs late in the boot process, after all services have started.

## `/usr/local/etc/rc.d/xdg-runtime`

`rc.d` service script. The difference from rc.local is structure and control — rc.d scripts declare dependencies (REQUIRE, BEFORE), 
can be enabled/disabled via rc.conf, and integrate with the service management system (service xdg-runtime start/stop/status). 
`xdg-runtime` runs before seatd to ensure the XDG runtime directory exists before Wayland needs it. It lives in /usr/local/etc/rc.d/
 rather than /etc/rc.d/ because /etc/rc.d/ is reserved for base system services — anything you or a package adds goes under /usr/local/.

## USB notification

`usb-notify.sh` is the script that triggers the notification daemon `mako`. `usb-notify.conf` is the rule that matches the script with
the usb event. Both go under `/usr/local/*`, given that they are user-made changes.

```sh
doas ln -sf $CONF/freebsd/etc/usb-notify.sh /usr/local/bin/usb-notify.sh 
doas ln -sf $CONF/freebsd/etc/usb-notify.conf /usr/local/etc/devd/usb-notify.conf
```
