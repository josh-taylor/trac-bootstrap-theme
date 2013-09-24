BUILD_FOLDER=build
PROJECT_NAME=test-project
BUILD_PROJECT=${BUILD_FOLDER}/${PROJECT_NAME}


run:
	cp -r htdocs/* ${BUILD_PROJECT}/htdocs
	cp -r templates/* ${BUILD_PROJECT}/templates
	echo "Autenticate with: username/password"
	${BUILD_FOLDER}/bin/tracd --port 8080 \
		--basic-auth="${PROJECT_NAME},${PWD}/${BUILD_FOLDER}/htpasswd,realm" \
		${BUILD_PROJECT}


deps: clean
	virtualenv ${BUILD_FOLDER}
	@echo "Installing trac will take a while..."
	${BUILD_FOLDER}/bin/pip install trac==1.0
	${BUILD_FOLDER}/bin/trac-admin ${BUILD_PROJECT} \
		initenv Test-Project sqlite:db/trac.db
	htpasswd -b -c  ${BUILD_FOLDER}/htpasswd username password
	mkdir -p ${BUILD_PROJECT}/htdocs/css
	mkdir -p ${BUILD_PROJECT}/htdocs/js
	mkdir -p ${BUILD_PROJECT}/htdocs/fonts
	wget -q \
    	http://netdna.bootstrapcdn.com/bootstrap/3.0.0/css/bootstrap.css\
    	-O ${BUILD_PROJECT}/htdocs/css/bootstrap.css
	wget -q \
	    http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js\
    	-O ${BUILD_PROJECT}/htdocs/js/jquery.min.js
	wget -q \
	    http://netdna.bootstrapcdn.com/bootstrap/3.0.0/js/bootstrap.min.js\
    	-O ${BUILD_PROJECT}/htdocs/js/bootstrap.min.js
	wget -q \
        http://netdna.bootstrapcdn.com/bootstrap/3.0.0/fonts/glyphicons-halflings-regular.eot\
    	-O ${BUILD_PROJECT}/htdocs/fonts/glyphicons-halflings-regular.eot
	wget -q \
	    http://netdna.bootstrapcdn.com/bootstrap/3.0.0/fonts/glyphicons-halflings-regular.svg\
    	-O ${BUILD_PROJECT}/htdocs/fonts/glyphicons-halflings-regular.svg
	wget -q \
        http://netdna.bootstrapcdn.com/bootstrap/3.0.0/fonts/glyphicons-halflings-regular.ttf\
    	-O ${BUILD_PROJECT}/htdocs/fonts/glyphicons-halflings-regular.ttf
	wget -q \
        http://netdna.bootstrapcdn.com/bootstrap/3.0.0/fonts/glyphicons-halflings-regular.woff\
        -O ${BUILD_PROJECT}/htdocs/fonts/glyphicons-halflings-regular.woff

clean:
	rm -rf ${BUILD_FOLDER}
