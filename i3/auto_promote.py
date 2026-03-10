#!/usr/bin/env python3
"""
当某个容器(parent)只剩下一个子窗口时，把该子窗口提升到 parent 的父容器 (grandparent) 下。
使用方法：pip install i3ipc
在 i3 config 中加入：
    exec_always --no-startup-id ~/.config/i3/auto_promote.py
"""
import i3ipc
import uuid
import time

i3 = i3ipc.Connection()


def promote_to_grandparent(con):
    """
    把容器 con 提升到它父容器的父容器下（使用 mark+move 的方式，不切换焦点）。
    con: i3ipc.con (通常是叶子节点，即窗口对应的容器)
    """
    parent = con.parent
    if parent is None:
        return
    # 只处理父容器恰好只有一个子节点的情况
    if len(parent.nodes) != 1:
        return
    grand = parent.parent
    if grand is None:
        # 没有更高的父容器（非常罕见），直接返回
        return

    mark = '__promote_' + uuid.uuid4().hex
    try:
        # 在 grandparent 上打 mark
        i3.command(f'[con_id={grand.id}] mark --add {mark}')
        # 把目标容器（con）移动到带有该 mark 的容器下
        i3.command(f'[con_id={con.id}] move container to mark {mark}')
        # 小睡一下保证 i3 处理完命令，再删除 mark
        time.sleep(0.03)
        i3.command(f'unmark {mark}')
    except Exception as e:
        # 简单打印错误以便调试（日志可以改为写文件）
        print('promote_to_grandparent failed:', e)


def on_window_close(i3_conn, event):
    # 等 i3 稍微稳定（确保 tree 已更新）
    time.sleep(0.05)
    tree = i3_conn.get_tree()
    # 遍历所有叶子窗口，检查其父容器是否只剩一个子节点
    for leaf in tree.leaves():
        parent = leaf.parent
        if parent is None:
            continue
        if len(parent.nodes) == 1:
            promote_to_grandparent(leaf)


if __name__ == '__main__':
    i3.on('window::close', on_window_close)
    i3.main()
