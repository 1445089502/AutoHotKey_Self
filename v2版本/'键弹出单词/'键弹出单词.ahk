#Requires AutoHotkey v2.0
#SuspendExempt
^!r::Reload()
^!h::Suspend()
#SuspendExempt false
#SingleInstance Force
A_MenuMaskKey := "vkFF"

clicked := False
previousGui := ""  ; 全局变量用于存储上一个窗口句柄
textControl := ""  ; 用于保存文本控件
destroyTime := 3000 ; 定义自动销毁时间，单位为毫秒（这里是3秒）

; 定义自定义窗口宽度和高度
customWidth := 200  ; 窗口的自定义宽度
customHeight := 80  ; 窗口的自定义高度

filePath := "G:\autohotkey\self\v2版本\'键弹出单词\words.txt"  ; 替换为你的txt文件路径
words := LoadWordsFromFile(filePath)  ; 从txt文件加载词汇

~':: {
    global clicked := !clicked
    global previousGui
    global textControl
    global customWidth, customHeight

    ; 获取词汇列表的最大索引
    maxIndex := words.Length

    ; 随机选择词汇
    index := Random(1, maxIndex)
    randomWord := words[index]

    ; 如果没有创建过窗口，则创建新窗口
    if (previousGui == "") {
        ; 使用 +E0x08000000 保证窗口不会获取焦点，+Disabled 禁用窗口响应，+OwnDialogs 使对话框独立
        MyGui := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x08000000 +Disabled +OwnDialogs")  ; 创建无标题栏且不获取焦点的 Gui 实例
        MyGui.SetFont("cFF69B4 s20","微软雅黑")  ; 使用支持中文的字体
        MyGui.BackColor := "cFF69B5"  ; 设置窗口背景颜色
        textControl := MyGui.Add("Text", "BackgroundTrans Center", randomWord)  ; 设置文本居中，背景为透明

        ; 使用固定的 X 和 Y 坐标来显示窗口
        X := 100  ; 固定X坐标
        Y := 850  ; 固定Y坐标

        ; 设置窗口的自定义大小，并显示窗口，不激活窗口焦点
        MyGui.Show("x" X " y" Y " w" customWidth " h" customHeight "NA")

        ; 设置背景色为透明
        hwnd := MyGui.Hwnd
        WinSetTransparent(0, "ahk_id " hwnd)  ; 将窗口透明度设置为完全不透明
        WinSetTransColor("cFF69B5", "ahk_id " hwnd)  ; 将背景部分设置为透明

        ; 将当前窗口句柄存储为上一个窗口
        previousGui := MyGui
    } else {
        ; 如果窗口已经存在，则只修改文本内容
        textControl.Text := randomWord
        ; 保持自定义大小，重新显示窗口
        previousGui.Show("w" customWidth " h" customHeight)
    }

    ; 设置定时器，在指定时间后销毁窗口
    SetTimer(DestroyWindow, destroyTime)
}

DestroyWindow() {
    global previousGui
    if (previousGui) {
        previousGui.Destroy()  ; 销毁窗口
        previousGui := ""  ; 重置previousGui以便下次使用
    }
}

LoadWordsFromFile(filePath) {
    words := []
    try {
        ; 打开文件并使用 UTF-8 编码读取内容，以支持中文
        file := FileOpen(filePath, "r", "UTF-8")
        if (!file) {
            MsgBox("Failed to open file: " filePath)
            return words
        }

        ; 逐行读取文件内容并添加到词汇列表
        while (!file.AtEOF) {
            line := file.ReadLine()
            if (StrLen(Trim(line)) > 0) {
                words.Push(Trim(line))  ; 去除每行的首尾空白字符并添加到列表
            }
        }
        file.Close()
    } catch {
        MsgBox("Error reading file: " filePath)
    }
    return words
}
