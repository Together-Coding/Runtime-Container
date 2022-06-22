# Runtime-Container

**Runtime-Container** has several `Dockerfile`s used to build container images for each supported languages. For now, GCC and Python are available.  
When building an image, it installs [Runtime-Agent](https://github.com/Together-Coding/Runtime-Agent) code from Github and sets a command to run the `FastAPI` server.
It allows users on [web IDE](https://github.com/Together-Coding/Client) to execute code at the container remotely through SSH relay. Therefore, SSH daemon runs to allow connections from localhost.



## What it does

1. Download [Runtime-Agent](https://github.com/Together-Coding/Runtime-Agent) from Github in an intermediate image.
2. Use one of the official images that has an environment for executing code.
3. Make directories for runtime-agent server and user's code.
4. Copy runtime-agent from the intermediate image and install packages.
5. Run SSH daemon and runtime-agent server.



## Note

### [Multi-stage Builds](https://docs.docker.com/develop/develop-images/multistage-build/)

Runtime-Container should install [Runtime-Agent](https://github.com/Together-Coding/Runtime-Agent) to handle requests from outside, to be monitored by [Runtime-Bridge](https://github.com/Together-Coding/Runtime-Bridge), and so on. Because previously that repository was private, Github credentials are required to download it at the build stage. But it makes project vulnerable to use secrets in a normal build stage.  
By referring [build-docker-image-clone-private-repo-ssh-key](https://vsupalov.com/build-docker-image-clone-private-repo-ssh-key/), it was implemented to use multi-stage builds to hide secrets.


### Public subnet

Currently, the containers are deployed in a public subnet, which means users can access the container directly with its public IP address and port number. 
Much to my regret, it was a huge mistake and must make vulnerabilities. But when I noticed it, there was no time left to fix it. 
If I had had much time, I would have implemented [in this way](https://github.com/Together-Coding/Runtime-Bridge#note).


## Build and Deployment

1. Generate a new SSH key that has a read permission, and add it to Github. See more details from [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent) and [here](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).
1. Copy the private SSH key to the root directory of this project.  
    `$ cp /path/to/private/key ./toco`
1. Configure AWS credentials to deploy the built images to AWS ECR. See [this document](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html) to configure.
1. Run deployment script in the directory of the language you want to deploy.  
    `$ . push.sh`
