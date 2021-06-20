#NoEnv
SetWorkingDir %A_ScriptDir%
#SingleInstance ignore
clipboard := ""
global copiedtext := ""
global PotPlayerPath := ""
RegRead, PotPlayerPath, HKEY_LOCAL_MACHINE, SOFTWARE\DAUM\PotPlayer64, ProgramPath
if ErrorLevel
{
	MsgBox, PotPlayer is either not installed or it's not the 64-bit version.
	ExitApp
}

#Persistent
OnClipboardChange("ClipChanged")

ClipChanged()
{
	if copiedtext = %clipboard% ; clipboard identical to previous
		return
	copiedtext=%clipboard%
	if RegExMatch(copiedtext, "( |\t)") ; spaces in clipboard content
		return
	else if RegExMatch(copiedtext, "^https?:\/\/.*\.(mp4|mkv|avi|mpg|mpeg|m3u8|ogg|wmv|m2ts|mts|ts|mov|rm|rmvb|m4v|vob|webm|flv|3gp)[^\n ]*$") ; single URL
	{
		RegRead, PotPlayerPath, HKEY_LOCAL_MACHINE, SOFTWARE\DAUM\PotPlayer64, ProgramPath
		if ErrorLevel
		{
			MsgBox, PotPlayer is either not installed or it's not the 64-bit version.
			ExitApp
		}
		TrayTip , URL2PP, % "Adding link to PotPlayer..." , 10
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
	else if RegExMatch(copiedtext, "^(https?:\/\/.*\.(mp4|mkv|avi|mpg|mpeg|m3u8|ogg|wmv|m2ts|mts|ts|mov|rm|rmvb|m4v|vob|webm|flv|3gp)[^\n ]*`r`n){1,}https?:\/\/.*\.(mp4|mkv|avi|mpg|mpeg|m3u8|ogg|wmv|m2ts|mts|ts|mov|rm|rmvb|m4v|vob|webm|flv|3gp)[^\n ]*$") ; multiple URLs
	{
		temp := StrReplace(copiedtext,"/","\")
		if WinExist("ahk_exe PotPlayerMini64.exe")
		{
			if !WinActive("ahk_exe PotPlayerMini64.exe")
					WinActivate, ahk_exe PotPlayerMini64.exe
		}
		Sort, temp, \
		sortedString := StrReplace(temp,"\","/")
		URLArray := StrSplit(sortedString,"`r`n")
		FilenameArray := []
		Loop % URLArray.MaxIndex()
		{
			inVar := URLArray[A_Index]
			SplitPath, inVar, outVar
			FilenameArray[A_Index] := outVar
		}
		LinkArray := {}
		Loop, % FilenameArray.MaxIndex()
			LinkArray[FilenameArray[A_Index]] := URLArray[A_Index]
		linkcount=0
		for Filename, URL in LinkArray
		{
			linkcount++
		}
		TrayTip , URL2PP, % "Adding " . linkcount . " links to PotPlayer..." , 10
		counter=0
		for Filename, URL in LinkArray
		{
			this_link := URL
			if counter = 0
			{
				if !WinExist("ahk_exe PotPlayerMini64.exe")
					Run %PotPlayerPath% "%this_link%" /add ; starting playback while adding multiple URLs currently causes issues in PotPlayer
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
			counter++
		}
	}
}
