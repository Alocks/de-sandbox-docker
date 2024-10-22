function check_ip_connection {
    host="$1" && port="$2" && counter=0 && success=false && max_attempts=5

    while [[ $counter -lt $max_attempts && $success == false ]]; do
        counter=$((counter + 1))
        echo "Checking connection for $host:$port... $counter out of $max_attempts tries"
        sleep 1
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
    if [[ -z "$port_num" ]]; then
        echo "::error ${port_var} IS NOT SET! Configure environment variables to fix this issue." && exit 1
    fi
    conn_result=$(check_ip_connection $host $port_num)
    if [[ $conn_result == false ]]; then
        echo "::error Failed to connect to $host:$port_num. Check the compose or image file." && exit 1
    fi
done