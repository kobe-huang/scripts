#!/bin/bash
#自动更新代码，并保留备份
#kobe update 20160922
#!/bin/bash
# Author:  kobe <kobe.huang AT temaiol.com>

wwwroot_dir=/data/wwwroot/             #网站的根目录
patch_dir=/mnt/ftp_dir/patch           #patch存放的目录
patch_prefix_dir=patch_                #patch的命名的前缀
expired_days=2
website_name=sltx.techouol.com/addons/sltx_techouol  #要同步的网站,以逗号做分隔

log_file=/mnt/ftp_dir/patch/update.log  #log文件
patch_file_list=update.txt              #记录文件
backup_patch_dir=/mnt/patch_bak         #log的备份位置
patch_merge_dir=
prefix_same_name_begin=_begin_          #防止同名的文件或文件夹，加上一个前缀
prefix_same_name_end=_end_				#防止同名的文件或文件夹，加上一个后缀

postfix_dir_str=".mydir"                #文件夹后缀


echo "+++Enter auto_update process+++"

#检测环境
 check_environment() {
	#检测patch文件夹是否存在
	echo "check_environment"
	if [ -d $patch_dir ]; then
		echo "patch file dir exsit"
	else
		echo "mkdir patch file dir"
		mkdir -p $patch_dir   #建立patch目录
		if [ 0 != $? ]; then
			echo "error：  create $patch_dir fail"
			exit 1;
		fi
	fi
	chown -R www:www $patch_dir

	#检测log文件是否存在
	if [ -e $log_file ];then
		echo "exist log_file"
    else
    	echo "init log_file"
    	touch $log_file
    	if [ 0 != $? ]; then
			echo "create $log_file fail"
			exit 1;
		fi       
    fi

	#创建patch 备份的目录
	[ ! -d $backup_patch_dir ] && mkdir -p $backup_patch_dir  # &&{ echo "create $backup_patch_dir fail"; exit 1; }

    #检查patch合入的路径
    echo "check_environment $website_name"
	for W in `echo $website_name | tr ',' ' '`
    do
        if [ ! -d ${wwwroot_dir}${W} ]; then
        	echo "error：  No $wwwroot_dir$W directory "
        	exit 1
        fi
    done
}


#检查patch是否符合要求
check_patch() {
	yesterday=`date -d "1 days ago" +%Y%m%d `  #昨天的时间 格式：20160606
	echo $yesterday
#	patch_now=`find $patch_dir -name ${patch_prefix_dir}"_"${yesterday} | head -n 1`
    echo "${patch_prefix_dir}${yesterday}/$patch_file_list"
	[ ! -d ${patch_dir}/${patch_prefix_dir}${yesterday} ]&&{ echo "error： not patch" ; exit 1;}		
	[ ! -e ${patch_dir}/${patch_prefix_dir}${yesterday}/$patch_file_list ]&&{ echo "error： not update.txt" ; exit 1;}
	
	patch_merge_dir=${patch_dir}/${patch_prefix_dir}${yesterday}  #绝对路径
	echo "check_patch  $patch_merge_dir"
}

#开始合入代码
start_merge() {
	merge_file_list=$1;
	prefix_des_dir=$2;
	prefix_res_path=$(dirname $merge_file_list);
  
    echo "start_merge $merge_file_list  $prefix_des_dir  $prefix_res_path "
	cat $merge_file_list | while read my_line; 
	do
		echo "++++++myfile = $my_line"
		if [ -n "$my_line" ];then                    #防止读出来的换行符
			res_file=$(basename $my_line);           #得到要处理的文件		
			ture_file=`echo $res_file | sed -n "s/$prefix_same_name_begin.*$prefix_same_name_end//;p"`
			res_path=$(dirname $my_line);

			[ ! -d $prefix_des_dir/$res_path ]&& mkdir -p $prefix_des_dir/$res_path         #如果文件夹不存在
			

			if [[ $ture_file =~ $postfix_dir_str ]];then
				true_dir=`echo $ture_file | sed -n "s/$postfix_dir_str//;p"`
				echo -e "$prefix_res_path/$res_file   -->   $prefix_des_dir$res_path/$true_dir  directory" |tee -a $log_file
				[ $(cp -rf $prefix_res_path/$res_file $prefix_des_dir$res_path/$true_dir) ] && { echo "error： cp $res_file" ; exit 1; }
			else
				echo -e "$prefix_res_path/$res_file   -->   $prefix_des_dir$res_path/$ture_file" |tee -a $log_file
				[ $(cp -f $prefix_res_path/$res_file $prefix_des_dir$res_path/$ture_file) ] && { echo "error： cp $res_file" ; exit 1; }
			fi
		fi
	done
	chown -R www:www $prefix_des_dir
}


#合入patch
merge_patch() {
	echo 'Enter merge_patch'
	check_environment
	check_patch
#	now_date=`date -d "now"  +%Y-%m-%d`
    now_date=$(date '+%Y-%m-%d %H:%M:%S')
	echo -e "\n\n+++++start+++++   "${now_date}"  merge patch" |tee -a $log_file
	cp -rf $patch_merge_dir  $backup_patch_dir  #先做备份

    for W in `echo $website_name | tr ',' ' '`
    do
		start_merge $patch_merge_dir/$patch_file_list  ${wwwroot_dir}${W} ;
    done
}

#main，入口cd /
echo -e "\r\n+++main enter update+++"
cd /
merge_patch
cd -
echo -e "++++update success++++ \r\n" |tee -a $log_file

