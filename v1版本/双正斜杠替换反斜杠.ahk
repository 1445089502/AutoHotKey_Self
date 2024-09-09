#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%
#SingleInstance Force

#IfWinActive ; 无条件的 #IfWinActive，使脚本在任何窗口中生效
$Pause::
    ClipSaved := ClipboardAll ; 保存剪贴板内容
    Send, ^c ; 复制选中的文本
    ClipWait ; 等待剪贴板内容可用
    Clipboard := StrReplace(Clipboard, "\", "//") ; 替换反斜杠
    Send, ^v ; 粘贴替换后的文本
    Clipboard := ClipSaved ; 还原剪贴板内容
    ClipSaved = 
return
