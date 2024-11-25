; 定义变量来控制脚本的暂停状态
isPaused := false  ; 脚本的暂停状态
clickDelay := 30  ; 延迟时间，单位为毫秒

; 按下 "a" 键时，执行不同的操作根据暂停状态
~a::
{
    if (!isPaused)  ; 如果脚本未暂停
    {
        global clickDelay
        Sleep(clickDelay)  ; 添加延迟
        Click  ; 点击一次左键
    }
}

; 按下小键盘 "0" 键时，暂停或恢复点击功能
Numpad0::
{
    global isPaused := !isPaused  ; 切换暂停状态
}
