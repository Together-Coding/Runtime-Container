#!/bin/bash
aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin 093466323952.dkr.ecr.ap-northeast-2.amazonaws.com
docker build --no-cache -t toco-runtime-py --build-arg SSH_PRIVATE_KEY="$(cat ../toco)" .
docker tag toco-runtime-py:latest 093466323952.dkr.ecr.ap-northeast-2.amazonaws.com/toco-runtime-py:latest
docker push 093466323952.dkr.ecr.ap-northeast-2.amazonaws.com/toco-runtime-py:latest
