#!/bin/sh
set -ex

#export DOCKER_BUILDKIT=0

image="postgres22"

docker_scripts=$(readlink -e "$(dirname "$0")")
dockerfile="${docker_scripts}/Dockerfile"

if env | grep -i proxy
then
  http_proxy=${http_proxy}
  https_proxy=${https_proxy}
  proxy_flags="--network=host --build-arg HTTP_PROXY=${http_proxy} --build-arg HTTPS_PROXY=${https_proxy}"
fi

ubuntu_year=$(echo ${image} | sed 's/postgres//')
base_image=ubuntu:${ubuntu_year}.04

# shellcheck disable=SC2086
docker build \
  --tag ${image} \
  -f "${dockerfile}" \
  --build-arg BASE_IMAGE="${base_image}" \
  --build-arg USER_ID="$(id -u)" \
  --build-arg GROUP_ID="$(id -g)" \
  ${proxy_flags} \
  .

ws_dir=$(readlink -e "${docker_scripts}/workspace")

mkdir -p "${ws_dir}"

docker run \
  --rm -ti \
  --volume "${ws_dir}":/home/tony/workspace \
  --workdir /home/tony/workspace \
  --network host \
  --hostname pgcont \
  --name pgcont \
  --add-host pgcont:127.0.0.1 \
  "${image}" "$@"
