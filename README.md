# ProcessWatcher
  
ProcessWatcher is a simple little Windows utility that runs a specific set of commands when all of the processes with a given process name end.
    
## COMMAND LINE
  
When ran from the command line, ProcessWatcher uses the following syntax:
    
```
C:\>ProcessWatcher processName shutdownCode [delayTime]
```

where processName is the name of the process we are supposed to watch, shutdownCode is the action that we wish to be performed when processName closes, and delayTime is an optional time window (in seconds) in which ProcessWatcher will looks for the process without erroring out.
  
Unless a delayTime is specified, the process to be watched must be running at execution of this script.
  
**processName** The complete process name is required by ProcessWatcher, including the extension. If there are spaces in process name, surround the entire name in quotes.

**shutdownCode** The shutdown code matches the combinations defined by the autohotkey documentation found at:  http://www.autohotkey.com/docs/commands/Shutdown.htm
      
In short, the code is a combination of the values:

* 0 - Logoff
* 1 - Shutdown
* 2 - Reboot
* 4 - Force
* 8 - Power down

where shutdownCode is all of the desired options added together. Forexample: 13 (1+4+8) would be the shutdown code for a Forced Power Down
    
**delayTime** (optional)
Given in seconds, delayTime sets a window in which ProcessWatcher will wait for the process to start. Without this option, the process must be running at the time of execution

## GUI
  
When ran without the propper set of command line options, ProcessWatcher runs a simple, hotkey based, GUI. An icon is placed in the system tray to show that ProcessWatcher is running and accepting hotkeys. Use of the GUI is not recomended.

Two hotkeys are defined for non-command line use:
* Win+z
** This hotkey combination takes the process name of the currently selected window and provides a confirmation window of the available actions.
* Win+x
** This hotkey combination provides a text field where a process name can be manualy entered. The process must be running at submission.
      
Copyright (C) 2011 Billy Overton