FROM ubuntu:18.04

RUN apt-get update \
    && apt-get install -y curl git postgresql-client telnet software-properties-common vim apt-transport-https gnupg2 \
    && apt-get update 

#RUN add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./" \
#    && curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add - \
#    && apt-get update \
#    && apt-get install heroku 

#RUN snap install --classic heroku

RUN curl https://cli-assets.heroku.com/install-ubuntu.sh | sh

CMD ["/bin/bash"]
