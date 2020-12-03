#NoEnv
SetWorkingDir %A_ScriptDir%
#SingleInstance ignore
#Persistent
OnClipboardChange("ClipChanged")
ClipChanged() {
copiedtext=%clipboard%
if RegExMatch(copiedtext, "( |\t)") ; spaces in clipboard content
return
else if RegExMatch(copiedtext, "^https?:\/\/.*\.(mp4|mkv|avi|mpg|mpeg|ogg|wmv|m2ts|mts|ts|mov|rm|rmvb|m4v|vob|webm|flv|3gp)$") ; single URL
{
RegRead, PotPlayerPath, HKEY_LOCAL_MACHINE, SOFTWARE\DAUM\PotPlayer64, ProgramPath
if ErrorLevel
{
MsgBox, PotPlayer is either not installed or it's not the 64-bit version.
return
}
if WinExist("ahk_exe PotPlayerMini64.exe")
Run %PotPlayerPath% "%clipboard%" /add /current
else
Run %PotPlayerPath% "%clipboard%"
WinWait, ahk_exe PotPlayerMini64.exe, , 15
if WinExist("ahk_exe PotPlayerMini64.exe")
{
if !WinActive("ahk_exe PotPlayerMini64.exe")
WinActivate, ahk_exe PotPlayerMini64.exe
}
}
else if RegExMatch(copiedtext, "^(https?:\/\/.*\.(mp4|mkv|avi|mpg|mpeg|ogg|wmv|m2ts|mts|ts|mov|rm|rmvb|m4v|vob|webm|flv|3gp)`r`n){1,}https?:\/\/.*\.(mp4|mkv|avi|mpg|mpeg|ogg|wmv|m2ts|mts|ts|mov|rm|rmvb|m4v|vob|webm|flv|3gp)$") ; multiple URLs
{
temp := StrReplace(copiedtext,"/","\")
if WinExist("ahk_exe PotPlayerMini64.exe")
{
if !WinActive("ahk_exe PotPlayerMini64.exe")
WinActivate, ahk_exe PotPlayerMini64.exe
}
Sort, temp, \
sortedString := StrReplace(temp,"\","/")
LinkArray := StrSplit(sortedString,"`r`n")
RegRead, PotPlayerPath, HKEY_LOCAL_MACHINE, SOFTWARE\DAUM\PotPlayer64, ProgramPath
if ErrorLevel
{
MsgBox, PotPlayer is either not installed or it's not the 64-bit version.
return
}
Loop % LinkArray.MaxIndex()
{
this_link := LinkArray[A_Index]
if A_Index = 1
{
if !WinExist("ahk_exe PotPlayerMini64.exe")
Run %PotPlayerPath% "%this_link%" /add ; starting playback durring adding causes issues
else
Run %PotPlayerPath% "%this_link%" /add /current
WinWait, ahk_exe PotPlayerMini64.exe, , 15
if WinExist("ahk_exe PotPlayerMini64.exe")
{
if !WinActive("ahk_exe PotPlayerMini64.exe")
WinActivate, ahk_exe PotPlayerMini64.exe
}
Sleep, 500
}
else
Run %PotPlayerPath% "%this_link%" /add /current
Sleep, 750
}
}
}
