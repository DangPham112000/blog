---
title: "AWS Overview"
weight: 20
date: 2023-11-15T01:47:46+07:00
---

# AWS Overview

## [Slide](https://media.datacumulus.com/aws-ccp/AWS%20Certified%20Cloud%20Practitioner%20Slides%20v24.pdf?_gl=1*30glds*_ga*MTE3OTY1Nzc3MS4xNzAxOTkzMTc4*_ga_6GZZTGGX7H*MTcwMTk5MzE3OC4xLjAuMTcwMTk5MzE3OC42MC4wLjA.)

## Types of Cloud Computing

![cloud_computing_types](/research/aws_overview/cloud_computing_types.png)

## EC2 - Elastic Compute Cloud

- **EC2 = Infrastructure as a Service (IaaS)**
- **On-Demand Instances** – short workload, predictable pricing, pay by second
  - Has the highest cost
  - Recommended for short-term and un-interrupted workloads, where you can't predict how the application will behave
- **Reserved** (1 & 3 years)
  - **Reserved Instances** – long workloads
    - Recommended for steady-state usage applications (think database)
  - **Convertible Reserved Instances** – long workloads with flexible instances
- **Savings Plans (1 & 3 years)** – commitment to an amount of usage, long workload
- **Spot Instances** – short workloads, cheap, can lose instances (less reliable)
  - The MOST cost-efficient
- **Dedicated Hosts** – book an entire physical server, control instance placement
  - The most expensive option
- **Dedicated Instances** – no other customers will share your hardware
  - No control over instance placement
- **Capacity Reservations** – reserve capacity in a specific AZ for any duration

## Monitoring

- **CloudWatch**:
  - **Metrics**: monitor the performance of AWS services and billing metrics
  - **Alarms**: automate notification, perform EC2 action, notify to SNS based on metric
  - **Logs**: collect log files from EC2 instances, servers, Lambda functions…
  - **Events (or EventBridge)**: react to events in AWS, or trigger a rule on a schedule
- **CloudTrail**: audit API calls made within your AWS account
- **CloudTrail Insights**: automated analysis of your CloudTrail Events
- **X-Ray**: trace requests made through your distributed applications
- **AWS Health Dashboard**: status of all AWS services across all regions
- **AWS Account Health Dashboard**: AWS events that impact your infrastructure
- **Amazon CodeGuru**: automated code reviews and application performance recommendations

## ECS - Elastic Container Service

- You must provision & maintain the infrastructure (the EC2 instances)
  ![ecs](/research/aws_overview/ecs.png)

## Fargate

- You do not provision the infrastructure (no EC2 instances to manage) – simpler!
- Serverless offering
  ![fargate](/research/aws_overview/fargate.png)

## ECR - Elastic Container Registry

- Store your Docker images
  ![ecr](/research/aws_overview/ecr.png)

## Lambda

- Virtual **functions** – no servers to manage!
- Limited by time - **short executions**
- Run **on-demand**
- **Scaling is automated**!
- **Event-Driven**: functions get invoked by AWS when needed

### Pricing

- Pay per **calls**
- Pay per **duration**

### Example

{{< columns >}}

**Serverless Thumbnail creation**

![lambda_eg1](/research/aws_overview/lambda_eg1.png)

<--->

**Serverless CRON Job**

![lambda_eg2](/research/aws_overview/lambda_eg2.png)

{{< /columns >}}

## API Gateway

- **Serverless** and scalable
- Supports RESTful APIs and WebSocket APIs
- Support for security, user authentication, API throttling, API keys, monitoring...
  ![api_gateway](/research/aws_overview/api_gateway.png)

## Batch

- **Fully managed** batch processing at **any scale**
- Batch will dynamically launch **EC2 instances** or **Spot Instances**
- Batch jobs are defined as **Docker images** and **run on ECS**
  ![batch](/research/aws_overview/batch.png)

## Batch vs Lambda

{{< columns >}}

**Lambda**

- Time limit
- Limited runtimes
- Limited temporary disk space
- Serverless

<--->

**Batch**

- No time limit
- Any runtime as long as it’s packaged as a Docker image
- Rely on EBS / instance store for disk space
- Relies on EC2 (can be managed by AWS)

{{< /columns >}}

## Lightsail

- Simpler alternative to using EC2, RDS, ELB, EBS, Route 53
- Great for people with **little cloud experience**!
- **"almost always be a wrong answer"**

## CloudFormation

**Infrastructure as code**

Within a CloudFormation template, you say:

- I want a security group
- I want two EC2 instances using this security group
- I want an S3 bucket
- I want a load balancer (ELB) in front of these machines

Then CloudFormation creates those for you, in the **right order**, with the **exact configuration** that you specify

## CDK - Cloud Development Kit

- Define your cloud infrastructure using a familiar language: JavaScript, Python, ...
  - You can use `for` loop to create multiple instances
- The code is “compiled” into a CloudFormation template (JSON/YAML)
- You can therefore deploy infrastructure and application runtime code together
  ![cdk](/research/aws_overview/cdk.png)

## Elastic Beanstalk

### Overview

- **A developer centric view** of deploying an application on AWS
- It uses all the component’s we’ve seen before: EC2, ASG, ELB, RDS, etc
- **Beanstalk = Platform as a Service (PaaS)**
- Beanstalk is free but you pay for the underlying instances
- **Just the application code is the responsibility of the developer**

### Health Monitoring

- Health agent pushes metrics to CloudWatch
- Checks for app health, publishes health events

## CodeDeploy

- We want to deploy our application **automatically**
- Works with **EC2 Instances**
- Works with **On-Premises Servers**
- **{{<u "Hybrid" >}}** service
- Servers / Instances must be provisioned and configured ahead of time with the CodeDeploy Agent

![codedeploy](/research/aws_overview/codedeploy.png)

## CodeCommit

- **Like GitHub**
- Developers usually store **code in a repository**, using the **Git technology**

## CodeBuild

- **Compiles source code, run tests, and produces packages** that are ready to be deployed (by CodeDeploy for example)
- Pay-as-you-go pricing - **only pay for the build time**

![codebuild](/research/aws_overview/codebuild.png)

## CodePipeline

- Orchestrate the different steps to have the code automatically pushed to production
  - Code => Build => Test => Provision => Deploy
  - Basis for CICD (Continuous Integration & Continuous Delivery)

![codepipeline](/research/aws_overview/codepipeline.png)

## CodeArtifact

## CodeStar

## Cloud9

- A cloud IDE
- Allows for code collaboration in real-time (pair programming)
