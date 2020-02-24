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
|-- post
|   |-- bin
|   |   |-- run.py
|   |   `-- run.sh
|   |-- Dockerfile
|   `-- requirements.txt
|-- nginx
|   |-- default.conf
|   `-- Dockerfile
|-- get
|   |-- bin
|   |   |-- run.py
|   |   `-- run.sh
|   |-- Dockerfile
|   `-- requirements.txt
|-- docker-compose.yml
|-- ecs-params.yml
`-- README.md
```

**Build**

  - Each microservice is separated into their own folder with a Dockerfile used for building the image.

  - For example, to build the app microservice and push it to Dockerhub:

```
cd get
docker build -t <docker_username>/ms-get:latest .
docker login -u <username> -p <password>
docker push <docker_username>/ms-get:latest
```

**Deploy**

  - To deploy, you can standup the application on your laptop by using using the docker-compose.yml file.

```
docker-compose up -d
```

  - To deploy to ECS:

Create ECS cluster with autoscaling groups

Standup application as a ECS task
```
ecs-cli compose service up --cluster test --cluster-config sample
```

View cluster processes/status
```
ecs-cli ps --cluster test

Tear down tasks when done
```
ecs-cli compose service down --cluster test --cluster-config sample
```

**CI/CD **

Continuous delivery (CD) automatically executes unit tests, performs docker builds, and provides automatic deployments.  Users have the option of using a variety of continuous integration (CI) tools such as SaaS products like CircleCI and TravisCI, and more customizable open source options like ConcourceCI and Jenkins.  The SaaS provides will also handle the plumbing (Webhooks/GitOps) like connecting Github/Bitbucket to the CI system. Again, the main criteria is control vs resources; having more control requires more skilled people.  Regardless, any CI system will increase your software velocity, while producing more reliable software. It is truly a win-win situation. To extend CI to CD, it suggested users implement GitOps to control and version deployments through git commits. It is also recommended users practice blue/green canary deploys to safely and progressively cut over to new software without having to schedule downtime.
