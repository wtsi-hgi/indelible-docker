mkdir -p ./singu

docker run -v /var/run/docker.sock:/var/run/docker.sock \
-v ~/singu:/output \
--privileged -t --rm \
quay.io/singularity/docker2singularity \
mercury/indelible:hg19_b7c7505
# mercury/indelible:6075cc1

# singularity image will now be in ./singu directory
