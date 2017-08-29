#! /system/bin/sh
#--20.07.2017 created by Hendriyawan (mr_silent)
#~Contact me :
#~Fb : www.facebook.com/hendri.glanex
#~Fb group : M.A.I.R
#~Email : hendrijs44@gmail.com
#~ Blog : www.gdevnet.blogspot.com

#~Sebenarnya script ini adalah my_tool.sh cuma di tulis ulang :)
#WARNING ! jika ingin recode atau ambil ide atai apapun dari scrip ini harap lapor ke saya & cantumkan credits
#~Fungsi : flashing tanpa rootext TWRP & banyak lagi
#-- colors --#
R='\e[1;31m' #RED
G='\e[1;32m' #GREEN
B='\e[1;34m' #BLUE
Y='\e[1;33m' #YELLOW
C='\e[1;36m' #CYAN
L='\e[1;38;5;228m' #LIME
HB='\e[1;38;5;32m' #HOLO BLUE
D='\e[0m' #DEFAULT

str=`for i in /mnt/storage /sdcard /storage/emulated/legacy /storage/emulated/0 /storage/sdcard0 /storage/sdcard1 /ext_storage; do [ -d $i ] && echo $i && break; done`
# set window title
function setWindow_title(){
    title="$*"
    echo -en "\e]0;$title\007"
}
# menu
function menu(){
    number="$1"
    title_menu="$2"
    echo "\t$number) $title_menu"
}
# dialog
function dialog(){
    mesg="$*"
    echo -n "${B}[*]${D} $mesg"
}
# procces console
function proc(){
    mesg="$*"
    echo -e "${B}[*]${D} $mesg"
}
# procces if success
function proc_succes(){
    mesg="$*"
    echo -e "${G}[+]${D} $mesg"
}
# procces error
function error(){
    mesg="$*"
    echo -e "${R}[-]${D} $mesg"
}
function laporkan(){
    echo -e "${B}[*]${D} laporkan bug ke www.fb.com/hendri.glanex atau kirim email ke hendrijs44@gmail.com\n"
    
}
# banner
function banner(){
    clear
    setWindow_title "O-TOOL"
    echo ""
    echo -e "${G}   %=,_          _,=%${D}"
    echo -e "${G}   ,\*?&&&&&&&&&&?*/,   ${L}OPREKER TOOL${D}"
    echo -e "${G}   &&&&${R}*${G}&&&&&&&&${R}*${G}&&&&   ${D}(c) GDEV 2017 by ${HB}Hendriyawan${D}"
    echo -e "${G}  &&&&&&&&&&&&&&&&&&&&${D}  Contact me :"
    echo -e "${G}  &&&&&&&&&&&&&&&&&&&&${D}  * ${HB}https://fb.com/hendri.glanex${D}"
    echo -e "${G}  &&&&&&&&&&&&&&&&&&&&${D}  * ${HB}hendrijs44@gmail.com${D}"
    echo ""
}
# install applet
function install_applet(){
    if [ "$(which zip)" == "" ]; then
        banner
        error "applet zip tidak ditemukan !"; sleep 3
        proc "menginstall applet zip..."; sleep 3
        proc "mempersiapkan..."; sleep 3
        busybox mount -o remount, rw /system
        if [ ! -f $str/O-TOOL/zip ]; then
            error "file $str/O-TOOL/zip tidak ditemukan, harap di cek!"
            laporkan
            exit 1
        else
            proc "sedang menginstall..."; sleep 3
            busybox mv $str/O-TOOL/zip /system/bin
            busybox chmod 0735 /system/bin/zip
            if [ $? -eq 0 ]; then
                proc_succes "install selesai !"
                proc "jalankan ulang script !"
                laporkan
                exit 0
            else
                error "install gagal !"
                laporkan
                exit 1
            fi
        fi
    fi
}
#framework tool
function framework_tool(){
    setWindow_title "FRAMEWORK TOOL"
    PATH_FW=$str/O-TOOL/FRAMEWORK
    cd $PATH_FW
    busybox mount -o remount,rw /system
    
    cur=`dirname $0`
    for dir in $cur/*; do
        if [ ! -d $dir ]; then
            error "folder FRAMEWORK kosong !"
            laporkan
            exit 1
        fi
        if [ -d $dir ]; then
            fw_dir=$(basename $dir)
            proc_succes "folder ketemu : $fw_dir"; sleep 3
            apk=apk
            if [ -f /system/framework/$fw_dir ]; then
                apk=/system/framework/$fw_dir
            fi
            if [ "$apk" != "apk" ]; then
                proc_succes "file : $apk  !"; sleep 3
                proc "harap tunggu..."; sleep 3
                cd $cur/*
                zip -r $apk * 2>&1
                busybox chmod 0644 $apk
                if [ $? -eq 0 ]; then
                    proc_succes "selesai...!"
                    dialog "reboot android? [y/n] : "
                    read reboot
                    if [ "$reboot" == "y" ] || [ "$reboot" == "Y" ]; then
                        proc "sedang reboot..."; sleep 3
                        reboot
                    else
                        laporkan
                        exit 0
                    fi
                    exit 0
                else
                    error "gagal !"
                    laporkan
                    exit 1
                fi
            else
                error "tidak ditemukan : $fw_dir !"
                laporkan
                exit 1
            fi
        else
            error "folder tidak ditemukan : $fw_dir !"
            laporkan
            exit 1
        fi
    done
}

# system app tool
function system_app_tool() {
    setWindow_title "SYSTEM APP TOOL"
    PATH_SYSAPP=$str/O-TOOL/SYSTEM_APP
    cd $PATH_SYSAPP
    busybox mount -o remount,rw /system
    
    cur=`dirname $0`
    for dir in $cur/*; do
        if [ ! -d $dir ]; then
            error "folder SYSTEM_APP kosong !"
            laporkan
            exit 1
        fi
        if [ -d $dir ]; then
            apk_dir=$(basename $dir)
            proc_succes "folder ketemu : $apk_dir"; sleep 3
            apk=apk
            if [ -f /system/app/$apk_dir ]; then
                apk=/system/app/$apk_dir
            fi
            if [ -f /system/app/*/$apk_dir ]; then
                apk=/system/app/*/$apk_dir
            fi
            if [ -f /system/priv-app/$apk_dir ]; then
                apk=/system/priv-app/$apk_dir
            fi
            if [ -f /system/priv-app/*/$apk_dir ]; then
                apk=/system/priv-app/*/$apk_dir
            fi
            if [ "$apk" != "apk" ]; then
                proc_succes "file : $apk !"; sleep 3
                proc "harap tunggu..."; sleep 3
                cd $cur/*
                zip -r $apk * 2>&1
                busybox chmod 0644 $apk
                if [ $? -eq 0 ]; then
                    proc_succes "selesai !"
                    dialog "reboot android? [y/n] : "
                    read reboot
                    if [ "$reboot" == "y" ] || [ "$reboot" == "Y" ]; then
                        proc "sedang reboot..."; sleep 3
                        reboot
                    else
                        laporkan
                        exit 0
                    fi
                    exit 0
                else
                    error "gagal !"
                    laporkan
                    exit 1
                fi
            else
                error "tidak ditemukan : $apk_dir !"
                laporkan
                exit 1
            fi
        else
            error "folder tidak ditemukan : $apk_dir !"
            laporkan
            exit 1
        fi
    done               
}
# bootanimation tool
function bootanimation_tool() {
    setWindow_title "BOOTANIMATION TOOL"
    PATH_BOOTANIM=$str/O-TOOL/BOOTANIMATION
    cd $PATH_BOOTANIM
    busybox mount -o remount, rw /system
    
    cur=`dirname $0`
    for dir in $cur/*; do
        if [ ! -d $dir ]; then
            error "folder BOOTANIMATION kosong !"
            laporkan
            exit 1
        fi
        if [ -d $dir ]; then
            bootanim_dir=$(basename $dir)
            proc_succes "folder ketemu : $bootanim_dir !"; sleep 3
            bootanim_file=bootanim_file
            if [ -f /system/media/$bootanim_dir ]; then
                bootanim_file=/system/media/$bootanim_dir
            fi
            if [ "$bootanim_file" != "bootanim_file" ]; then
                proc_succes "file : $bootanim_file !"; sleep 3
                cd $cur/*
                zip -r $bootanim_file * 2>&1
                busybox chmod 0644 $bootanim_file
                if [ $? -eq 0 ]; then
                    proc_succes "selesai !"
                    dialog "reboot android? [y/n] : "
                    read reboot
                    if [ "$reboot" == "y" ] || [ "$reboot" == "Y" ]; then
                        proc "sedang reboot..."; sleep 3
                        reboot
                    else
                        laporkan
                        exit 0
                    fi
                    exit 0
                else
                    error "gagal !"
                    laporkan
                    exit 1
                fi
            else
                error "tidak ditemukan : $bootanim_dir !"
                laporkan
                exit 1
            fi
        else
            error "folder tidak ditemukan : $bootanim_dir !"
            laporkan
            exit 1
        fi
    done
}
# main
function main(){
    banner
    menu "1" "Framework"
    menu "2" "System App"
    menu "3" "Bootanimation"
    menu "99" "Keluar"
    echo ""
    dialog "pilih menu tool : "
    read menu
    if [ -z $menu ]; then
        error "pilihan menu tidak di masukan !\n"
        exit 1
    fi
    case $menu in
        "1") framework_tool ;;
        "2") system_app_tool ;;
        "3") bootanimation_tool ;;
        "99") proc "Keluar...\n" ; sleep 3; exit 0;;
        *) error "pilihan menu tidak tersedia !\n"; exit 0 ;;
    esac
}
if [ $(busybox id -u) -ne 0 ]; then
    banner
    error "script ini butuh akses root !"
    error "ketik su dan jalankan ulang script ini :)\n"
    exit 1
fi
install_applet
main