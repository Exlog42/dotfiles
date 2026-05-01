#!/usr/bin/env bash

# 颜色定义，让输出好看一点
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}--- 开始 Arch Linux 系统清理 ---${NC}"

# 1. 清理 Pacman 缓存
# 仅保留最近 2 个版本，防止更新出 Bug 没法降级；清理已卸载包的所有缓存
echo -e "${GREEN}[1/6] 正在清理 Pacman 软件包缓存...${NC}"
sudo paccache -rk1
sudo paccache -ruk0

# 2. 清理孤立包 (Orphans)
# 寻找那些作为依赖安装但现在没人需要的包
echo -e "${GREEN}[2/6] 正在清理孤立依赖包...${NC}"
ORPHANS=$(pacman -Qdtq)
if [ -n "$ORPHANS" ]; then
    sudo pacman -Rns $ORPHANS
else
    echo "没有发现孤立包。"
fi

# 3. 清理 AUR 助手缓存 (yay/paru)
# AUR 编译产生的源码和中间文件非常吃空间
if command -v yay &> /dev/null; then
    echo -e "${GREEN}[3/6] 发现 yay，正在清理 AUR 缓存...${NC}"
    yay -Sc --noconfirm
elif command -v paru &> /dev/null; then
    echo -e "${GREEN}[3/6] 发现 paru，正在清理 AUR 缓存...${NC}"
    paru -Sc --noconfirm
fi

# 4. 清理 Systemd Journal 日志
# 仅保留最近 2 天的日志，防止 /var/log/journal 爆炸
echo -e "${GREEN}[4/6] 正在清理系统日志...${NC}"
sudo journalctl --vacuum-time=2d

# 5. 清理用户缓存 (~/.cache)
# 注意：这会删除缩略图、编译缓存等，不会删配置文件
echo -e "${GREEN}[5/6] 正在清理用户 ~/.cache 目录...${NC}"
# 这里我们选择性清理，避免误删正在运行的程序缓存
rm -rf ~/.cache/thumbnails/*
rm -rf ~/.cache/pip/*
rm -rf ~/.cache/yarn/*
rm -rf ~/.cache/electron/*

# 6. 清理 Docker（可选，因为你正在用 Docker）
# 如果你确定不需要旧镜像和停止的容器，开启下面这行
# echo -e "${GREEN}[6/6] 正在清理 Docker 冗余资源...${NC}"
docker system prune -f

echo -e "${BLUE}--- 清理完成！ ---${NC}"
# 显示当前磁盘剩余空间
df -h /
