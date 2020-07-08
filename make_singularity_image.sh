mkdir -p ./singu

docker run -v /var/run/docker.sock:/var/run/docker.sock \
-v ~/singu:/output \
--privileged -t --rm \
quay.io/singularity/docker2singularity \
mercury/indelible:6dbe32d72ad4ef707d0fbf66dac72aa7acdedfbc

# singularity image will now be in ./singu dur
