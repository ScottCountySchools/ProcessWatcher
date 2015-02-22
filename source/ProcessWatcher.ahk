; ProcessWatcher
;     Copyright (C) 2011 Billy Overton

#SingleInstance off
#NoTrayIcon

;; Check to see if we are going to run in GUI or command line mode.

if 0 < 2 
{
    ; We don't have enough command line options, so launch the GUI interface
    ; Reenable the tray Icon since we have hotkeys
    menu, tray, Icon
    
    ; Give a simple explination message regarding the two hotkeys.
    MsgBox, To monitor a process either:`n`t(1)Select the GUI window of the process and hit Win+z`n`t(2)Hit Win+x and type the name of the process. 
}
else
{
    ; We are in command line mode, remove all hotkeys from function
    Suspend, On
    
    
    
    active_process = %1%
    code = %2% 
    
    ; If the delay is given, set it.
    ; Else, default to .01 seconds (instant) for process checking.
    delay = .01
    if(%0% >= 3)
    {
        delay = %3%
    }
    
   ; Check to see if the given process name is a running process
   ; If it is, watch it. Otherwise exit the app in error.   
   PID := CheckValidProc(active_process, delay)
   if(PID <> 0)
   {
       WatchProc(active_process, code)
   }
   else
   {
       ExitApp, 1
   }
   
   ExitApp, 0
}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; HOTKEYS:
;;    WIN+x: Allow manual entry of a process name.
;;    WIN+z: Grab the process name of the current selected window.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#x::

InputBox, active_process, Watch Process, Process Name (including the extension):,,,,,,,, e.g. iexplore.exe

PID := CheckValidProc(active_process, .01)
if(PID == 0) {
    return
}
else {
    Gosub, CreateGUI
    return
}


#z::
WinGet, active_process, ProcessName, A
Gosub, CreateGUI
return

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
WatchProc(process_name, shutdown_code)
{
    menu, tray, NoIcon
    Process, WaitClose, %process_name%
    Shutdown, %shutdown_code%
    return
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Subroutines:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Creates the nice and simple action select gui.
;; Uses:
;;       active_process: process name
CreateGUI:
Suspend, On
Gui, 5:font, s10
Gui, 5:font, cRed bold
Gui, 5:Add, Text,, %active_process%
Gui, 5:font, cBlack norm

Gui, 5:Add, Text,, What action should be taken?

Gui, 5:Add, ListBox, vMyListBox gMyListBox r5, LogOff||Restart|Shutdown|Force Shutdown|Force Restart 

Gui, 5:Add, Text,, Press ESC to cancle.
Gui, 5:Add, Button, default, OK
Gui, 5:Show,,Watch Process
return

;; Handles the closing of the GUI and restores the hotkeys.
5GuiEscape:
5GuiClose:
Gui, Destroy
Suspend, Off
return

;; Handles the selecting of an action
MyListBox:
if A_GuiEvent <> DoubleClick
    return
; else fall through to the next label


;; Destroys the gui, sets the code based on the selected action.
;; and then calls WatchProc()
5ButtonOK:

GuiControlGet, MyListBox
Gui, Destroy


code = 0
if(MyListBox == "LogOff") {
    code = 0
}
else if(MyListBox == "Restart") {
    code = 2
}
else if(MyListBox == "Shutdown") {
    code = 9
}
else if(MyListBox == "Force Shutdown") {
    code = 13
}
else if(MyListBox == "Force Restart") {
    code = 6
}

WatchProc(active_process, code)
ExitApp, 0