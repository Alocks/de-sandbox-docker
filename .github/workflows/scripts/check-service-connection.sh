function check_ip_connection {
    host="$1" && port="$2" && counter=0 && success=false

    while [[ $counter -lt 5 && $success == false ]]; do
        sleep 1 && counter=$((counter + 1))
        conn_message=$(nc -vz $host $port 2>&1 | awk '{print $NF}')
        if [[ "$conn_message" == "succeeded!" ]]; then
            success=true
        fi   
    done
    echo $success
}

host='localhost'
ports_var=$(yq -r '.services[] | .ports[] | split(":")[0]' 'compose.yml')
for port_var in $ports_var; do
    port_num=$(eval echo $port_var)
    echo 1
    if [[ -z "$port_num" ]]; then
        fail "${port_var} IS NOT SET! Configure environment variables to fix this issue."
    fi
    conn_result=$(check_ip_connection $port_num)
    if [[ $conn_result == false ]]; then
        fail "Failed to connect to $host:$port_num. Check the compose or image file."
    fi
done