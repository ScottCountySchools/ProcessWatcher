; ProcessCommander: Runs a given command when a process exits.
;     Copyright (C) 2011 Billy Overton

#SingleInstance off
#NoTrayIcon

if %0% >= 2
{
    active_process = %1%
    command = %2%
    delay = .01
    
    if(%0% >= 3)
    {
        delay = %3%
    }
    
   PID := CheckValidProc(active_process, delay)
   if(PID <> 0)
   {
       WatchProc(active_process, command)
   }
   else
   {
       ExitApp, 1
   }
   ExitApp, 0
}
else
{
    HelpMessage()
    ExitApp, 1
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Functions:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;     Checks to see if the process name given is actually exists on
;;     the system.
;;
;;     If it does not, a dialog explains that the process doesn't exist
;;     Otherwise, returns the PID of the first process with that name.
;;
;;     timeToWait: Time to wait to see if the process starts.
CheckValidProc(process_name, timeToWait)
{
    Process, Wait, %process_name%, %timeToWait%
    PID = %ErrorLevel%
    if (PID == 0) {
        MsgBox, That Process does not exist.
    }
    return PID
}


;;    Takes a process name and a shutdown code. When the process closes
;;    It runs the given shutdown code. Simple
WatchProc(process_name, command)
{
    menu, tray, NoIcon
    Process, WaitClose, %process_name%
    Run, %command%
    return
}

HelpMessage()
{
    MsgBox, 32, ProcessWatcher Help, Proper command formatting:`n`tProcessWatcher "processName" "command" [delay]
    return 0
}