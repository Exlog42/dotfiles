# i3 配置扩展说明

## command_scratchpad.py

`command_scratchpad.py` 用于给每一条“启动命令”创建独立的 i3 暂存区（scratchpad 分桶）。

### 目标

- 同一命令（如 `pavucontrol`）只会操作自己的隐藏窗口。
- 不同命令互不影响，不再和全局 `scratchpad show` 混用轮询。

### 脚本位置

- `~/.config/i3/command_scratchpad.py`

### 依赖

- `python3`
- `i3-msg`（随 i3 安装）

### 用法

```bash
python3 ~/.config/i3/command_scratchpad.py toggle 'alacritty --class scratch-term'
python3 ~/.config/i3/command_scratchpad.py show 'alacritty --class scratch-term'
python3 ~/.config/i3/command_scratchpad.py hide 'alacritty --class scratch-term'
```

- `toggle`：默认动作，窗口存在则显示/隐藏，不存在则启动并纳入该命令专属暂存区。
- `show`：仅显示该命令专属暂存区窗口。
- `hide`：仅隐藏该命令专属暂存区窗口。

### 在 i3 中绑定快捷键（示例）

```i3
bindsym $mod+F2 exec --no-startup-id python3 ~/.config/i3/command_scratchpad.py toggle 'alacritty --class scratch-term'
bindsym $mod+F3 exec --no-startup-id python3 ~/.config/i3/command_scratchpad.py toggle 'pavucontrol'
```

改完 `config` 后执行重载：

```bash
i3-msg reload
```
