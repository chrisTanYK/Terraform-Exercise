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


Assignment 2.13
Make a comparison between Serverless Framework and Terraform as tools for IaC by answering:

1: What type of infrastructure and application deployments are each tool best suited for?
Ans:Serverless Framework
Best for: Deploying and managing serverless applications (AWS Lambda, Azure Functions, Google Cloud Functions).
Infrastructure: Focuses on event-driven architectures and integrates with managed cloud services like API Gateway, DynamoDB, and S3.
Use Cases: Web and mobile backends, microservices, real-time event processing, and IoT applications.
Terraform
Best for: Full infrastructure provisioning and automation across cloud providers (AWS, Azure, GCP, etc.).
Infrastructure: Manages VMs, networks, databases, Kubernetes clusters, IAM policies, and multi-cloud environments.
Use Cases: Infrastructure management, cloud networking, container orchestration, hybrid/multi-cloud setups, and security automation.
👉 Serverless Framework is optimized for serverless application deployment, while Terraform is a broader IaC tool for managing entire cloud infrastructures.

2: How do their primary objectives differ?
Ans: Serverless Framework
Objective: Streamline the deployment and management of serverless applications with minimal infrastructure concerns.
Focus: Automates function deployment, event triggers, and integrations with managed services (e.g., AWS Lambda, API Gateway).
Terraform
Objective: Provide declarative infrastructure provisioning and management across multiple cloud providers.
Focus: Manages cloud resources like VMs, networks, databases, Kubernetes clusters, and security policies with full lifecycle control.
👉 Serverless Framework is optimized for serverless applications, while Terraform is designed for comprehensive infrastructure automation.

3: How do they differ in terms of learning curve and ease of use for developers or DevOps teams?
Ans: Serverless Framework
Easier to learn, especially for developers familiar with serverless services.
Uses YAML-based configuration and a simple CLI, making deployment straightforward.
Abstracts most infrastructure complexity, focusing on application logic.
Best for: Quick serverless deployments with minimal cloud expertise.
Terraform
Steeper learning curve due to HCL (HashiCorp Configuration Language) and complex infrastructure concepts.
Requires knowledge of networking, IAM, cloud architecture, and infrastructure dependencies.
Powerful but requires state management and planning before applying changes.
Best for: DevOps teams managing full cloud infrastructure at scale.
👉 Serverless Framework is beginner-friendly and application-focused, while Terraform requires deeper infrastructure expertise but offers greater flexibility.

4:What are the differences in how each tool handles state tracking and deployment changes?
Ans: Serverless Framework
Does not maintain a persistent state file.
Relies on the cloud provider’s APIs to track and deploy resources.
Deployment changes are incremental and managed by the provider, with minimal rollback capabilities.
Terraform
Maintains a state file to track the current infrastructure and detect changes.
Uses a plan/apply workflow, allowing users to preview changes before applying them.
Provides drift detection, versioning, and rollback capabilities for safer infrastructure updates.
👉 Serverless Framework relies on cloud provider APIs for state management, while Terraform maintains an explicit state file for tracking and controlling infrastructure changes.

5:In what scenarios would you recommend using Serverless Framework over Terraform, and vice versa?
Ans: Use Serverless Framework when:
Deploying serverless applications (AWS Lambda, Azure Functions, Google Cloud Functions).
Focusing on application logic rather than managing infrastructure.
Needing quick, automated deployments of APIs, microservices, or event-driven applications.
Working within a single cloud provider without multi-cloud infrastructure needs.
Use Terraform when:
Managing full cloud infrastructure, including VMs, networking, databases, and security.
Needing multi-cloud or hybrid-cloud support across AWS, Azure, and GCP.
Requiring state tracking, drift detection, and infrastructure versioning.
Deploying Kubernetes clusters, large-scale enterprise systems, or complex cloud architectures.
👉 Serverless Framework is ideal for serverless app deployments, while Terraform is better for managing full infrastructure across cloud environments.

6:Are there scenarios where using both together might be beneficial?
Ans:Yes, combining both tools can be beneficial in scenarios where:

Terraform provisions infrastructure, such as VPCs, IAM roles, databases, and storage, while Serverless Framework deploys serverless applications on top of it.
You need state management for underlying cloud resources (Terraform) but want simplified function deployment (Serverless Framework).
You operate in a hybrid environment, where some services run on VMs/Kubernetes (Terraform) and others use serverless architectures (Serverless Framework).
You want multi-cloud infrastructure management (Terraform) while deploying serverless workloads on a specific provider (Serverless Framework).
👉 Terraform handles infrastructure, while Serverless Framework optimizes serverless app deployment, making them complementary in complex cloud setups.

Assignment 2.14

1:Does SNS guarantee exactly once delivery to subscribers?
Ans:No, Amazon SNS (Simple Notification Service) does not guarantee exactly once delivery to subscribers.
SNS guarantees at least once delivery of messages, meaning that a message may be delivered to a subscriber one or more times, but it will not be lost. There could be duplicates in certain scenarios, such as network issues or retries.
To handle message deduplication and ensure exactly once delivery, you would need to implement your own deduplication logic at the subscriber's end, especially when the subscribers are services like Lambda, SQS, or HTTP endpoints.

2:What is the purpose of the Dead-letter Queue (DLQ)? This is a feature available to SQS/SNS/EventBridge.
Ans: A Dead-letter Queue (DLQ) is a feature in Amazon SQS, SNS, and EventBridge that captures messages that fail delivery after multiple retries.
Purpose of DLQ:
Stores undelivered messages for troubleshooting.
Helps prevent message loss.
Allows developers to analyze and fix issues (e.g., incorrect permissions, unresponsive endpoints).
Reduces message processing delays by offloading failed messages.
For SNS, messages move to a DLQ only if they fail all retry attempts across all subscribers.

3:How would you enable a notification to your email when messages are added to the DLQ?
Ans: To get an email notification when messages are added to a DLQ, follow these steps:
Step 1: Create an SNS Topic for Notifications
Go to AWS SNS Console → Create topic
Choose Standard
Set Name: DLQ-Alert-Topic
Click Create topic

Step 2: Subscribe Your Email to the SNS Topic
Go to AWS SNS Console → Topics → Select DLQ-Alert-Topic
Click Create Subscription
Set Protocol: Email
Enter your Email Address
Confirm the subscription via email.

Step 3: Create an EventBridge Rule for DLQ Monitoring
Go to AWS EventBridge Console → Rules → Create rule
Name it: DLQ-Message-Alert
Event Source: Choose EventBridge
Event Pattern:
Service Name: SQS
Event Type: Message sent to DLQ
Target: Select SNS Topic → Choose DLQ-Alert-Topic

Step 4: Test the Setup
Send a message to an SQS queue with a DLQ configured.
Make the consumer fail processing (e.g., incorrect permissions).
Check if the message lands in the DLQ.
Verify if an email notification is received.





