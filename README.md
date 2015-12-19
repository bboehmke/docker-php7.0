# PHP 7 FPM

PHP 7 FPM daemon as docker image

## Usage

Start the container with:
```sh
docker run -d --name=php7 \
    --restart=always \
    -v /run/php7:/run/php \
    -v /srv/www:/srv/www \
    bboehmke/php7.0
```

Use the FPM socket "/run/php7/php7.0-fpm.sock" in NGINX.

Note: All files used in PHP scripts must have the same path in the conatiner 
as on the host. In this case all files are in "/srv/www".
