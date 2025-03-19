#!/bin/bash

# Define the regions to iterate over
REGIONS=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

# Define the search patterns
PATTERN_1="akk"
PATTERN_2="208002"

# Output header
echo "Region,Service,Name"

# Iterate over each region
for REGION in $REGIONS; do
    # Get ECS cluster names
    ECS_CLUSTERS=$(aws ecs list-clusters --region $REGION --query "clusterArns" --output text | tr '\t' '\n')
    
    for CLUSTER in $ECS_CLUSTERS; do
        CLUSTER_NAME=$(basename $CLUSTER)
        if [[ "$CLUSTER_NAME" == *"$PATTERN_1"* || "$CLUSTER_NAME" == *"$PATTERN_2"* ]]; then
            echo "$REGION,ECS,$CLUSTER_NAME"
        fi
    done

    # Get RDS instance names
    RDS_INSTANCES=$(aws rds describe-db-instances --region $REGION --query "DBInstances[].DBInstanceIdentifier" --output text)
    
    for RDS in $RDS_INSTANCES; do
        if [[ "$RDS" == *"$PATTERN_1"* || "$RDS" == *"$PATTERN_2"* ]]; then
            echo "$REGION,RDS,$RDS"
        fi
    done
done
