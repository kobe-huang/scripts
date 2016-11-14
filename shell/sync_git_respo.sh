#!/bin/bash 
git_log_dir=/mnt/ftp_dir
git_log_name=/mnt/ftp_dir/b2c_git.log
git_log_detail_info=/mnt/ftp_dir/b2c_git_detail_info.log
git_log_title="begin_git_sync 开始同步:  "
git_log_success_info="begin_git_sync 同步成功"


git_log_check_env()
{
	# 这里的-d 参数判断$myPath是否存在
	if [ ! -d "$git_log_dir" ]; then
	mkdir "$git_log_dir"
	fi 
	
	# 这里的-f参数判断$myFile是否存在
	if [ ! -f "$git_log_name" ]; then
	touch "$git_log_name"
	fi

	# 这里的-f参数判断$myFile是否存在
	if [ ! -f "$git_log_detail_info" ]; then
	touch "$git_log_detail_info"
	fi

	if [ -n `which git` ]; then
	 #echo 'brew exist' >> $git_log_name
	else
	 echo 'brew does not exist' >> $git_log_name
	 exit 0
	fi

}

git_log_run()
{
	#得到当前时间
	CURTIME=$((date +%y%m%d%H%M%S))
	nowtime=$git_log_title$CURTIME
	
	echo $nowtime >> $git_log_name
    cd /date/wwwroot/www.temaiol.com
    echo "H11111111h"|git pull
    echo $git_log_success_info >> $git_log_name
    exit 0
    
}

#git_log_check_env
git_log_run


