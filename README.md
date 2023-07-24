# **Conduit configuration using Terraform.**
------
### [Conduit Application]).

### **Pre Requisites :**

1. Azure infrastructure with subscription is required for this project. Create one if you dont have a subscription. https://azure.microsoft.com/
2. The local machine used to run project should have terraform, azure CLI installed. 
   Follow links for installations,
   - Terraform - https://developer.hashicorp.com/terraform/downloads
   - Azure CLI - https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli
3. Terraform uses *terraform.tfvars* file in root location.
4. Use azure CLI commands to login to azure,
  az login
  (Chrome browser will popup to authenticate in azure using your subscription.)
6. Update your subscription_id in *providers.tf* file.

### **Project Structure :**

1. ConduitAPI - Used real-world Django + Rest framework application. https://github.com/Sean-Miningah/realWorld-DjangoRestFramework
   It has azure-pipelines.yaml which will deploy code to container apps conduitapi. Currently pipelines are configured using azure devops CI\CD.
2. ConduitUI - Used real-world react + redux framework application. https://github.com/khaledosman/react-redux-realworld-example-app
   It has azure-pipelines.yaml which will deploy code to container apps conduitui. Currently pipelines are configured using azure devops CI\CD.
3. ConduitTerraform - IAAC to deploy conduit app. Below are the list of services created by terraform after execution,
   1. Container Registry 
   2. Postgress Database
   3. Container Apps environment
   4. Container for UI and API
   5. Resource Group
   6. Log analytics to store logs
   terraform.tfvars, terraform.vars have default values for execution.

### **Project Execution :**
Clone ConduitTerraform code in local, Execute below terraform commands in project location to create resources in azure
``` 
  terraform init
  terraform plan
  terraform apply --auto-approve

```
### **Project Walkthrough :**
- Once the above terrafrom commands are executed, contuitui and contuiapi will be created and has established connection with Postgress.
- Clone ConduitUI and ConduitAPI project to work on UI and API code changes.
- Setup service connection to azure registry and resourcegroup in azure devops.
- Update ConduitUI -> src -> agent.js -> API_ROOT for backend url if environment value is not passed. (copy url from azure container apps)
- Update ConduitAPI -> config -> settings.py -> DATABASES for default database connection if environment value is not passed
- ConduitAPI will use migrate commands in Dockerfile to execute intial table setup in postgres db.

Note:- The porject execution is success, but i am seeing CORS issue in ConduitAPI code.

### **Future Project Enhancement**

1. Terraform state file will be stored in blob.
2. Will move database credentials, azure credentials & API url to keystore for terraform and pipeline execution.
3. Setting vairables for few hardcoded values.
4. Implement ingress rules to loadbalance traffic.
5. Restricting DB access from public.

