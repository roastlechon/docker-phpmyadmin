# Docker: PhpMyAdmin

This is a docker image for setting up PhpMyAdmin. This uses [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker) base Ubuntu image, which takes care of [basic necessities any docker container needs.](https://github.com/phusion/baseimage-docker#why-use-baseimage-docker)

## Try it out!

Make sure you have a MySQL database with appropriate user access.

```bash
git clone repo
cd docker-phpmyadmin

# Builds a Docker image named "docker-phpmyadmin" from the current directory.
sudo docker build -t docker-phpmyadmin .

# Creates a new container based on the Docker image "docker-phpmyadmin".
sudo docker run --name phpmyadmin -p 80:80 -e MYSQL_HOST=mysqlhost -e NGINX_SERVERNAME=localhost -d docker-phpmyadmin /sbin/my_init --enable-insecure-key
```

* `docker run` - Creates and runs a new Docker container based off an image.
* `--name phpmyadmin` - Gives the container a name.
* `-p 80:80` - Binds local port 80 to the container's port 80.
* `-e MYSQL_HOST=mysqlhost -e NGINX_SERVERNAME=localhost` - Uses environmental variables to connect to MySQL instance. NGINX_SERVERNAME changes the nginx server_name config while MYSQL_HOST changes the MySQL host in config.inc.php
* `-d docker-phpmyadmin` - Uses the image "docker-phpmyadmin" to create the Docker container.
* `/sbin/my_init` - Runs the init scripts used to kick off long-running processes and other bootstrapping, as per [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker).
* `--enable-insecure-key` - Enables an insecure key to be able to SSH into the container, as per [phusion/baseimage-docker](https://github.com/phusion/baseimage-docker).

# Usage with a MySQL container

You can use this image in conjunction with a MySQL container and [link them together](http://docs.docker.io/en/latest/use/working_with_links_names/). Note that you must have the MySQL container running first. 

For example:

`sudo docker run -p 80:80 -e MYSQL_HOST=mysqlhost -e NGINX_SERVERNAME=localhost --link mysql:phpmyadmin_mysql -d docker-phpmyadmin /sbin/my_init --enable-insecure-key`

* `--link mysql:phpmyadmin_mysql` - Links the container and specifies the container to link to and the alias. The container to link to and the alias are separated by a colon.

## List of environmental variables
* `MYSQL_HOST` - Hostname of MySQL database. This assumes that its not running in the same container as Teamspeak, but a remote database (could be different container or on the host itself).
* `NGINX_SERVERNAME` - Server name for nginx config.