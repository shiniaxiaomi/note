cd ~/Documents/note/

while true
do
    echo "请输入命令：push或pull"
    read command

    if test $command == 'push'
    then 
        read -p "请输入提交信息：" msg
        git add .
        git commit -m "$msg"
        git push
        say "笔记推送成功"
        break
    elif test $command == 'pull'
    then
        git pull
        say "笔记拉取成功"
        break
    elif test $command == 'exit'
    then
        break
    fi
done
