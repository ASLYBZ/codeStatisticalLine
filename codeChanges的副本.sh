# 统计代码改动行数  /Users/wangweiliang/Desktop/shell测试

statisticalUserCodeChanges() {

#    rm -f $2/new.txt
    # 输出改动到文本
    git log --author=$1 --after="2021-01-01 00:00:01" --before="2021-01-31 23:59:59" --pretty=tformat: --numstat | grep -v 'static' >> $2/temp.txt
    grep -vwFf $2/filterConfig.txt $2/temp.txt >> $2/new.txt
    awk '{ add += $1; subs += $2; loc += $1 + $2 } END { printf "用户名: %-15s 添加代码行数: %-10s 删除代码行数: %-10s 总改动代码行数: %-10s \n", "'$1'", add, subs, loc }' $2/new.txt >> $2/output.txt
    awk '{ add += $1; subs += $2; loc += $1 + $2 } END { printf "'$1', %s, %s, %s \n", add, subs, loc }' $2/new.txt >> $2/tempOutput.txt
    rm $2/temp.txt #$2/new.txt
}

# 统计小组代码行数
statisticalGroupCodeChanges() {

    echo "开始统计"

    rm -f $1/output.txt
    rm -f $1/tempOutput.txt

    # 初始化标题
    echo "用户名, 添加代码行数, 删除代码行数, 总改动代码行数" > $1/tempOutput.txt

    # 小组用户名
    #userNames=("linzc" "wangweiliang" "zhangjunzheng" "luronghua" "huacheng" "chenjianchang")
userNames=("chenjianchang")


    # 循环统计所有用户代码行数
    for userName in ${userNames[@]}
    do
    statisticalUserCodeChanges $userName $1
    done

    # 写入表格
    cat $1/tempOutput.txt > $1/output.csv
    cat $1/output.txt
    rm -f $1/tempOutput.txt
    echo "统计完成"
    kill -9 $$
}

# 等待进度
progressbar() {
    progress=1
    while (( $progress<1000 ))
    do
    printf "%-s\r" $b
    sleep 0.3
    b=#$b
    done
}

run() {
    # 过滤文件所有目录
    filterPath=$(pwd)

    # 配置项目地址
    echo "请输入工程路径:";
    read projectPath
    cd $projectPath

    statisticalGroupCodeChanges $filterPath &
    progressbar
}

run
