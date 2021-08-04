# image build instructions

# first get required files with:
# wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz
# gunzip hs37d5.fa.gz                                                                                         
# wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz.fai 
# cp hs37d5.fa.gz.fai hs37d5.fa.fai                                                                           

COMMIT=$(git rev-parse --short HEAD)
echo commit $COMMIT
REPO_TAG="mercury/indelible:hg19_$COMMIT"
echo repo tag $REPO_TAG
sudo docker build . -t $REPO_TAG
echo built docker image $REPO_TAG


# image build instructions                                                                                    
# wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz
# gunzip hs37d5.fa.gz                                                                                         
# wget ftp://ftp-trace.ncbi.nih.gov/1000genomes/ftp/technical/reference/phase2_reference_assembly_sequence/hs37d5.fa.gz.fai 
# cp hs37d5.fa.gz.fai hs37d5.fa.fai                                                                           
# sudo docker build .                                                                                         
# get image id                                                                                                
# sudo docker image list                                                                                      
# tag image id with indelible commit:                                                                         
# sudo docker tag 9f73029552b6 mercury/indelible:6dbe32d72ad4ef707d0fbf66dac72aa7acdedfbc                     
# after creating mercury/indelible repo in Dockerhub:                                                         
# sudo docker login --username mercury                                                                        
# sudo docker push mercury/indelible:6dbe32d72ad4ef707d0fbf66dac72aa7acdedfbc   
