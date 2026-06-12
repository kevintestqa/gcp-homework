# FinOps Guide

## Table of Contents

- [What are Cloud Notifications?](#what-are-cloud-notifications)
  - [How to set Cloud Notifications (SMS)](#how-to-set-cloud-notifications-sms)
- [How to set Budget Alerts](#how-to-set-budget-alerts)

## What are Cloud Notifications?

- Cloud Notifications assist organizations manage their cloud usage. For example, departments such as FinOps or a Cloud Center of Excellence use notifications to monitor cloud spend.

**Source:**
- https://docs.cloud.google.com/monitoring/support/notification-options
- https://docs.cloud.google.com/monitoring/alerts

### How to set Cloud Notifications (SMS)

- Prerequisite - project must have the Monitoring Editor IAM role.

**Source:** https://docs.cloud.google.com/monitoring/support/notification-options

1. Navigate to the Alerting page in GCP
2. Select the desired project you want to create alerts for
3. Click on **Edit notification channels**
4. In the SMS section click **Add New**
5. Enter the phone number and display name
6. Click on **Send Verification Code**
7. Enter the 6-digit code Google sends and click on **Verify**

## How to set Budget Alerts

1. Navigate to the Budgets and Alerts page in GCP
2. Select the desired project you want to create alerts for
3. Click on **Create budgets**
4. Enter desired budget name
5. Select the desired Time range
6. Select the projects that the budget will be focused on
7. Select the desired service(s)
8. Under **Savings** select Savings programs and Other Savings and click on **Next**
9. Enter the Target amount and click on **Next**
10. Edit the alert threshold rules to desired values
11. Select the desired notification channels (Email alerts to billing admins and users should be selected by default)
12. Click on **Finish**