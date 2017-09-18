
__Building, running and accessing.__

__From the cloud__

        docker run -d -p 8080:80 kielstr/coding_task_be

__Building__


Use the DockerFile found in the root of this repository.


To build this application execute the following.

        docker build -t coding_task_be .;

Then to run it run.

        docker run -d -p 8080:80 coding_task_be

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
