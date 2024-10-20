#Requires AutoHotkey v2.0 ;Tells the AHK interpreter that we're using v2.

; "DeskIcons.ahk"
; Updated to be x86 and x64 compatible by Joe DF
; Revision Date : 22:13 2014/05/09
; From : Rapte_Of_Suzaku
; http://www.autohotkey.com/board/topic/60982-deskicons-getset-desktop-icon-positions/


; "DeskIcons v2.ahk"
; Updated to v2 by Chuck Or my real name that you don't know about Charlie.
; Revision Date : 11:13 AM 10/19/2024 
; 

/*
	Save and Load desktop icon positions
	based on save/load desktop icon positions by temp01 (http://www.autohotkey.com/forum/viewtopic.php?t=49714)
	
	Example:
		; save positions
		coords := DeskIcons()
		MsgBox("now move the icons around yourself")
		; load positions
		DeskIcons(coords)
	
	Plans:
		handle more settings (icon sizes, sort order, etc)
			- http://msdn.microsoft.com/en-us/library/ff485961%28v=VS.85%29.aspx
	
*/
DeskIcons(coords:="")
{
	Critical
	
	static MEM_COMMIT := 0x1000
	static PAGE_READWRITE := 0x04
	static MEM_RELEASE := 0x8000

	static LVM_GETITEMPOSITION := 0x00001010
	static LVM_SETITEMPOSITION := 0x0000100F
	static WM_SETREDRAW := 0x000B
	
	hwWindow := ControlGetHwnd("SysListView321", "ahk_class Progman")

	if(!hwWindow) ; #D mode
		hwWindow := ControlGetHwnd("SysListView321", "A")
	If(WinExist("ahk_id " hwWindow))  ; last-found window set
		iProcessID := WinGetPID()
		
	hProcess := DllCall("OpenProcess"	, "UInt",	0x438			; PROCESS-OPERATION|READ|WRITE|QUERY_INFORMATION
										, "Int",	FALSE			; inherit = false
										, "ptr",	iProcessID)
	if(hwWindow and hProcess)
	{	
		list := ListViewGetContent("Col1", "SysListView321", "ahk_class Progman")
		if(!coords)
		{
			iCoord := Buffer(8)			
			pItemCoord := DllCall("VirtualAllocEx", "ptr", hProcess, "ptr", 0, "UInt", 8, "UInt", MEM_COMMIT, "UInt", PAGE_READWRITE)
			Loop Parse, list, "`n"
			{
				ErrorLevel := SendMessage(LVM_GETITEMPOSITION, A_Index-1, pItemCoord)
				cbReadWritten := 0
				DllCall("ReadProcessMemory", "ptr", hProcess, "ptr", pItemCoord, "UInt", iCoord.Ptr, "UInt", 8, "UIntP", &cbReadWritten)
				ret .= A_LoopField ":" (NumGet(iCoord, "Int") & 0xFFFF) | ((NumGet(iCoord, 4, "Int") & 0xFFFF) << 16) "`n"
			}
			DllCall("VirtualFreeEx", "ptr", hProcess, "ptr", pItemCoord, "ptr", 0, "UInt", MEM_RELEASE)
		}
		else
		{
			ErrorLevel := SendMessage(WM_SETREDRAW, 0, 0)
			Loop Parse, list, "`n"
				If RegExMatch(coords, "\Q" A_LoopField "\E:\K.*", &iCoord_new)
					ErrorLevel := SendMessage(LVM_SETITEMPOSITION, A_Index-1, (iCoord_new&&iCoord_new[0]))
			ErrorLevel := SendMessage(WM_SETREDRAW, 1, 0)
			ret := true
		}
	}
	DllCall("CloseHandle", "ptr", hProcess)
	return ret
}
