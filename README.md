To build this application execute the following.

        docker build -t coding_task_be .;

Then to run it run

        docker run -p 8080:8080 coding_task_be

Then you can access it like 

        you can ping the service

                curl http://localhost:8080/ping


        word building is access via 2 calls 

                for version 1 of the code
                        curl http://localhost:8080/wordfinder/dgo

                for version 2 of the code
                        curl http://localhost:8080/wordfinder2/dgo


All query to kielstr@cpan.org.

Enjoy!
