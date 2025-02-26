Assignment 2.12
1. What is the purpose of the execution role on the Lambda function?
ans: The execution role grants AWS Lambda the necessary permissions to access other AWS services, such as writing logs to   CloudWatch, reading/writing S3 objects, or interacting with databases, ensuring secure and controlled execution.


2.What is the purpose of the resource-based policy on the Lambda function?
ans: A resource-based policy on a Lambda function allows other AWS services (like S3, SNS, or API Gateway) or AWS accounts to invoke the function, enabling cross-service and cross-account access control. 

3.If the function is needed to upload a file into an S3 bucket, describe (i.e no need for the actual policies)
What is the needed update on the execution role?
What is the new resource-based policy that needs to be added (if any)?
ans: Execution Role Update
The execution role needs S3 permissions to PutObject into the target bucket, allowing the Lambda function to upload files.

Resource-Based Policy Update
No additional resource-based policy is needed unless the function is invoked from another AWS account or service requiring explicit permissions.

