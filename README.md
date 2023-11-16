# 北邮命令行上网认证
 
使用北邮校园网时能够在终端下进行认证的脚本程序

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
./python/login.py
```

## shell版本

使用`./sh/autoLogin.sh -h`查看帮助信息。

```
./authLogin.sh -h
```
```
usage: ./autoLogin.sh [-u username] [-p password] [-s ip] [-h][-t]
	-u username
	-p password
	-s suthentication server
	-h display this help and exit
	-t test the current network if available and exit
for example:
	./autoLogin.sh -u 2013140*** -p ****** # 直接输入帐号密码
	./autoLogin.sh # 交互式输入帐号密码
	./autoLogin.sh -t # 测试当前网络状况
```

