FROM continuumio/miniconda3                                                                                   
                                                                                                              
WORKDIR /usr/src/app                                                                                          
                                                                                                              
# install apt dependencies                                                                                    
ENV DEBIAN_FRONTEND noninteractive                                                                            
RUN apt-get update && \                                                                                       
    apt-get -y install gcc libz-dev g++ unzip gzip bwa
                                                                                                              
# install dependencies: blast bedtools tabix and bgzip                                                         
RUN conda install -c bioconda blast bedtools tabix -y                                                         
                                                                                                              
# install repo and pip requirements                                                                           
RUN git clone https://github.com/HurlesGroupSanger/indelible.git # used to be eugenegardner/Indelible.git
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
# not used anymore: RUN makeblastdb -in hs37d5.fa -dbtype nucl                                                                    
RUN makeblastdb -in repeats.fasta -dbtype nucl                                                                
                                                                                                              
# add config and set final WORKDIR                                                                            
WORKDIR /usr/src/app/Indelible                                                                                
RUN mv example_config.hg19.yml config.yml                                                                          
                                                                                                              
ENV PATH="/usr/src/app/Indelible:${PATH}"                                                                     
CMD [ "python", "./indelible.py" ]                                                                            
