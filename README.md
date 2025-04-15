# HealthAdvisor: An Intelligent Agent for Interpreting Medical Test Results

## How To Run The Program

1. Running the web interface (locally)
- In terminal, type 'swipl' and hit enter
- Run "[medical_kb]." to make sure the code for the knowledge base is updated
- Run "[lab_server]." to run the code that index.html will use
- Run "start_server(8080)." to start the server on port 8080. This will allow you to view the web interface locally. Feel free to use a different port number if you prefer that

2. Running the Prolog program (in Terminal)
- In terminal, type 'swipl' and hit enter
- Run "[medical_kb]." to make sure the code for the knowledge base is updated
- NOTE: There are instructions at the bottom of medical_kb.pl if you would like to learn how to run tests locally
- NOTE: To run the testing file, run "[test_kb]." and then run "run_tests."