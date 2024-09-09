; 定义全局变量用于存储窗口标题记录及时间戳
WindowTitles := []
; 窗口标题
ActiveTitle := ""
; 程序名字
ActiveApp := ""
; 当前的时间戳（系统时间）
CurrentTime := ""
; 标题+名字
FullTitle := ""

; 创建一个 GUI 窗口和按钮
MyGui := Gui()
MyBtn := MyGui.Add("Button", "Default w200", "显示过去一分钟内的频率最高窗口")
MyBtn1 := MyGui.Add("Button", "Default w200", "导出所有窗口记录到TXT")
MyBtn.OnEvent("Click", ShowActiveWindows)
MyBtn1.OnEvent("Click", ExportToFile)
MyGui.Show()

; 定义计时器，每 5 秒钟记录一次活动窗口状态
SetTimer(RecordActiveWindow, 5000)

; 记录当前活动窗口
RecordActiveWindow(*) {
    ; 获取当前活动窗口的标题和对应的程序名称
    ActiveTitle := WinGetTitle("A")
    if (ActiveTitle = "") {
        ActiveTitle := "无标题窗口"  ; 如果窗口没有标题，给予一个默认值
    }
    ActiveApp := WinGetClass("A")
    
    ; 使用 A_Now 记录当前时间，格式为 yyyyMMddHHmmss
    CurrentTime := A_Now

    ; 将窗口标题和程序名称组合存入数组中
    FullTitle := ActiveApp . ": " . ActiveTitle
    WindowTitles.Push({Title: FullTitle, Time: CurrentTime})
}

; 显示过去一分钟内的频率最高窗口
ShowActiveWindows(*) {
    ; 获取当前时间戳
    Now := A_Now
    RecentTitles := []
    UniqueTitles := []
    FreqMap := []  ; 用数组来存储频率
    TitleMap := [] ; 用数组来存储窗口标题

    ; 遍历记录并获取最近一分钟内的窗口标题
    for record in WindowTitles {
        ; 将 A_Now 格式的时间转成时间戳来比较是否在最近一分钟
        ElapsedTime := Now - record.Time
        if (ElapsedTime <= 60000)
            RecentTitles.Push(record.Title)
    }

    ; 去除重复的窗口标题
    for title in RecentTitles {
        if !UniqueTitles.Has(title) {
            UniqueTitles.Push(title)  ; 添加到 UniqueTitles 数组
            TitleMap.Push(title)      ; 同时加入 TitleMap
            FreqMap.Push(0)           ; 初始化对应的频率为 0
        }
    }

    ; 获取最高频率窗口
    MaxFrequency := 0
    MaxTitle := ""

    for index, title in UniqueTitles {
        ; 遍历记录统计频率
        for record in WindowTitles {
            if (record.Title = title)
                FreqMap[index]++  ; 更新该标题的频率
        }

        ; 比较当前频率与最大频率
        if (FreqMap[index] > MaxFrequency) {
            MaxFrequency := FreqMap[index]
            MaxTitle := title
        }
    }

    ; 使用 for 循环逐个输出窗口标题
    AllTitles := ""
    for index, title in UniqueTitles {
        AllTitles .= title . "`n"  ; 逐行拼接每个窗口标题
    }

    ; 显示最高频率窗口及去重的窗口列表
    if (MaxFrequency > 0) {
        MsgBox("过去一分钟内频率最高的窗口:`n" MaxTitle " (出现 " MaxFrequency " 次)。`n`n所有窗口记录:`n" AllTitles, "统计结果", "OK")
    } else {
        MsgBox "过去一分钟内没有窗口记录。"
    }
}

; 导出窗口记录到TXT文件
ExportToFile(*) {
    ; 获取当前时间
    CurrentTime := FormatTime("yyyy年MM月dd日_HH时mm分")
    ; 截断掉前五个字符
    CurrentTime := SubStr(CurrentTime, 6)

    ; 创建一个文件路径，保存为与脚本相同目录下的 WindowRecords_时间戳.txt 文件
    FilePath := A_ScriptDir . "\WindowRecords_" . CurrentTime . ".txt"
    
    ; 打开文件用于写入（覆盖方式）
    File := FileOpen(FilePath, "w")
    
    if !File {
        MsgBox "无法创建文件 " FilePath
        return
    }
    
    ; 写入所有窗口记录
    for record in WindowTitles {
        ; 格式化每条记录的时间为12小时制
        FormattedTime := FormatTime(record.Time, "h:mm tt")
        File.WriteLine(record.Title . " - 时间戳: " . FormattedTime)
    }
    
    File.Close()
    
    ; 通知用户导出成功
    MsgBox "窗口记录已导出到 " FilePath
}

Return
