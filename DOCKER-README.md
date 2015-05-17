See https://registry.hub.docker.com/u/library/rails/

### Build image

docker build -t g10k-rails .

### Run dev server

docker run -v "$PWD":/usr/src/app --name g10k-rails -p 8080:3000 -d g10k-rails  # daemonizes

Then visit http://docker:8080

### Equivalent to 'bundle install'. Creates Gemfile.lock. Run build command again afterwards.

docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app ruby:2.2.1 bundle install

### Equivalent to 'rails x':

docker run -it --rm -v "$PWD":/usr/src/app -w /usr/src/app g10k-rails rails
