---
title: darktable
id: darktable
weight: 10
draft: false
author: "people"
---

The `darktable` binary starts darktable with its GUI and full functionality. This is the standard way to use darktable.

`darktable` can called with the following command line parameters:

```
darktable [-d {all,cache,camctl,camsupport,control,dev,
               fswatch,input,lighttable,lua,masks,memory,nan,
               opencl,perf,pwstorage,print,sql,ioporder,
               imageio,undo,signal}]
          [<input file>|<image folder>]
          [--version]
          [--disable-opencl]
          [--library <library file>]
          [--datadir <data directory>]
          [--moduledir <module directory>]
          [--tmpdir <tmp directory>]
          [--configdir <user config directory>]
          [--cachedir <user cache directory>]
          [--localedir <locale directory>]
          [--luacmd <lua command>]
          [--noiseprofiles <noiseprofiles json file>]
          [--d-signal <signal>]
          [--d-signal-act <all,raise,connect,disconnect,print-trace>]
          [--enforce-tiling]
          [--conf <key>=<value>]
          [-t <num openmp threads>]
```

All parameters are optional. In most cases darktable should be started without any additional parameters, in which case darktable uses suitable defaults.

`-d {all,cache,camctl,camsupport,control,dev,fswatch,input,lighttable,lua,masks,memory,nan,opencl,perf,pwstorage,print,sqlioporder,imageio,undo,signal}`
: Enable debug output to the terminal. There are several subsystems of darktable and each of them can be debugged separately. You can use this option multiple times if you want to debug more than one subsystem (e.g. `darktable -d opencl -d camctl`) or debug all of them at once (with `-d all`). Some debug options also provide more verbose output, which can be invoked with the additional option `-d verbose`. The verbose option must be explicitly provided, even when using `-d all`.

`--d-signal <signal>`
: If `-d signal` or `-d all` is specified, specify the signal to debug using this option. Specify `ALL` to debug all signals or specify signal using it's full name. Can be used multiple times.

`--d-signal-act <all,raise,connect,disconnect,print-trace>`
: If `-d signal` or `-d all` is specified, specify the signal action to debug using this option.

`--enforce-tiling`
: Force tiling to be used, even on systems with plenty of memory (for easier debugging of tiling issues).

`<input file>|<image folder>`
: Optionally supply the name of an image file or folder. If a filename is given darktable starts in darkroom view with that file opened. If a folder is given darktable starts in lighttable view with the content of that folder as the current collection.

`--version`
: Print the darktable version number, a copyright notice, some other useful information, and then terminate.

`--disable-opencl`
: Prevent darktable from initializing the OpenCL subsystem. Use this option if darktable crashes at startup due to a defective OpenCL implementation.

`--library <library file>`
: darktable keeps image information in an sqlite database for fast access. The default location of that database file is `$HOME/.config/darktable/library.db`. Use this option to provide an alternative location (e.g. if you want to do some experiments without compromising your original `library.db`). If the database file does not exist, darktable creates it for you. You may also provide `:memory:` as the library file, in which case the database is kept in system memory -- all changes are discarded when darktable terminates.

: Whenever darktable starts, it will lock the library to the current user. It does this by writing the current process identifier (PID) into a lock file `<library file>.lock` next to the library specified. If darktable finds an existing lock file for the library, it will terminate immediately.

`--datadir <data directory>`
: Define the directory where darktable finds its runtime data. The default location depends on your installation. Typical locations are `/opt/darktable/share/darktable/` and `/usr/share/darktable/`.

`--moduledir <module directory>`
: darktable has a modular structure and organizes its modules as shared libraries for loading at runtime. This option tells darktable where to look for its shared libraries. The default location depends on your installation. Typical locations are `/opt/darktable/lib64/darktable/` and `/usr/lib64/darktable/`.

`--tmpdir <tmp directory>`
: Define where darktable should store its temporary files. If this option is not supplied darktable uses the system default.

`--configdir <config directory>`
: Define the directory where darktable stores user-specific configuration. The default location is `$HOME/.config/darktable/`.

`--cachedir <cache directory>`
: darktable keeps a cache of image thumbnails for fast image preview and precompiled OpenCL binaries for fast startup. By default the cache is located in `$HOME/.cache/darktable/`. Multiple thumbnail caches may exist in parallel -- one for each library file.

`--localedir <locale directory>`
: Define where darktable can find its language-specific text strings. The default location depends on your installation. Typical locations are `/opt/darktable/share/locale/` and `/usr/share/locale/`.

`--luacmd <lua command>`
: A string containing lua commands to execute after lua initialization. These commands will be run after your “luarc” file.
: If lua is not compiled-in, this option will be accepted but won't do anything.

`--noiseprofiles <noiseprofiles json file>`
: Provide a json file that contains camera-specific noise profiles. The default location depends on your installation. Typical locations are `/opt/darktable/share/darktable/noiseprofile.json` and `/usr/share/darktable/noiseprofile.json`.

`--conf <key>=<value>`
: darktable supports a rich set of configuration parameters defined by the user in `$HOME/.config/darktable/darktablerc`. You may temporarily overwrite individual settings on the command line with this option -- these settings will not be stored in `darktablerc` on exit.

`-t <num openmp threads>`
: limit number of openmp threads to use in openmp parallel sections
