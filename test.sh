#!/bin/bash

# Get all AWS regions
REGIONS=$(aws ec2 describe-regions --query "Regions[].RegionName" --output text)

# Define the search patterns
PATTERN_1="akk"
PATTERN_2="208002"

# Output files
ECS_OUTPUT="ecs_matching_clusters.csv"
RDS_OUTPUT="rds_matching_instances.csv"

# Headers for output
echo "Region,Cluster Name" > $ECS_OUTPUT
echo "Region,RDS Instance Name" > $RDS_OUTPUT

# Iterate over each region
for REGION in $REGIONS; do
    echo "Checking region: $REGION..."

    # Get ECS cluster names
    ECS_CLUSTERS=$(aws ecs list-clusters --region $REGION --query "clusterArns" --output text | tr '\t' '\n')

    for CLUSTER in $ECS_CLUSTERS; do
        CLUSTER_NAME=$(basename $CLUSTER)
        if [[ "$CLUSTER_NAME" == *"$PATTERN_1"* && "$CLUSTER_NAME" == *"$PATTERN_2"* ]]; then
            echo "$REGION,$CLUSTER_NAME" >> $ECS_OUTPUT
        fi
    done

    # Get RDS instance names
    RDS_INSTANCES=$(aws rds describe-db-instances --region $REGION --query "DBInstances[].DBInstanceIdentifier" --output text)

    for RDS in $RDS_INSTANCES; do
        if [[ "$RDS" == *"$PATTERN_1"* && "$RDS" == *"$PATTERN_2"* ]]; then
            echo "$REGION,$RDS" >> $RDS_OUTPUT
        fi
    done
done

echo "✅ ECS results saved in: $ECS_OUTPUT"
echo "✅ RDS results saved in: $RDS_OUTPUT"
