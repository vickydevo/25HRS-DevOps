## Dockerfile Directives: WORKDIR, MAINTAINER, COPY vs ADD

### 1. `WORKDIR`
Sets the working directory inside the container. All subsequent commands run from this directory.

```Dockerfile
FROM nginx
WORKDIR /usr/share/nginx/html
```
To install `vim` inside a running container, use:

```bash
docker exec -it <container_name_or_id> bash
apt-get update && apt-get install vim -y
```
To edit `index.html` inside the container using `vim`, run:

```bash
vim /usr/share/nginx/html/index.html
```
This opens a shell inside the container, updates package lists, and installs `vim`.
### 2. `MAINTAINER`
Sets the author/maintainer info (deprecated, use `LABEL` instead).

```Dockerfile
FROM httpd
LABEL "author"=vignan1
MAINTAINER vignan@example.com
WORKDIR /tmp
```

> **Note:** Prefer `LABEL maintainer="vignan@example.com"` for modern Dockerfiles.

### 3. `COPY` vs `ADD`
- `COPY`: Copies files/directories from build context to container.
- `ADD`: Like `COPY`, but can also extract local archives and fetch remote URLs.

#### Example with `COPY`:
```Dockerfile
FROM httpd
COPY ./index.html /usr/share/nginx/html/index.html
```

#### Example with `ADD`:
```Dockerfile
FROM nginx
ADD https://dlcdn.apache.org/maven/maven-3/3.9.11/binaries/apache-maven-3.9.11-bin.tar.gz /opt
```
*(This extracts `site.tar.gz` into the target directory)*

---

### Full Example Dockerfile

```Dockerfile
FROM httpd
LABEL maintainer="vignan@example.com"
WORKDIR /usr/share/nginx/html
COPY ./index.html .
ADD ./images.tar.gz ./images/
```

---

**Summary Table**

| Directive   | Purpose                                      | Example Usage                        |
|-------------|----------------------------------------------|--------------------------------------|
| WORKDIR     | Set working directory                        | `WORKDIR /app`                       |
| MAINTAINER  | Set author/maintainer (deprecated)           | `MAINTAINER vignan@example.com`      |
| LABEL       | Modern way to set metadata                   | `LABEL maintainer="vignan@example.com"` |
| COPY        | Copy files/directories                       | `COPY ./src /app/src`                |
| ADD         | Copy + extract archives/fetch URLs           | `ADD site.tar.gz /app/`              |

### ENTRYPOINT vs CMD

Both `ENTRYPOINT` and `CMD` define what runs when a container starts, but they behave differently:

| Directive    | Purpose                                   | Overridable?         | Typical Usage                |
|--------------|-------------------------------------------|----------------------|------------------------------|
| ENTRYPOINT   | Sets the main command to run              | Arguments appended   | Always runs, like a binary   |
| CMD          | Provides default arguments or command     | Fully overridable    | Defaults, can be replaced    |

#### Example 1: Using `CMD` (busybox image)

```Dockerfile
FROM busybox
CMD ["echo", "Hello from CMD!"]
```
- Running `docker run busybox` prints: `Hello from CMD!`
- Running `docker run busybox echo Goodbye` prints: `Goodbye` (CMD is replaced).

#### Example 2: Using `ENTRYPOINT` (busybox image)

```Dockerfile
FROM busybox
ENTRYPOINT ["echo", "Hello from Dockerfile!"]
```
- Running `docker run busybox` prints: `Hello from ENTRYPOINT!`
- Running `docker run busybox Goodbye` prints: `Hello from Dockerfile! Goodbye` (arguments appended).

#### Example 3: Combining `ENTRYPOINT` and `CMD`

```Dockerfile
FROM busybox
ENTRYPOINT ["echo"]
CMD ["Default message"]
```
- Running `docker run busybox` prints: `Default message`
- Running `docker run busybox Custom message` prints: `Custom message`

**Summary:**  
- `ENTRYPOINT` is for the main command; arguments can be added.
- `CMD` is for defaults; can be fully overridden.
- Use both for flexible containers.

## How the Dockerfile Automates Manual Deployment Tasks

- **Automated JRE Installation:**  
  The Dockerfile's `FROM eclipse-temurin:21-jre-noble` line ensures the correct Java Runtime Environment is installed automatically, so you don't need to manually set up Java on the server.

- **Seamless JAR File Transfer:**  
  The `COPY` command in the Dockerfile moves your built `.jar` file into the container, eliminating the need for manual file transfer tools like SCP or FTP.

- **Predefined Application Startup:**  
  The `ENTRYPOINT ["java","-jar","app.jar"]` instruction specifies the exact command to run your application, so you don't have to SSH into the server and start it manually.

- **Dependency Management:**  
  The build stage (`RUN mvn clean package`) downloads all required dependencies and packages them into the JAR, so you don't need to manage libraries or classpaths yourself.

- **Consistent Environment:**  
  Docker bundles the OS, Java version, and all dependencies into the image, ensuring your app runs the same everywhere and eliminating "works on my machine" issues.

  # Sample Multi-Stage Dockerfile
  Below is an example of a multi-stage Dockerfile for building and running a Java Spring Boot application. This approach uses Maven for building the JAR file in the first stage and a lightweight Java runtime for running the application in the second stage. Multi-stage builds help reduce image size and separate build dependencies from runtime.


