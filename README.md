**Description**

  - The application contains two endpoints: /ad, /ad-event

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

  - You can standup the application on your laptop with included docker-compose.yml file.

```
cd app
docker-compose up -d
```

  - To deploy to ECS with autoscaling groups
  
    - the deploy folder contains the Terraform files

    - these files are relevant:
      
      - main.tf - the main entry file for Terraform.  It creates the VPC and securely deploys the application on ECS.
      - terraform.tfvars - modify this to control some parameters for deploying the application
      - modules/iam_roles - a Terraform module for IAM roles to restrict and allow permissions on AWS
      - modules/alb - a Terraform module for the Application load balancer that "services" or makes the application accessible.
      - modules/ecs_asg - a Terraform module that creates the Autoscaling group that automatically scale and up down according to CPU 
      - modules/ecs_tasks - a Terraform module performs the ECS deployment of the application
      - modules/security_groups - a Terraform module that creates the security groups for the load balancer and the ECS servers

    - for example, to deploy on AWS
     
      - modify the parameterized variables in terraform.tfvars

      - install the Terraform according to the version in version.tf

      - perform the initial install and creation of resources and application with the following commands:

```
terraform init
terraform plan
terraform apply
```

**Zero-time Deploy **
    
      Terraform will automatically redeploy the application when you specifically change the deploy_name.  To automate this, you can create a hash or unique deploy identifier that for example is derived from the image references and date. For implementing a complete CI/CD solution, you can take the image reference with the commit hash and then create a deploy identifier with the image references and the date of the deploy.  This can be implemented on your choice of a CI system.  Please read the below about CI/CD.

```
terraform plan
terraform apply
```

**CI/CD **

Continuous delivery (CD) automatically executes unit tests, performs docker builds, and provides automatic deployments.  Users have the option of using a variety of continuous integration (CI) tools such as SaaS products like CircleCI and TravisCI, and more customizable open source options like ConcourceCI and Jenkins.  The SaaS provides will also handle the plumbing (Webhooks/GitOps) like connecting Github/Bitbucket to the CI system. Again, the main criteria is control vs resources; having more control requires more skilled people.  Regardless, any CI system will increase your software velocity, while producing more reliable software. It is truly a win-win situation. To extend CI to CD, it suggested users implement GitOps to control and version deployments through git commits. It is also recommended users practice blue/green canary deploys to safely and progressively cut over to new software without having to schedule downtime.
