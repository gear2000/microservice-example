**Description**

  - The application receives a message, and returns the message reversed along with a random number.

  - There are three microservices that are used together: 

| microservice      | description                            
| ------------- | -------------------------------------- 
| app   | the main entry point that injects a random number to the response
| transform      | the second microservice that returns a message reversed
| nginx      | the proxy that serves out the application
    

**Build**

  - Each microservice is separated into their own folder with a Dockerfile used for building the image.

  - For example, to build the app microservice and push it to Dockerhub:

```
cd app
docker build -t <docker_username>/app:latest .
docker login -u <username> -p <password>
docker push <docker_username>/app:latest

```

**Deploy**

  - To deploy, you can standup the application on your laptop by using using the docker-compose.yml file.

```
docker-compose up -d

```

  - To deploy to ECS:

    - Install ECS CLI

```
curl -o /usr/local/bin/ecs-cli https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest
echo "$(curl -s https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest.md5) /usr/local/bin/ecs-cli" | md5sum -c -
chmod +x /usr/local/bin/ecs-cli
```

    - Configure ECS profile and cluster
```
export AWS_ACCESS_KEY_ID=<aws_access_key_id>
export AWS_SECRET_ACCESS_KEY=<aws_secret_access_key>
ecs-cli configure profile --profile-name test --access-key $AWS_ACCESS_KEY_ID --secret-key $AWS_SECRET_ACCESS_KEY
ecs-cli configure --cluster test --region us-east-1 --default-launch-type EC2 --config-name diginex
```

    - Create ECS cluster
```
ecs-cli up --keypair ed_ssh_key --capability-iam --size 1 --instance-type t2.micro --cluster test
```

    - Standup application as a ECS task
```
ecs-cli compose service up --cluster test --cluster-config diginex
```

    - View cluster processes/status
```
ecs-cli ps --cluster test
```

    - Increase cluster size
```
ecs-cli scale --capability-iam --size 2 --cluster test
```

    - Scale service to create redundancy and performance
```
ecs-cli compose service scale 2 --cluster test --cluster-config diginex
```

    - Tear down tasks when done
```
ecs-cli compose service down --cluster test --cluster-config diginex
```

    - Tear down cluster when done
```
ecs-cli down --cluster test
```
