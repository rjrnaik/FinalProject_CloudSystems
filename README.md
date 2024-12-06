# FinalProject_CloudSystems
Github repository for Final Project for Cloud Systems
# Create Docker Image
## Run the below steps in command prompt:
>**Note:** Replace the placeholders (`<image-name>`, `<tar-file-creation-name>`, `<container-name>`, `<docker-image-name>`, `<tar-file-name>`) with appropriate values based on your project.
1. Create Docker file in your project directory
	Right click -> Create docker

2. With help of created docker file, we created docker image using below command:
```sh
docker build -t <image-name>
```
![Logo](/screenshot/Picture1.png "Picture")

3. Created tar file using below command:
```sh
docker save -o <tar-file-creation-name> <docker-image-name>
```
![Logo](/screenshot/4_create_tarfile.png "Picture")

4. Upload the created tar file in Cloud9 environment manually

5. Run below command to save docker image in Cloud9(it will extract docker image from tar file uploaded in previous step)
```sh
docker load <tar-file-name>
```
![Logo](/screenshot/5_importtartocloud9.png "Picture") 

6. Run the docker command below (it will create and start the docker container)
```sh
docker run -d -p 5000:5000 --name <container-name> <docker-image-name>
```
(Note : 5000:5000 is port number specified in app.py)
![Logo](/screenshot/6_rundockercontainer.png "Picture") 

7. Verify the container is running
```sh
docker ps
```
