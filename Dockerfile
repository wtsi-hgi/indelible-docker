FROM continuumio/miniconda3                                                                                   
                                                                                                              
WORKDIR /usr/src/app                                                                                          
                                                                                                              
# install apt dependencies                                                                                    
ENV DEBIAN_FRONTEND noninteractive                                                                            
RUN apt-get update && \                                                                                       
    apt-get -y install gcc libz-dev g++ unzip gzip                                                            
                                                                                                              
# install dependencies: blast bedtools tabix and bgzip                                                         
RUN conda install -c bioconda blast bedtools tabix -y                                                         
                                                                                                              
# install repo and pip requirements                                                                           
RUN git clone https://github.com/eugenegardner/Indelible.git                                                  
WORKDIR /usr/src/app/Indelible                                                                                
RUN pip install cython                                                                                        
RUN pip install -r requirements.txt                                                                           
                                                                                                              
# Unzip required data files                                                                                   
WORKDIR /usr/src/app/Indelible/data/                                                                          
RUN unzip data_hg19.zip                                                                                           
## Download windowmasker:                                                                                     
RUN wget ftp://ftp.ncbi.nlm.nih.gov/blast/windowmasker_files/9606/wmasker.obinary                             
## Download the GRCh37 human reference and create the blast, and gunzip.                                      
COPY hs37d5.fa .                                                                                              
COPY hs37d5.fa.fai .                                                                                     
RUN ls -ltra                                                                                                  
RUN makeblastdb -in hs37d5.fa -dbtype nucl                                                                    
RUN makeblastdb -in repeats.fasta -dbtype nucl                                                                
                                                                                                              
# add config and set final WORKDIR                                                                            
WORKDIR /usr/src/app/Indelible                                                                                
RUN mv example_config.yml config.yml                                                                          
                                                                                                              
ENV PATH="/usr/src/app/Indelible:${PATH}"                                                                     
CMD [ "python", "./indelible.py" ]                                                                            
                                                                                                              
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
