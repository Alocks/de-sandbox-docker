# CONF
max_retries=5
sleep_time=1

#SCRIPT
port="$1"
counter=0
success=false

while [[ $counter -lt $max_retries && $success == false ]]; do
    sleep $sleep_time && counter=$((counter + 1))
    conn_message=$(nc -vz localhost $port 2>&1 | awk '{print $NF}')
    if [[ "$conn_message" == "succeeded!" ]]; then
        success=true
    fi   
    
done

echo $success