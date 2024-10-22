JSON_FILES=$(find . -name '*.json' -exec sh -c 'echo $(dirname {})/$(basename {})' \;)
for json_file in "${JSON_FILES[@]}"; do
    echo 'Validating' $json_file "..."
    python3 -mjson.tool "$json_file" > /dev/null || echo 'FAILED' && exit 1
done;
echo "OK"