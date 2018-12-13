Fork from the cloudbees jenkins docker image with customizations
At the moment, Jenkins is a little picky about the UID thats used to reach the docker daemon on the host when we mount the binary and socket
We should set the docker daemon and socket to start as a specific user, or, just put this on hold for the moment and run jenkins remotely - (in favor of this option)
