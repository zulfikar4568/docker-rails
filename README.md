# Docker Ruby on Rails
This repository is used for doing Ruby on Rails Development. The repository has been tested in linux Ubuntu 20.04.</br>
© M. Zulfikar Isnaen [MIT License](LICENSE)

# Using this Repository
Make sure you have:
* docker
* docker-compose </br>
If you doesn't have please install first in [Official Docker](https://docs.docker.com/engine/).
```bash
docker --version
docker-compose --version
```
You should be get like this, if have
```
Docker version 20.10.12, build e91ed57
docker-compose version 1.29.2, build 5becea4c
```

Clone this repository using this in your folder
```bash
git clone https://github.com/zulfikar4568/docker-rails.git
```

## Creating Rails Application via Utility Rails

```bash
docker-compose run --rm rails_util rails new .
```
After we execute above command we will see the our Rails files in `src` folder

## Running Rail Application
> Using this command when we will an updated the images
```bash
docker-compose up -d --build rails_web
docker attach rails_web #for interact with your server
```
> Otherwise we can use this command, that will not updated a images
```bash
docker-compose up -d rails_web
```
Open `localhost:3000`. Congratulations you've get the Rails 7.0.1 up and running wihout install dependencies rails in your host instead in our docker files.
## Error when running Rails Application (Optional)
If you get an error like this `
error checking context: 'no permission to read from '/home/zulfikar/Docker/docker-rails/src/config/master.key''.
ERROR: Service 'rails_web' failed to build : Build failed`. This problem facing with your permission. Try using this command:
```
sudo chmod -R 777 ./src
```

## Try generate Articles using Utility Rails
```
docker-compose run --rm rails_util rails generate migration create_articles
```

## Create alias for Utility rails_util on bashrc `ror` 
Using `docker-compose run --rm rails_util`  probably will hard when doing development since the command too long, instead doing that better we create alias on `.bashrc` file.
```bash
sudo nano ~/.bashrc
```
add command below
```
alias rm='docker-compose run --rm rails_util'
```
exit and type
```bash
source ~/.bashrc
```
Notes: Using alias **Make sure you have already on docker-rails project folder**

We can generate something only use `ror` instead `docker-compose run --rm rails_util`, for example
```bash
ror rails new .
#instead doing this
docker-compose run --rm rails_util rails new .
```

## Interact with rails console
```bash
ror rails c
# or
docker exec -it rails_web /bin/bash
# type irb on bash rails_web
irb
```

## Create simple app using [rails](./SimpleApp.md)