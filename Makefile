PKGINSTALL := sudo apt-get install
DOTS := ${PWD}

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

qutebrowser: python3## Install and configure qutebrowser
	sudo rm -rf /opt/qutebrowser
	sudo git clone https://github.com/qutebrowser/qutebrowser.git /opt/qutebrowser
	( cd /opt/qutebrowser;\
	sudo python3 scripts/mkvenv.py)
	sudo cp ${PWD}/qutebrowser/qutebrowserWrapper /usr/bin/qutebrowser
	sudo chmod a+rx /usr/bin/qutebrowser
	sudo ln -vsf ${PWD}/qutebrowser/config.py ${HOME}/.config/qutebrowser/config.py

python3:
	$(PKGINSTALL) $@

allinstall : qutebrowser ## Install everything

updatepackages: ## Update all packages
	sudo apt update
	sudo apt upgrade

updatefromsource: qutebrowser ## Update softwares installed from source

allupdate : updatepackages updatefromsource## Update everything

test:
	( cd /opt;
	pwd)
	pwd
	echo $(DOTS)
	pwd
