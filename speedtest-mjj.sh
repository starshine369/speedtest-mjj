#!/bin/bash
# ==========================================
# Speedtest 热门测速节点雷达 (MJJ 联动开火版)
# Author: starshine369
# GitHub: https://github.com/starshine369/speedtest-mjj
# ==========================================

# 颜色定义
GREEN="\033[32m"
YELLOW="\033[33m"
CYAN="\033[36m"
RED="\033[31m"
RESET="\033[0m"

# 1. 自动检测并安装 Ookla Speedtest 官方版
install_speedtest() {
    echo -e "${YELLOW}[*] 未检测到官方 Speedtest CLI，正在自动为 MJJ 部署纯净版...${RESET}"
    
    # 检测架构
    ARCH=$(uname -m)
    if [[ "$ARCH" == "x86_64" ]]; then
        DL_URL="https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-x86_64.tgz"
    elif [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
        DL_URL="https://install.speedtest.net/app/cli/ookla-speedtest-1.2.0-linux-aarch64.tgz"
    else
        echo -e "${RED}[!] 不支持的架构: $ARCH，请手动安装。${RESET}"
        exit 1
    fi

    # 执行免依赖绿色安装逻辑
    wget -q -O speedtest.tgz "$DL_URL"
    tar -zxvf speedtest.tgz speedtest >/dev/null 2>&1
    
    if [ "$EUID" -ne 0 ]; then
        sudo mv speedtest /usr/local/bin/
    else
        mv speedtest /usr/local/bin/
    fi
    
    rm -f speedtest.tgz speedtest.md5 speedtest.5
    
    # 自动同意用户协议，拔剑即战
    speedtest --accept-license --accept-gdpr >/dev/null 2>&1
    
    echo -e "${GREEN}[OK] Speedtest CLI (版本 $(speedtest --version | awk 'NR==1{print $3}')) 装备成功！${RESET}\n"
}

# 检查环境
if ! command -v speedtest &> /dev/null; then
    install_speedtest
fi

# 2. 交互式节点雷达菜单
while true; do
    clear
    echo -e "${CYAN}======================================${RESET}"
    echo -e "      ${YELLOW}[*] MJJ 专属全球测速雷达 [*]${RESET}"
    echo -e "${CYAN}======================================${RESET}"
    echo "请选择要扫描的地区 (输入数字并回车):"
    echo ""
    echo -e " ${YELLOW}--- [AMERICA] 美洲赛区 ---${RESET}"
    echo "  1.  [US] 洛杉矶 (Los Angeles)    - 美西主力"
    echo "  2.  [US] 西雅图 (Seattle)        - 跨洋前线"
    echo "  3.  [US] 圣何塞 (San Jose)       - 硅谷核心"
    echo "  4.  [US] 达拉斯 (Dallas)         - 美中枢纽"
    echo "  5.  [US] 盐湖城 (Salt Lake City) - 西部腹地"
    echo ""
    echo -e " ${YELLOW}--- [ASIA-PAC] 亚太赛区 ---${RESET}"
    echo "  6.  [HK] 香港 (Hong Kong)        - 直连枢纽"
    echo "  7.  [JP] 东京 (Tokyo)            - 亚太跳板"
    echo "  8.  [KR] 首尔 (Seoul)            - 韩国节点"
    echo "  9.  [SG] 新加坡 (Singapore)      - 东南亚出口"
    echo ""
    echo -e " ${YELLOW}--- [EU/AU] 欧澳赛区 ---${RESET}"
    echo "  10. [DE] 法兰克福 (Frankfurt)    - 欧洲核心"
    echo "  11. [UK] 伦敦 (London)           - 欧洲节点"
    echo "  12. [AU] 悉尼 (Sydney)           - 澳洲枢纽"
    echo ""
    echo -e " ${YELLOW}--- [SEARCH] 动态嗅探 ---${RESET}"
    echo "  13. [?] 自定义搜索 (手动输入城市英文)"
    echo "  0.  [X] 退出"
    echo -e "${CYAN}======================================${RESET}"

    read -p "[>] 请输入您的选择 [0-13]: " choice

    case $choice in
        1) CITY="Los Angeles" ;;
        2) CITY="Seattle" ;;
        3) CITY="San Jose" ;;
        4) CITY="Dallas" ;;
        5) CITY="Salt Lake City" ;;
        6) CITY="Hong Kong" ;;
        7) CITY="Tokyo" ;;
        8) CITY="Seoul" ;;
        9) CITY="Singapore" ;;
        10) CITY="Frankfurt" ;;
        11) CITY="London" ;;
        12) CITY="Sydney" ;;
        13) 
           echo ""
           read -p "[>] 请输入目标城市 (如 New York 或 Paris): " custom_city
           CITY="$custom_city"
           ;;
        0) echo -e "\n${GREEN}[OK] 已退出雷达系统。祝您的探针永远全绿！${RESET}\n"; exit 0 ;;
        *) echo -e "\n${RED}[!] 无效选项，请按回车键重新输入。${RESET}"; read; continue ;;
    esac

    echo -e "\n[*] 正在雷达扫描 ${GREEN}$CITY${RESET} 的可用节点，请稍候...\n"

    # API 抓取与排版核心 (带 Unicode 净化防乱码机制)
    curl -s "https://www.speedtest.net/api/js/servers?search=$(echo $CITY | sed 's/ /%20/g')" | \
    sed 's/},{/\n/g' | \
    sed 's/\\u[0-9a-fA-F]\{4\}//g' | \
    awk -F'"' 'BEGIN {printf "%-8s | %-35s | %s\n", "节点 ID", "赞助商 (机房 / 运营商)", "物理位置"; print "---------|-------------------------------------|-----------------"} {id=""; sp=""; nm=""; for(i=1;i<=NF;i++){if($i=="id"){id=$(i+2)}; if($i=="sponsor"){sp=$(i+2)}; if($i=="name"){nm=$(i+2)}}; if(id!="") printf "%-8s | %-35s | %s\n", id, sp, nm}'

    echo -e "\n${GREEN}[OK] 扫描完成！${RESET}"
    echo -e "${CYAN}======================================${RESET}"
    
    # 联动测速核心逻辑
    read -p "[>] 请输入要测速的节点 ID (直接回车返回主菜单): " target_node
    
    if [[ -n "$target_node" ]]; then
        # 正则表达式验证输入是否为纯数字
        if [[ "$target_node" =~ ^[0-9]+$ ]]; then
            echo -e "\n[*] [>>>] 正在连接节点 ${CYAN}${target_node}${RESET} 进行极限测速，请系好安全带...\n"
            speedtest -s "$target_node"
        else
            echo -e "\n${RED}[!] 节点 ID 格式错误，只能输入纯数字！${RESET}"
        fi
    fi

    echo ""
    read -p "按回车键返回主菜单..."
done