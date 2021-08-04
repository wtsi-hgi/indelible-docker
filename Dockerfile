FROM continuumio/miniconda3                                                                                   
                                                                                                              
WORKDIR /usr/src/app                                                                                          
                                                                                                              
# install apt dependencies                                                                                    
ENV DEBIAN_FRONTEND noninteractive                                                                            
RUN apt-get update && \                                                                                       
    apt-get -y install \
    ncbi-blast+ \
    gcc make libcurl4-gnutls-dev zlib1g-dev libncurses5-dev pkg-config \
    libncursesw5-dev liblzma-dev libz-dev g++ unzip gzip bwa libssl-dev \
    libbz2-dev liblzma-dev build-essential samtools -y

# install repo and pip requirements                                                                           
RUN git clone https://github.com/HurlesGroupSanger/indelible.git # used to be eugenegardner/Indelible.git
WORKDIR /usr/src/app/indelible                                                                                
RUN which python
RUN which pip
RUN pip install numpy Cython
RUN pip install -r requirements.txt                                                                           
                                                                                                              
# install dependencies: blast bedtools tabix and bgzip                                                         
RUN conda update conda
RUN conda update --all
RUN conda install --channel conda-forge -c bioconda htslib blast bedtools cython tabix -y
                                                                                                              
                                                                                                              
# Unzip required data files                                                                                   
WORKDIR /usr/src/app/indelible/data/                                                                          
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
WORKDIR /usr/src/app/indelible                                                                                
RUN mv example_config.hg19.yml config.yml                                                                          
                                                                                                              
ENV PATH="/usr/src/app/indelible:${PATH}"                                                                     
CMD [ "python", "./indelible.py" ]                                                                            
