
## How to Push a Docker Image to Docker Hub: Step-by-Step

1. **Create a Docker Hub Account**
  - Sign up at [https://hub.docker.com/](https://hub.docker.com/) if you don't have an account.

2. **Log in to Docker Hub from your terminal**
  ```bash
  docker login
  or
  docker login -u vigna2025
  ```
  - Enter your Docker Hub username and password when prompted.

3. **Tag your image for Docker Hub**
  - Format: `<dockerhub-username>/<repository-name>:<tag>`
  ```bash
  docker tag myimage:latest yourusername/myrepo:latest
  ```

4. **Push the image to Docker Hub**
  ```bash
  docker push yourusername/myrepo:latest
  ```

5. **Verify the image on Docker Hub**
  - Visit your Docker Hub repository page to confirm the image is uploaded.

**Example Workflow:**
```bash
docker build -t myapp:1.0 .
docker tag myapp:1.0 vignan1/myapp:1.0
docker login
docker push vignan1/myapp:1.0
```

> **Tip:** Replace `vignan1` with your Docker Hub username and `myapp` with your repository name.

**Now your image is available for anyone to pull:**
```bash
docker pull vignan1/myapp:1.0
```