#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance ignore
clipboard := ""
#Persistent
OnClipboardChange("ClipChanged")
ClipChanged() {
copiedtext=%clipboard%
if RegExMatch(copiedtext, "^https?:\/\/.*\.(mp4|mkv|avi|mpg|mpeg|ogg|wmv|m2ts|mts|ts|mov|rm|rmvb|m4v|vob|webm|flv|3gp)$")
{
RegRead, PotPlayerPath, HKEY_LOCAL_MACHINE, SOFTWARE\DAUM\PotPlayer64, ProgramPath
if WinExist("ahk_exe PotPlayerMini64.exe")
{
Run %PotPlayerPath% "%clipboard%" /add /current
}
else
{
Run %PotPlayerPath% "%clipboard%"
}
WinWait, ahk_exe PotPlayerMini64.exe, , 15
if WinExist("ahk_exe PotPlayerMini64.exe")
{
if !WinActive("ahk_exe PotPlayerMini64.exe")
WinActivate, ahk_exe PotPlayerMini64.exe
}
}
else if RegExMatch(copiedtext, "^(https?:\/\/.*\.(mp4|mkv|avi|mpg|mpeg|ogg|wmv|m2ts|mts|ts|mov|rm|rmvb|m4v|vob|webm|flv|3gp)`r`n){1,}https?:\/\/.*\.(mp4|mkv|avi|mpg|mpeg|ogg|wmv|m2ts|mts|ts|mov|rm|rmvb|m4v|vob|webm|flv|3gp)$")
{
RegRead, PotPlayerPath, HKEY_LOCAL_MACHINE, SOFTWARE\DAUM\PotPlayer64, ProgramPath
Run %PotPlayerPath% /clipboard /current
}
}