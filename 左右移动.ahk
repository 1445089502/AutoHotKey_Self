; 定义全局变量
global MoveMouse := false
global direction := 1  ; 1 表示向右移动，-1 表示向左移动

; 按下 m 键时开始或停止鼠标移动
m::
    MoveMouse := !MoveMouse
    if (MoveMouse)
    {
        SetTimer, MoveMouseLeftRight, 5  ; 将计时器频率设置为5毫秒，增加速度
    }
    else
    {
        SetTimer, MoveMouseLeftRight, Off
    }
    return

; 移动鼠标的子程序
MoveMouseLeftRight:
    MouseGetPos, x, y  ; 获取当前鼠标位置
    if (x >= A_ScreenWidth - 50)  ; 如果到达屏幕右边缘，改变方向
    {
        direction := -1
    }
    else if (x <= 50)  ; 如果到达屏幕左边缘，改变方向
    {
        direction := 1
    }
    ; 直接设置鼠标位置，而不是相对移动
    x := x + (direction * 20)
    DllCall("SetCursorPos", "int", x, "int", y)
    return

; 以管理员权限重新运行脚本
if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}
