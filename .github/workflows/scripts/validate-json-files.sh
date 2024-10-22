JSON_FILES=$(find . -name '*.json' -exec sh -c 'echo $(dirname {})/$(basename {})' \;)
for json_file in "${JSON_FILES[@]}"; do
    echo 'Validating' $json_file "..."
    python3 -mjson.tool "$json_file" > /dev/null || fail 'INVALID JSON'
done;
echo "OK"