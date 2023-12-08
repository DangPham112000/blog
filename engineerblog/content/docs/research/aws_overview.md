---
title: "AWS Overview"
weight: 20
date: 2023-11-15T01:47:46+07:00
---

# AWS Overview

## [Slide](https://media.datacumulus.com/aws-ccp/AWS%20Certified%20Cloud%20Practitioner%20Slides%20v24.pdf?_gl=1*30glds*_ga*MTE3OTY1Nzc3MS4xNzAxOTkzMTc4*_ga_6GZZTGGX7H*MTcwMTk5MzE3OC4xLjAuMTcwMTk5MzE3OC42MC4wLjA.)

## EC2

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
