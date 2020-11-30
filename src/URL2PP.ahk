#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance ignore
clipboard := ""
#Persistent
OnClipboardChange("ClipChanged")
ClipChanged() {
url1=%clipboard%
if RegExMatch(url1, "^https?://.*?\.(mp4|mkv|avi|mpg|mpeg|ogg|wmv|m2ts|mts|ts|mov|rm|rmvb|m4v|vob|webm|flv|3gp)")
{
RegRead, PotPlayerPath, HKEY_LOCAL_MACHINE, SOFTWARE\DAUM\PotPlayer64, ProgramPath
if WinExist("ahk_exe PotPlayerMini64.exe")
{
Run %PotPlayerPath% "%clipboard%" /add /current
}
else
{
Run %PotPlayerPath% "%clipboard%" /current
}
WinWait, ahk_exe PotPlayerMini64.exe, , 15
if WinExist("ahk_exe PotPlayerMini64.exe")
{
if !WinActive("ahk_exe PotPlayerMini64.exe")
WinActivate, ahk_exe PotPlayerMini64.exe
}
}
}
