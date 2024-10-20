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
