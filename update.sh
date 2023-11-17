#!/bin/bash --login

source /usr/share/rvm/scripts/rvm
rvm use 3.0.0
cd ~/blogs/blog.bagdemir.com.2023 && git pull origin main 
cd ~/blogs/blog.bagdemir.com.2023 && bundle && jekyll build
