# 北邮命令行上网认证
 
使用北邮校园网时能够在终端下进行认证的脚本程序

python和bash命令行脚本可以借助cron或systemctl等方式方便的设置断网后自动重连, 避免电脑或者服务器突然断网而不知情的尴尬情况发生.

## python版本

### 1. 安装pip

```bash
! which pip &>/dev/null && sudo apt-get install pip
```

### 2. 安装python依赖包

```bash
pip install -r requirements.txt
```

### 3. 用法

```bash
# 直接连接
./python/login.py -u 2020114514 -p 1919810

# 交互式使用
./python/login.py
```

## shell版本

使用`./sh/auto_login.sh -h`查看帮助信息。

```bash
./sh/auth_login.sh -h
```

```
usage: ./sh/auto_login.sh [-u username] [-p password] [-s ip] [-h][-t]
	-u username
	-p password
	-s suthentication server
	-h display this help and exit
	-t test the current network if available and exit
for example:
	./sh/auto_login.sh -u 2020114514 -p 1919810 # 直接输入帐号密码
	./sh/autoLogin.sh # 交互式输入帐号密码
	./sh/auto_login.sh -t # 测试当前网络状况
```

## 自动定时任务
如果想要自动重连网络, 可以借助crontab或其他工具创建定时任务. 

```bash
crontab -e

# 添加如下内容, 选择其中一种
# bash脚本版本
*/5 * * * * /path/to/sh/auto_login.sh -u 用户名 -p 密码
# python版本
*/5 * * * * /usr/bin/python3 /path/to/python/login.py -u 用户名 -p 密码
```
