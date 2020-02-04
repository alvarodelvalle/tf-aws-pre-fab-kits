#!/bin/bash
sudo yum update -y
curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.rpm.sh | sudo bash
sudo yum install gitlab-runner docker -y

sudo gitlab-runner register \
--non-interactive \
--url "https://gitlab.com/" \
--registration-token "z3zW2Mag46JwaxZJiAjj" \
--executor "docker" \
--docker-image node:latest \
--description "docker-runner" \
--tag-list "docker, us-west-1, t2.medium" \
--run-untagged="true" \
--locked="false" \
--access-level="not_protected"

sudo service docker start
