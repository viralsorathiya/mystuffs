# CloudFormation Lambda Deployment

## Overview
This repository contains a CloudFormation template that creates an AWS Lambda function and retrieves its output. The deployment is fully automated and can be executed with a single command from your terminal.

## Deployment Command
To deploy the CloudFormation stack and retrieve the Lambda function output, use the following command:

```sh
STACK_ID=$(aws cloudformation create-stack --stack-name my-test-stack  \
  --template-body file://lambda-cloudformation.yml  \
  --capabilities CAPABILITY_NAMED_IAM  \
  --query "StackId" --output text) && \
echo "Stack creation in progress: $STACK_ID" && \
aws cloudformation wait stack-create-complete --stack-name my-test-stack && \
echo "Stack creation complete" && \
OUTPUT_VALUE=$(aws cloudformation describe-stacks --stack-name my-test-stack  \
  --query "Stacks[0].Outputs[?OutputKey=='LambdaFunctionOutput'].OutputValue" --output text) && \
echo "Lambda Output: $OUTPUT_VALUE"
```

## Expected Output
Once the stack is successfully deployed, the Lambda function will execute and return a JSON output:

```sh
Lambda Output: {"Message": "Lambda has created the User!", "UserName": "The password is stored in the Secrets!"}
```

## Notes
- Ensure you have the AWS CLI configured with the necessary permissions.
- The CloudFormation template file (`lambda-cloudformation.yml`) must be available in the current directory.
- Modify the stack name (`my-test-stack`) if deploying multiple instances.

## Cleanup
To delete the CloudFormation stack and remove all resources, run:

```sh
aws cloudformation delete-stack --stack-name my-test-stack
```
