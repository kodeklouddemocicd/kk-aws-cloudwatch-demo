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


