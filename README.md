
__Building, running and accessing.__


__Using Docker__


__From the cloud__


        docker run -d -p 8080:80 kielstr/coding_task_be
       
       
__Or build your own container__


DockerFile can be found in the root of this repository.


To build this application execute the following.

        docker build -t coding_task_be .;

Then to run it run.

        docker run -d -p 8080:80 coding_task_be
        
 
__Non Docker__

 
        curl -L http://cpanmin.us | perl - App::cpanminus;
        
        cpanm Dancer2 Starman;
        
        apt-get update && apt-get -y install wamerican;
        
        git clone https://github.com/kielstr/Coding-task-BE.git;
        
        cd Coding-task-BE;
        
        plackup -s Starman --workers=10 -p 80 -a bin/app.psgi


__Access it like..__ 

        You can ping the service.

                curl http://localhost:8080/ping


        Word building is accessed via 2 calls. 

                For version 1 of the code.
                        curl http://localhost:8080/wordfinder/dgo

                For version 2 of the code.
                        curl http://localhost:8080/wordfinder2/dgo


All questions to kielstr@cpan.org.

Enjoy!
