#!/bin/bash

declare -f showHelp
declare -f isReachable 
SERVER=10.3.8.211 # Default server, change this as needed

showHelp() {
cat <<EOF
usage: $0 [-u username] [-p password] [-s url] [-h][-t]
	-u username
	-p password
	-s authentication server, default 10.3.8.211
	-h display this help and exit
	-t test the current network state and exit
EOF
exit 1
}

isReachable() {
    local ADDR=${1:-baidu.com}
    if command -v curl &>/dev/null; then
	    curl -I "$ADDR" 2>/dev/null | head -n 1 | grep -q "200 OK"
    else
	    # FIXME ICMP may be disabled ?
        # Fallback to ping if curl is not available
	    ping -c 1 -W 2 "$ADDR" &>/dev/null
    fi
    return $?
}
parseOpts()
{
    # while getopts ":u:p:i:ht" arg
    while getopts ":u:p:s:ht" arg; do
        case $arg in
            u) ID=$OPTARG ;;
            p) PASSWORD=$OPTARG ;;
            h) showHelp; exit 0 ;;
            s) SERVER=$OPTARG ;;
            t)
                if isReachable; then
                    echo "Network is OK!"
                else
                    echo "Network is unreachable!"
                fi
                exit 0
                ;;
            *) showHelp; exit 1 ;;
        esac
    done
    shift $((OPTIND -1))
}

inputUserName() {
	read -rp "Please type your username(学号): " ID
}

inputPassword() {
	read -rsp "Please type your password(密码): " PASSWORD
	echo
}

getRequest() {
    if [ $# -lt 1 ]
    then
        echo "Usage $0 <url>"
        exit 1
    fi
    ADDRESS=$1
    curl -X GET $ADDRESS
}

postRequest() {
    if [ $# -lt 2]; then
        echo "Usage: $0 <data> <url>"
        echo "For example: postRequest 'a=1&b=2' example.com"
        exit 1
    fi
    local DATA=$1
    local ADDRESS=$2
    curl s -X POST -d "$DATA" "$ADDRESS"
}

request() {
    getRequest $@
}

login()
{
    if [ -z "$SERVER" ]; then
        echo "The address of server not set"
        exit 1
    fi
    if ! isReachable $SERVER; then
        echo "Cann't connect to authentication server!"
        exit 1
    fi
    [ -z "$ID" ] && inputUserName
    [ -z "$PASSWORD" ] && inputPassword
    postRequest "DDDDD=$ID&upass=$PASSWORD&save_me=1&R1=0" "$SERVER" &>/dev/null
}

checkDeps() {
	local deps=('curl')
	for package in ${deps[@]}; do
		if ! command -v $package &>/dev/null; then
			read -rp "$package is not installed, now install? (y/n):" YES
			if [ "$YES" != "y" ]; then
				echo "'$package' is not installed, exiting..."
				exit 1
			else
				sudo apt-get -y install "$package"
				if ! command -v $package &>/dev/null; then
					echo "Failed to install '$package', exit..."
					exit 1
				fi
			fi
		fi
	done
}
main()
{
    checkDeps
    parseOpts $@
    if isReachable baidu.com; then
        echo "The network is OK!"
        exit 0
    fi
    login
    if isReachable baidu.com; then
        echo "Login successful!"
        exit 0
    else
        echo "Login failed!"
        exit 1
    fi
}

main $@
