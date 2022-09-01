#!/bin/bash
# ═══════════════════════════════════════════════════════════════════
# (C) Copyright 2022 Oleh KaizenVPN
# ═══════════════════════════════════════════════════════════════════
# Nama        : Autoskrip VPN
# Info        : Memasang pelbagai jenis servis vpn didalam satu skrip
# Dibuat Pada : 30-08-2022 ( 30 Ogos 2022 )
# OS Support  : Ubuntu & Debian
# Owner       : KaizenVPN
# Telegram    : https://t.me/KaizenA
# Github      : github.com/rewasu91
# ═══════════════════════════════════════════════════════════════════

dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

# ══════════════════════════
# // Export Warna & Maklumat
# ══════════════════════════
export RED='\033[1;91m';
export GREEN='\033[1;92m';
export YELLOW='\033[1;93m';
export BLUE='\033[1;94m';
export PURPLE='\033[1;95m';
export CYAN='\033[1;96m';
export LIGHT='\033[1;97m';
export NC='\033[0m';

# ════════════════════════════════
# // Export Maklumat Status Banner
# ════════════════════════════════
export ERROR="[${RED} ERROR ${NC}]";
export INFO="[${YELLOW} INFO ${NC}]";
export OKEY="[${GREEN} OKEY ${NC}]";
export PENDING="[${YELLOW} PENDING ${NC}]";
export SEND="[${YELLOW} SEND ${NC}]";
export RECEIVE="[${YELLOW} RECEIVE ${NC}]";
export REDBG='\e[41m';
export WBBG='\e[1;47;30m';

# ═══════════════
# // Export Align
# ═══════════════
export BOLD="\e[1m";
export WARNING="${RED}\e[5m";
export UNDERLINE="\e[4m";

