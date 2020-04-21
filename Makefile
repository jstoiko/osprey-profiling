PROJ_ROOT:=~/projects
BRANCH:=rework_webapi_parser

.ONESHELL:
all: clone install link

clone:
	cd $(PROJ_ROOT)
	git clone git@github.com:mulesoft-labs/osprey-mock-service.git
	cd $(PROJ_ROOT)/osprey-mock-service
	git checkout $(BRANCH)
	cd $(PROJ_ROOT)
	git clone git@github.com:mulesoft/osprey.git
	cd $(PROJ_ROOT)/osprey
	git checkout $(BRANCH)
	cd $(PROJ_ROOT)
	git clone git@github.com:mulesoft-labs/osprey-method-handler.git
	cd $(PROJ_ROOT)/osprey-method-handler
	git checkout $(BRANCH)
	cd $(PROJ_ROOT)
	git clone git@github.com:mulesoft-labs/osprey-resources.git
	cd $(PROJ_ROOT)/osprey-resources
	git checkout $(BRANCH)
	cd $(PROJ_ROOT)
	git clone git@github.com:mulesoft-labs/osprey-router.git
	cd $(PROJ_ROOT)/osprey-router
	git checkout $(BRANCH)
	cd $(PROJ_ROOT)
	git clone git@github.com:mulesoft-labs/raml-path-match.git
	cd $(PROJ_ROOT)/raml-path-match
	git checkout $(BRANCH)
	cd $(PROJ_ROOT)
	git clone git@github.com:mulesoft-labs/node-raml-sanitize.git
	cd $(PROJ_ROOT)/node-raml-sanitize
	git checkout $(BRANCH)
	cd $(PROJ_ROOT)
	git clone git@github.com:mulesoft-labs/router.git
	cd $(PROJ_ROOT)/router
	git checkout router-engine

install:
	cd $(PROJ_ROOT)/osprey-mock-service
	npm install
	cd $(PROJ_ROOT)/osprey
	npm install
	cd $(PROJ_ROOT)/osprey-method-handler
	npm install
	cd $(PROJ_ROOT)/osprey-resources
	npm install
	cd $(PROJ_ROOT)/osprey-router
	npm install
	cd $(PROJ_ROOT)/raml-path-match
	npm install
	cd $(PROJ_ROOT)/node-raml-sanitize
	npm install
	cd $(PROJ_ROOT)/router
	npm install

link-osprey:
	cd app
	npm link $(PROJ_ROOT)/osprey

link:
	cd $(PROJ_ROOT)/osprey-mock-service
	npm link $(PROJ_ROOT)/osprey
	npm link $(PROJ_ROOT)/osprey-resources
	npm link $(PROJ_ROOT)/node-raml-sanitize
	cd $(PROJ_ROOT)/osprey
	npm link $(PROJ_ROOT)/osprey-method-handler
	npm link $(PROJ_ROOT)/osprey-resources
	npm link $(PROJ_ROOT)/osprey-router
	cd $(PROJ_ROOT)/osprey-method-handler
	npm link $(PROJ_ROOT)/osprey-router
	npm link $(PROJ_ROOT)/node-raml-sanitize
	cd $(PROJ_ROOT)/osprey-resources
	npm link $(PROJ_ROOT)/osprey-router
	cd $(PROJ_ROOT)/osprey-router
	npm link $(PROJ_ROOT)/router
	npm link $(PROJ_ROOT)/raml-path-match
	cd $(PROJ_ROOT)/raml-path-match
	npm link $(PROJ_ROOT)/node-raml-sanitize

clean:
	rm -rf $(PROJ_ROOT)/node-raml-sanitize/node_modules
	rm -rf $(PROJ_ROOT)/osprey-mock-service/node_modules
	rm -rf $(PROJ_ROOT)/osprey/node_modules
	rm -rf $(PROJ_ROOT)/osprey-method-handler/node_modules
	rm -rf $(PROJ_ROOT)/osprey-resources/node_modules
	rm -rf $(PROJ_ROOT)/osprey-router/node_modules
	rm -rf $(PROJ_ROOT)/raml-path-match/node_modules
	rm -rf $(PROJ_ROOT)/node-raml-sanitize/node_modules
	rm -rf $(PROJ_ROOT)/router/node_modules
