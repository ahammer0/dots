PKGINSTALL := sudo apt-get install
DOTS := ${PWD}

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


####################################################################################
#      Installed from source
####################################################################################
FROM_SOURCE :=qutebrowser nnn-nav

.PHONY: qutebrowser
qutebrowser: python3## Install and configure qutebrowser
	sudo rm -rf /opt/qutebrowser
	sudo git clone https://github.com/qutebrowser/qutebrowser.git /opt/qutebrowser
	( cd /opt/qutebrowser;\
	sudo python3 scripts/mkvenv.py)
	sudo cp ${PWD}/qutebrowser/qutebrowserWrapper /usr/bin/qutebrowser
	sudo chmod a+rx /usr/bin/qutebrowser
	sudo ln -vsf ${PWD}/qutebrowser/config.py ${HOME}/.config/qutebrowser/config.py

.PHONY: nnn-nav
nnn-nav: ## Install nnn terminal browser
	$(PKGINSTALL) pkg-config libncursesw5-dev libreadline-dev
	sudo mkdir -p /tmp/nnn/
	cd /tmp/nnn/;\
	sudo wget https://github.com/jarun/nnn/archive/refs/tags/v5.0.tar.gz;\
	sudo tar -xzf *.tar.gz;\
	cd nnn-*;\
	sudo cp -fv $(DOTS)/nnn/nnn.h ./src/nnn.h;\
	sudo make strip install
	sudo rm -rf /tmp/nnn

####################################################################################
#      Base Packages
####################################################################################
BASE_PKG := python3 git wget vim redshift-gtk yarnpkg i3 less bashrc

python3:
	$(PKGINSTALL) $@
git:
	$(PKGINSTALL) $@
wget:
	$(PKGINSTALL) $@

.PHONY: vim
vim:
	$(PKGINSTALL) $@ $@-gtk3
	for file in .vimrc .vimrc.bepo; do ln -vsf ${PWD}/vim/$$file ${HOME}/$$file; done
	rm -rf ${HOME}/.vim/bundle/Vundle.vim
	git clone https://github.com/VundleVim/Vundle.vim.git ${HOME}/.vim/bundle/Vundle.vim

.PHONY: redshift-gtk
redshift-gtk:
	$(PKGINSTALL) $@
	ln -vsf ${PWD}/redshift/redshift.conf ${HOME}/.config/redshift.conf

.PHONY: yarnpkg
yarnpkg:
	$(PKGINSTALL) $@

.PHONY: i3
i3:
	$(PKGINSTALL) i3 
	ln -vsf ${PWD}/i3/i3config ${HOME}/.i3/config
	ln -vsf ${PWD}/i3/i3statusconfig ${HOME}/.config/i3status/config

.PHONY: less
less:
	ln -vsf ${PWD}/less/.lesskey ${HOME}/.lesskey

.PHONY: bashrc
bashrc:
	ln -vsf ${PWD}/bashrc/.bashrc ${HOME}/.bashrc

####################################################################################
#      Node packages
####################################################################################
NODE_PKG := create-vite node nodemon prettier
installnodepkg: yarnpkg
	yarnnpkg global add $(NODE_PKG)

####################################################################################
#      Grouping commands
####################################################################################
base: $(BASE_PKG) ## Install base packages

.PHONY: installfromsource
installfromsource: $(FROM_SOURCE)

.PHONY: allinstall
allinstall: base qutebrowser installnodepkg ## Install everything

.PHONY: updatepackages
updatepackages: ## Update all packages
	sudo apt update
	sudo apt upgrade

.PHONY: allupdate
allupdate: updatepackages installfromsource## Update everything
