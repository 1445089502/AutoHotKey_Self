; 创建一个简单的脚本，用于显示提示信息

; 定义快捷键 Ctrl+Shift+T 来显示“测试成功！”
^+t:: {
    MsgBox "测试成功！"
}

; 定义快捷键 F2 来显示当前时间
F2:: {
    MsgBox "当前时间: " A_Now
}

; 退出脚本的快捷键 Ctrl+Q
^q::ExitApp
