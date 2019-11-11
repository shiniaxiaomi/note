cd ~/Documents/note/

# 笔记推送
NotePush(){
    read -p "请输入提交信息：" msg
    if test ${msg}null == "null" 
    then
        git add .
        git commit -m "补充"
        git push
    else
        git add .
        git commit -m "${msg}"
        git push
    fi 
    say "笔记推送成功"
}

# 笔记拉取
NotePull(){
    git pull
    say "笔记拉取成功"
}

while true
do
    echo "请输入命令：push或pull"
    read command

    if test ${command}null == "null" 
    then 
        continue
    elif test $command == 'push' 
    then 
        NotePush
        break
    elif test $command == 'pull' 
    then
        NotePull
        break
    elif test $command == 'exit' 
    then
        break
    fi
done