# ════════════════════════════
# // Export Maklumat Sistem OS
# ════════════════════════════
export OS_ID=$( cat /etc/os-release | grep -w ID | sed 's/ID//g' | sed 's/=//g' | sed 's/ //g' );
export OS_VERSION=$( cat /etc/os-release | grep -w VERSION_ID | sed 's/VERSION_ID//g' | sed 's/=//g' | sed 's/ //g' | sed 's/"//g' );
export OS_NAME=$( cat /etc/os-release | grep -w PRETTY_NAME | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' );
export OS_KERNEL=$( uname -r );
export OS_ARCH=$( uname -m );

# ═══════════════════════════════════
# // String Untuk Membantu Pemasangan
# ═══════════════════════════════════
export VERSION="1.0";
export EDITION="Stable";
export AUTHER="KaizenVPN";
export ROOT_DIRECTORY="/etc/kaizenvpn";
export CORE_DIRECTORY="/usr/local/kaizenvpn";
export SERVICE_DIRECTORY="/etc/systemd/system";
export SCRIPT_SETUP_URL="https://raw.githubusercontent.com/rewasu91/scvps/main/setup.sh";
export REPO_URL="https://github.com/rewasu91/scvps";

# ═══════════════
# // Allow Access
# ═══════════════
BURIQ () {
    curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access > /root/tmp
    data=( `cat /root/tmp | grep -E "^### " | awk '{print $2}'` )
    for user in "${data[@]}"
    do
    exp=( `grep -E "^### $user" "/root/tmp" | awk '{print $3}'` )
    d1=(`date -d "$exp" +%s`)
    d2=(`date -d "$biji" +%s`)
    exp2=$(( (d1 - d2) / 86400 ))
    if [[ "$exp2" -le "0" ]]; then
    echo $user > /etc/.$user.ini
    else
    rm -f  /etc/.$user.ini > /dev/null 2>&1
    fi
    done
    rm -f  /root/tmp
}
# https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access
MYIP=$(curl -sS ipv4.icanhazip.com)
Name=$(curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access | grep $MYIP | awk '{print $2}')
echo $Name > /usr/local/etc/.$Name.ini
CekOne=$(cat /usr/local/etc/.$Name.ini)
Bloman () {
if [ -f "/etc/.$Name.ini" ]; then
CekTwo=$(cat /etc/.$Name.ini)
    if [ "$CekOne" = "$CekTwo" ]; then
        res="Expired"
    fi
else
res="Permission Accepted..."
fi
}
PERMISSION () {
    MYIP=$(curl -sS ipv4.icanhazip.com)
    IZIN=$(curl -sS https://raw.githubusercontent.com/rewasu91/scvpssettings/main/access | awk '{print $4}' | grep $MYIP)
    if [ "$MYIP" = "$IZIN" ]; then
    Bloman
    else
    res="Permission Denied!"
    fi
    BURIQ
}
PERMISSION
if [ "$res" = "Permission Accepted..." ]; then
echo -ne
else
echo -e "${ERROR} Permission Denied!";
exit 0
fi

# ═════════════════════════════════════════════════════════
# // Semak kalau anda sudah running sebagai root atau belum
# ═════════════════════════════════════════════════════════
if [[ "${EUID}" -ne 0 ]]; then
		echo -e " ${ERROR} Sila jalankan skrip ini sebagai root user";
		exit 1
fi

# ════════════════════════════════════════════════════════════
# // Menyemak sistem sekiranya terdapat pemasangan yang kurang
# ════════════════════════════════════════════════════════════
if ! which jq > /dev/null; then
    clear;
    echo -e "${ERROR} JQ Packages Not installed";
    exit 1;
fi

# ═══════════════════════════════
# // Exporting maklumat rangkaian
# ═══════════════════════════════
wget -qO- --inet4-only 'https://raw.githubusercontent.com/rewasu91/scvpssettings/main/get-ip_sh' | bash;
source /root/ip-detail.txt;
export IP_NYA="$IP";
export ASN_NYA="$ASN";
export ISP_NYA="$ISP";
export REGION_NYA="$REGION";
export CITY_NYA="$CITY";
export COUNTRY_NYA="$COUNTRY";
export TIME_NYA="$TIMEZONE";

# ══════════════════
# // Pilih Protocols
# ══════════════════
clear;
echo "";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "${WBBG}           [ Menu ShadowsocksR ]            ${NC}";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "";
echo -e " ${CYAN}Pilih Protocols${NC}";
echo -e " ${GREEN}[ 01 ]${NC} ► origin";
echo -e " ${GREEN}[ 02 ]${NC} ► auth_sha1";
echo -e " ${GREEN}[ 03 ]${NC} ► auth_sha1_v2";
echo -e " ${GREEN}[ 04 ]${NC} ► auth_sha1_v4";
echo "";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
read -p "► Sila masukkan nombor pilihan anda [1-4] : " choose_protocols;

case $choose_protocols in
    1) # Origin
        Protocols="origin";
    ;;
    2) # auth_sha1
        Protocols="auth_sha1";
    ;;
    3) # auth_sha1_v2
        Protocols="auth_sha1_v2";
    ;;
    4) # auth_sha1_v4
        Protocols="auth_sha1_v4";
    ;;
    *) # No Choose
        clear;
        echo -e "${ERROR} Sila pilih salah satu protocols !";
        exit 1;
    ;;
esac

# ════════════════════
# // Pilih Obfs
# ════════════════════
clear;
echo "";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "${WBBG}           [ Menu ShadowsocksR ]            ${NC}";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
echo -e "";
echo -e " ${CYAN}Pilih OBFS${NC}";
echo -e " ${GREEN}[ 01 ]${NC} ► plain";
echo -e " ${GREEN}[ 02 ]${NC} ► http_simple";
echo -e " ${GREEN}[ 03 ]${NC} ► http_post";
echo -e " ${GREEN}[ 04 ]${NC} ► tls_simple";
echo -e " ${GREEN}[ 05 ]${NC} ► tls1.2_ticket_auth";
echo "";
echo -e "${CYAN}════════════════════════════════════════════${NC}";
read -p "► Sila masukkan nombor pilihan anda [1-5] : " choose_obfs;

case $choose_obfs in
    1) # plain
        obfs="plain";
    ;;
    2) # http_simple
        obfs="http_simple";
    ;;
    3) # http_post
        obfs="http_post";
    ;;
    4) # tls_simple
        obfs="tls_simple";
    ;;
    5) # tls1.2_ticket_auth_compatible
        obfs="tls1.2_ticket_auth_compatible";
    ;;
    *) # No Choose
        clear;
        echo -e "${ERROR} Sila pilih salah satu obfs !";
        exit 1;
    ;;
esac

clear;

