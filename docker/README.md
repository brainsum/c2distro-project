# Docker

## Images

The docker folder contains these folders:

- `php`
    - This is the foundation image and contains PHP, required extensions, configs and additional tooling.
    - FROM: Official PHP image.
- `builder`
    - Contains the following stages:
        - `php-base`: Built from the `php` image this contains build tools like composer.
        - `php-node-base`: Built from the `php-base` stage this contains node and required packages for `npm build`. This is also the image used for local development.
        - `node`: This only sets some node-specific defaults (e.g. workdir) for `php-node-base`
- `drupal`
    - Contains the following stages:
        - `builder`: Executes the required build steps for building the final prod code (e.g. composer install, npm run build)
        - `prod`: The `php` image with the ready-to-use source code from `builder`. Also, sets required environment variables.
- `nginx`
    - Contains the following stages:
        - `base`: Nginx with custom configuration.
        - `prod`: The `base` stage with the source code from `drupal / prod` stage.

### TODOs

- The current images lack developer tools like xdebug. We probably should add new images based on `php-node-base` with these tools. Also, we likely should add a development build, so we can use modules like `devel` on the devsite. 

---
@todo: Copied from another project, update pls.

# Docker
## Azure
#### Images
Copy used 3rd party images to the registry (note, you need to update the tags):
- `az acr import -n <ACR name> --source docker.io/wodby/nginx:1.19-5.10.0 --image wodby/nginx:1.19-5.10.0`
- `az acr import -n <ACR name> --source docker.io/library/php:7.3.20-fpm-buster --image php:7.3.20-fpm-buster`

### Image build by CI/CD

The pipeline on dev.azure.com should handle this. If there are any errors in the pipeline, they need to be fixed.
Images get built automatically on git push. The built image tags should be visible in the pipeline (the easiest way is to look at the "Push" tasks).
If this fails and there's no time to fix it, or you just want to build images for local use, see the "Image build by hand" section.

### Image build by hand
- go to the `docker` folder
- copy `example.acr.env` as `acr.env` and update it with your values  
- update `variables.env`, change `NGINX_IMAGE_TAG` and `APP_IMAGE_TAG`
    - E.g change it from `1.5.0` to `1.5.1`
- run `bash build-all.sh`
    - if it's not OK, fix the issue, otherwise continue
    - Note, if you don't want to push it and only want to test it locally, use `bash build-all.sh --without-registry`
- Once these are done, you need to push the images:
    - Get registry credentials:
        - portal.azure.com / Container registries / <ACR name> / Overview -> note the login server
        - portal.azure.com / Container registries / <ACR name> / Access keys -> note the username and any of the passwords
    - Log in to registry:
        - `docker login -u <username> -p <password> <login server>`
    - Push the images:
        - `bash push-all.sh`

### Deployment by CI/CD

This is not yet documented.

# Resources

- Nginx and PHP logging: <http://www.inanzzz.com/index.php/post/6cn7/formatting-php-fpm-and-nginx-access-logs-as-standardised-json-string-in-docker-environment>
