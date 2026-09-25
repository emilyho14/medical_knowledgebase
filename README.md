# HealthAdvisor: An Intelligent Agent for Interpreting Medical Test Results

## HOW TO RUN THE PROGRAM

### Web interface locally

Install SWI-Prolog, then from this directory run:

```sh
swipl -q -g "lab_server:start_server(8080)" -s lab_server.pl
```

Open <http://localhost:8080>. Use another port by changing `8080` in the command.

### Tests

```sh
swipl -q -g "consult('test_kb.pl'), run_tests, halt."
```

The Docker image uses the same `lab_server.pl` entry point and listens on port 5000.

## HOW TO BUILD THIS CURRENT PROGRAM

- right now, we manually created some rules
- keep track of ranges and discuss where the resources the ranges are from
- now, next step is to see how LLMs can expand the program with more knowledge
- can it generate Prolog progam to encode knowledge about lab test results ... it might generate something
- grab the facts or normal values and incorporate it into my program
- idea = my validating knowledge here and my rules, but to scale up and cover more values, leverage LLMs to do this automatically or semi-automatically
- one-by-one until finish things, use LLMs to expand
- extract values of resources and put it to be read in a certain formation for the Prolog program
- how to leverage LLMs to enhance program or expand the program
- detect 'close' boundary values and see if 'normal' or 'not'... what would the risks be for the patient if any
- get in touch with Kevin via Cheng ??
- HTML page and embed some sort of action with a button
- button action points to executible that will be put with CGI directory/file
- then use the code to generate output to show on the web
- want generate page to respond to button... include reference to another executable

- k+1 testing ... optimalized parameters mush be changed for a new task
- new parameter/task, then you must change some old parameter(s) to accomplush the new task compared to the old task since it might not be as optimized

## TERMINAL COMMANDS:

### Enter Server:

- ssh eeho2@timan.cs.illinois.edu
  - Login as per usual
- cd ..
- cd /var/www/html/eeho2
  - Or get to wherever /var/www/html/eeho2
  - ls to make sure index.html is there
- pwd to see current directory

### Enter a File:

- emacs \_\_\_<file name>

### Save with Emacs:

- Ctrl + x
- Ctrl + s
- Ctrl + x
- Ctrl + c

### Exit with Emacs:

- Ctrl + x
- Ctrl + c

### Select All and Delete:

- ctrl + x, then press h
- 'Delete'
