1. `xdg-open` not found
    - Run `which xdg-open` to double check the if the command exists
    - Run `sudo apt-get install xdg-utils --fix-missing` to install the package
1. I'm getting `export: (x86)/NVIDIA: bad variable name` when running some of the shell script.
This is possible because you're running on WSL and hence you are encountering this issue.
To resolve this issue, please do the following steps,
    - Create a file `/etc/wsl.conf`. 
    - Then add the following interop section with any text editor in Linux.
    ```
    [interop]
    enabled=false # enable launch of Windows binaries; default is true
    appendWindowsPath=false # append Windows path to $PATH variable; default is true
    ```
    - `wsl --shutdown` and restart your WSL OR open `services.msc` and search for `LxssManager` and restart
1. I'm getting an error, `run-detectors: unable to find an interpreter for ...`
    - Run `sudo update-binfmts --disable cli` to resolve the issue.

1. Permission issue to install `yo` package
    - https://github.com/yeoman/yeoman.io/issues/282#issuecomment-64543114
