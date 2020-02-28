**Description**

  - The application that contains two endpoints: /ad, /ad-event

  - The application consist of three microservices: 

| microservice      | description                            
| ------------- | -------------------------------------- 
| get   | receives an http get and registers the request in logs
| post   | receives an http post and registers the request in logs
| nginx      | the proxy that serves out the application
    
**File Layout**

```
```

**Build**

  - The application is found in the "app" folder

  - Each microservice is separated into their own folder with a Dockerfile used for building the image.

  - For example, to build the app microservice and push it to Dockerhub:

```
cd get
docker build -t <docker_username>/ms-app-get:latest .
docker login -u <username> -p <password>
docker push <docker_username>/ms-app-get:latest

cd post
docker build -t <docker_username>/ms-app-post:latest .
docker login -u <username> -p <password>
docker push <docker_username>/ms-app-post:latest
```

**Deploy**

  - To deploy, you can standup the application on your laptop by using using the docker-compose.yml file in the app folder.

```
docker-compose up -d
```

  - To deploy to ECS and autoscaling groups
  
    - use the "deploy" folder that contains the Terraform files

    - the deploy is separated into Terraform modules:
      
      - main.tf - the main entry file for Terraform.  It creates the VPC and securely deploys the application on ECS.
      - terraform.tfvars - modify this to control some parameters for deploying the application
      - modules/iam_roles - the IAM roles to restrict and allow permissions on AWS
      - modules/alb - the Application load balancer that "services" or makes the application accessible.
      - modules/ecs_asg - the Autoscaling group that automatically scale and up down according to CPU 
      - modules/ecs_tasks - the ECS deployment of the application
      - modules/security_groups - the security groups created for both the load balancer and the ECS servers

    - to deploy
     
      - modify the parameterized variables in

```
terraform.tfvars
```

    - install the Terraform according to the version in version.tf

    - perform the initial install and creation of resources and application
```
terraform init
terraform plan
terraform apply
```
    - to do a zero-time deploy, update the docker images and the deploy_name accordingly in terraform.tfvars
```
terraform plan
terraform apply
```

**CI/CD **

Continuous delivery (CD) automatically executes unit tests, performs docker builds, and provides automatic deployments.  Users have the option of using a variety of continuous integration (CI) tools such as SaaS products like CircleCI and TravisCI, and more customizable open source options like ConcourceCI and Jenkins.  The SaaS provides will also handle the plumbing (Webhooks/GitOps) like connecting Github/Bitbucket to the CI system. Again, the main criteria is control vs resources; having more control requires more skilled people.  Regardless, any CI system will increase your software velocity, while producing more reliable software. It is truly a win-win situation. To extend CI to CD, it suggested users implement GitOps to control and version deployments through git commits. It is also recommended users practice blue/green canary deploys to safely and progressively cut over to new software without having to schedule downtime.
