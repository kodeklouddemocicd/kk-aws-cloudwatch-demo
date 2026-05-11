## Prequ
## create iam role that has all premissions >> cloudwatch, cloudwatch logs, ec2 >> add it to ec2 iam role config 
## HOW TO UPLOAD IT **
## it generates log files 
## 1. sudo su
## 2. cd 
## 3.  vi generate_all.sh  >>> add the script 
## 4. bash generate_all.sh >> activate the script 
## 5.  ls -ls >> new file
## 6.  tail -10 events_all.json << see the files generated 
## HOW TO PUSH LOGS TO CLOUD WATCH CLI 
## allows the logs to be filtered into log streams and log groups filtering for the important logs only 
## 7. run: aws logs put-log-events --log-group-name application-404-error-tracker --log-stream-name hostname --log-events file://events_all.json
## 7.1. it will fail becuase the log group is not created application-404-error-tracker & stream named hostname 
## 8. create the log group (it is in log management) >> add the application-404-error-tracker >> go into log group created and go into log stream >> add hostname for stream 
## 9. run: aws logs put-log-events --log-group-name application-404-error-tracker --log-stream-name hostname --log-events file://events_all.json (mke sure cloudwatch logs full permission is on to extract logs )



#!/bin/bash

# Number of messages to generate
num_messages=500

# Get the current timestamp in milliseconds
current_timestamp=$(date +%s%3N)

# Output file
output_file="events_all.json"

# Open the JSON array
echo "[" > "$output_file"

# Array of possible HTTP response statuses
statuses=(200 400 404)

# Generate log messages
for i in $(seq 1 "$num_messages"); do

  # Format the timestamp and message
  timestamp=$((current_timestamp + i - 1))
  formatted_date=$(date -u -d "@$((timestamp / 1000))" +"%d/%b/%Y:%H:%M:%S %z")

  # Randomly select an HTTP response status
  status=${statuses[$RANDOM % ${#statuses[@]}]}

  # Select a file based on the status
  file="/apache_pb${status}.gif"

  # Create Apache-style log message
  message="127.0.0.1 - bob [${formatted_date}] \"GET $file HTTP/1.0\" $status 2326"

  # Escape quotes for JSON
  escaped_message=$(echo "$message" | sed 's/"/\\"/g')

  # Create a JSON object for the log event
  json="{\"timestamp\": $timestamp, \"message\": \"$escaped_message\"}"

  # Add comma except before the first object
  if [[ "$i" -gt 1 ]]; then
    echo "," >> "$output_file"
  fi

  # Append the JSON object to the file
  echo -n "  $json" >> "$output_file"

done

# Close the JSON array
echo -e "\n]" >> "$output_file"

echo "Created $output_file with $num_messages log events."


