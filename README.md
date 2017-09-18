Use the following DockerFile.

FROM        perl:latest
MAINTAINER  Kiel R Stirling kielstr@cpan.org

RUN curl -L http://cpanmin.us | perl - App::cpanminus

RUN cpanm Dancer2 Starman

RUN apt-get update && apt-get -y install wamerican

ARG CACHE_DATE=2016-01-02

RUN git clone https://github.com/kielstr/Coding-task-BE.git

EXPOSE 80

WORKDIR Coding-task-BE

CMD plackup -s Starman --workers=10 -p 80 -a bin/app.psgi


__Building, running and accessing.__


To build this application execute the following.

        docker build -t coding_task_be .;

Then to run it run.

        docker run -p 8080:8080 coding_task_be

Then you can access it like. 

        you can ping the service.

                curl http://localhost:8080/ping


        word building is accessed via 2 calls. 

                for version 1 of the code.
                        curl http://localhost:8080/wordfinder/dgo

                for version 2 of the code.
                        curl http://localhost:8080/wordfinder2/dgo


All questions to kielstr@cpan.org.

Enjoy!