read -p "► Sila masukkan Username   : " Username;
Username="$(echo ${Username} | sed 's/ //g' | tr -d '\r')";

touch /etc/kaizenvpn/ssr-client.conf
if [[ $Username == "$( cat /etc/kaizenvpn/ssr-client.conf | grep -w $Username | head -n1 | awk '{print $2}' )" ]]; then
clear;
echo -e "${ERROR} Account With ( ${YELLOW}$Username ${NC}) sudah dipakai !";
exit 1;
fi
Domain=$( cat /etc/kaizenvpn/domain.txt );

read -p "► Sila masukkan jumlah max login untuk ID ini: " max_log;
if [[ $max_log == "" ]]; then
    clear;
    echo -e "${ERROR} Sila masukkan jumlah max login untuk ID ini !";
    exit 1;
fi
read -p "► Sila masukkan Tempoh Aktif (hari)    : " Jumlah_Hari;
clear;
echo "═══════════════════════════════════════════════════";
echo " Sila tekan [ ENTER ] to mematikan limit bandwith";
echo " Limit bandwidth dikira dalam Giga Bytes";
echo " Contohnya | Limit 1TB Bandwidth, sila taip 1024";
echo "═══════════════════════════════════════════════════";
echo "";
read -p "► Sila masukkan limit bandwith, sekiranya tidak mahu limit, sila tekan ENTER : " bandwidth_allowed;

if [[ $bandwidth_allowed == "" ]]; then
    bandwidth_alloweds="Unlimited";
    bandwidth_allowed="1024000";
else
    bandwidth_alloweds="$bandwidth_allowed GB";
fi

# // Count Date
exp=`date -d "$Jumlah_Hari days" +"%Y-%m-%d"`;
hariini=`date -d "0 days" +"%Y-%m-%d"`;

# // Port Configuration
if [[ $(cat /etc/kaizenvpn/ssr-server/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 ) == "" ]]; then
Port=1200;
else
Port=$(( $(cat /etc/kaizenvpn/ssr-server/mudb.json | grep '"port": ' | tail -n1 | awk '{print $2}' | cut -d "," -f 1 | cut -d ":" -f 1 ) + 1 ));
fi

# // Adding User To Configuration
echo -e "SSR $Username $exp $Port" >> /etc/kaizenvpn/ssr-client.conf;

# // Adding User To ShadowsocksR Server
cd /etc/kaizenvpn/ssr-server/;
match_add=$(python mujson_mgr.py -a -u "${Username}" -p "${Port}" -k "${Username}" -m "aes-256-cfb" -O "${Protocols}" -G "${max_log}" -o "${obfs}" -s "0" -S "0" -t "${bandwidth_allowed}" -f "bittorrent" | grep -w "add user info");
cd;

# // Make Client Configuration Link
tmp1=$(echo -n "${Username}" | base64 -w0 | sed 's/=//g;s/\//_/g;s/+/-/g');
SSRobfs=$(echo ${obfs} | sed 's/_compatible//g');
tmp2=$(echo -n "${IP}:${Port}:${Protocols}:aes-256-cfb:${SSRobfs}:${tmp1}/obfsparam=" | base64 -w0);
ssr_link="ssr://${tmp2}";

# // Restarting Service
/etc/init.d/ssr-server restart;

# // Make Cache Folder
rm -rf /etc/kaizenvpn/ssr/${Username};
mkdir -p /etc/kaizenvpn/ssr/${Username}/

# ══════════════════════════════
# // Maklumat Akaun ShadowsocksR
# ══════════════════════════════
clear; 
echo "" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e "${WBBG}       [ Maklumat Akaun ShadowsocksR ]      ${NC}" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " Username    ► $Username" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " Password    ► $Username" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " Dibuat Pada ► ${hariini}" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " Expire Pada ► ${exp}" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " IP         = ${IP}" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " Domain     = $Domain" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " Port       = $Port" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " Protocols  = $Protocols" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " Obfs       = $obfs" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " Max Login  = $max_log Device" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " BW Limit   = $bandwidth_alloweds" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " ShadowsocksR Config Link" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e " $ssr_link" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;
echo -e "${CYAN}════════════════════════════════════════════${NC}" | tee -a /etc/kaizenvpn/ssr/${Username}/config.log;