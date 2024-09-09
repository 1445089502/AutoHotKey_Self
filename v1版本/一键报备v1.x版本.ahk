; 定义全局变量用于存储窗口标题记录及时间戳
WindowTitles := []

; 创建一个 GUI 窗口和按钮，并允许窗口移动和最小化
Gui, +AlwaysOnTop +Resize
Gui, Add, Button, gShowActiveWindows, 显示过去一分钟内的频率最高窗口
Gui, Add, Button, gExportToFile, 导出所有窗口记录到TXT
Gui, Show

; 定义计时器，每 5 秒钟记录一次活动窗口状态
SetTimer, RecordActiveWindow, 5000
Return

RecordActiveWindow:
    ; 获取当前活动窗口的标题和对应的程序名称
    WinGetTitle, ActiveTitle, A
    if (ActiveTitle = "")
    {
        ActiveTitle := "无标题窗口" ; 如果窗口没有标题，给予一个默认值
    }
    WinGet, ActiveApp, ProcessName, A
    CurrentTime := A_TickCount

    ; 将窗口标题和程序名称组合存入数组中
    FullTitle := ActiveApp . ": " . ActiveTitle
    WindowTitles.Push({Title: FullTitle, Time: CurrentTime})

Return

ShowActiveWindows:
    ; 获取当前时间戳
    Now := A_TickCount
    RecentTitles := []
    UniqueTitles := {}

    ; 遍历记录并获取最近一分钟内的窗口标题
    for each, record in WindowTitles
    {
        if (Now - record.Time <= 60000)
            RecentTitles.Push(record.Title)
    }

    ; 去除重复的窗口标题
    for each, title in RecentTitles
    {
        if (!UniqueTitles.HasKey(title))
            UniqueTitles[title] := 1
    }

    ; 获取最高频率窗口
    MaxFrequency := 0
    MaxTitle := ""
    FreqMap := {}
    for title, _ in UniqueTitles
    {
        ; 遍历记录统计频率
        FreqMap[title] := 0
        for each, record in WindowTitles
        {
            if (record.Title = title)
                FreqMap[title]++
        }

        if (FreqMap[title] > MaxFrequency)
        {
            MaxFrequency := FreqMap[title]
            MaxTitle := title
        }
    }

    ; 使用for循环逐个输出窗口标题
    AllTitles := ""
    for title, _ in UniqueTitles
    {
        AllTitles .= title . "`n"  ; 逐行拼接每个窗口标题
    }

    ; 显示最高频率窗口及去重的窗口列表
    if (MaxFrequency > 0)
    {
        MsgBox, 64, 统计结果, % "过去一分钟内频率最高的窗口:`n" MaxTitle " (出现 " MaxFrequency " 次)。`n`n所有窗口记录:`n" . AllTitles
    }
    else
    {
        MsgBox, 64, 信息, "过去一分钟没有窗口记录。"
    }

Return

ExportToFile:
    ; 获取当前时间，格式为 yyyy-MM-dd_HH-mm-ss
    FormatTime, CurrentTime, , yyyy-MM-dd_HH-mm-ss

    ; 创建一个文件路径，保存为与脚本相同目录下的 WindowRecords_时间戳.txt 文件
    FilePath := A_ScriptDir . "\WindowRecords_" . CurrentTime . ".txt"

    ; 打开文件以写入模式
    File := FileOpen(FilePath, "w")
    if !File
    {
        MsgBox, 48, 错误, "无法创建或打开文件！"
        Return
    }

    ; 写入所有窗口记录
    for each, record in WindowTitles
    {
        ; 格式化每一行：时间戳 + 窗口标题
        File.WriteLine(Format("{1:0} ms: {2}", record.Time, record.Title))
    }

    ; 关闭文件
    File.Close()

    MsgBox, 64, 导出成功, "窗口记录已成功导出到 " . FilePath

Return
