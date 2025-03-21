#!/bin/bash

# Script to measure instance startup time and individual health check times.

# Configuration (adjust as needed)
INSTANCE_ID="$1"  # Pass the instance ID as the first argument
POLL_INTERVAL=5   # Seconds between checks
TIMEOUT=600       # Maximum time to wait (seconds)

if [ -z "$INSTANCE_ID" ]; then
  echo "Usage: $0 <instance_id>"
  exit 1
fi

echo "Checking instance $INSTANCE_ID startup and health check times..."

start_time=$(date +%s)
end_time=$((start_time + TIMEOUT))

instance_reachability_time=0
system_reachability_time=0
ebs_reachability_time=0

instance_reachability_passed=0
system_reachability_passed=0
ebs_reachability_passed=0

while true; do
  current_time=$(date +%s)

  # Get the JSON output of the instance status.
  instance_status_json=$(aws ec2 describe-instance-status --instance-ids "$INSTANCE_ID" 2>/dev/null)

  # Check if the command was successful and the instance exists
  if [ -z "$instance_status_json" ]; then
    echo "Instance $INSTANCE_ID not found or an error occurred. Please verify instance ID or AWS CLI configuration."
    exit 1
  fi

  # Extract the status of each component using jq
  instance_reachability=$(echo "$instance_status_json" | jq -r '.InstanceStatuses[0].InstanceStatus.Details[0].Status')
  system_reachability=$(echo "$instance_status_json" | jq -r '.InstanceStatuses[0].SystemStatus.Details[0].Status')
  ebs_reachability=$(echo "$instance_status_json" | jq -r '.InstanceStatuses[0].AttachedEbsStatus.Details[0].Status')

  # Check individual statuses and record times
  if [ "$instance_reachability" == "passed" ] && [ "$instance_reachability_passed" -eq 0 ]; then
    instance_reachability_time=$((current_time - start_time))
    instance_reachability_passed=1
    echo "Instance $INSTANCE_ID: Instance Reachability passed after $instance_reachability_time seconds."
  fi

  if [ "$system_reachability" == "passed" ] && [ "$system_reachability_passed" -eq 0 ]; then
    system_reachability_time=$((current_time - start_time))
    system_reachability_passed=1
    echo "Instance $INSTANCE_ID: System Reachability passed after $system_reachability_time seconds."
  fi

  if [ "$ebs_reachability" == "passed" ] && [ "$ebs_reachability_passed" -eq 0 ]; then
    ebs_reachability_time=$((current_time - start_time))
    ebs_reachability_passed=1
    echo "Instance $INSTANCE_ID: EBS Reachability passed after $ebs_reachability_time seconds."
  fi

  # Check if all statuses are passed
  if [ "$instance_reachability" == "passed" ] && [ "$system_reachability" == "passed" ] && [ "$ebs_reachability" == "passed" ]; then
    total_time=$((current_time - start_time))
    echo "Instance $INSTANCE_ID: All 3 statuses passed after $total_time seconds."
    exit 0
  elif [ "$current_time" -gt "$end_time" ]; then
    echo "Timeout waiting for instance $INSTANCE_ID to reach steady state."
    exit 1
  else
    echo "Instance $INSTANCE_ID: Instance Reachability: $instance_reachability, System Reachability: $system_reachability, EBS Reachability: $ebs_reachability. Waiting..."
    sleep $POLL_INTERVAL
  fi
done

exit 0 #should not reach here.
