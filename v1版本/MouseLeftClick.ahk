#NoEnv
SetBatchLines -1

Numpad1::  ; 小键盘的数字键1
Toggle := !Toggle  ; 切换脚本的开启和关闭状态
if (Toggle)
{
    ; 打开定时器，每隔五秒执行一次鼠标左键点击
    SetTimer, MouseClickTimer, 500
    MsgBox, 脚本已开启！
}
else
{
    ; 关闭定时器
    SetTimer, MouseClickTimer, Off
    MsgBox, 脚本已关闭！
}
return

; 主键盘的数字键1 (未绑定功能，仅做注释)
; 1::MsgBox, 这是主键盘的数字键1

MouseClickTimer:
Click, Left
return
