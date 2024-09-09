;SetTitleMatchMode, 3 ; 设置标题匹配模式，用于匹配部分窗口标题

;#IfWinActive Tomb Raider ; 仅在Tomb Raider应用程序内生效\
;#IfWinActive 原神

$v::
    global holding_w
    if (holding_w)
    {
        holding_w := false
        Send, {w up} ; 松开W键
    }
    else
    {
        holding_w := true
        Send, {w down} ; 模拟按下W键
    }
return

#IfWinActive ; 重置条件，使其他应用程序不受影响
