#!/bin/bash

declare -a results

measure_time() {
  local name="$1"
  shift
  local start end elapsed
  start=$(date +%s.%N)
  "$@"
  end=$(date +%s.%N)
  elapsed=$(echo "$end - $start" | bc)
  results+=("$name"$':\t\t'"$elapsed")
}

measure_time "Docker build uber" docker build -t another-image:uber -f uber.Dockerfile .
measure_time "Docker build plain" docker build -t another-image:plain -f plain.Dockerfile .
measure_time "Maven native build" ./mvnw -Pnative -Dspring-boot.build-image.imageName=another-image:native spring-boot:build-image

echo
echo "Summary of command durations:"
printf "%s\n" "${results[@]}" | column -t -s $'\t'

echo
echo "Summary of images:"
docker image ls | grep another-image
