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
FROM_SOURCE :=qutebrowser nnn-nav discord

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

.PHONY: discord
discord: ## Install discord from source
	mkdir /tmp/discord;\
	cd /tmp/discord;\
	wget -O discord.tar.gz "https://discord.com/api/download?platform=linux&format=tar.gz";\
	sudo tar -xzf discord.tar.gz;\
	sudo rm -rf /usr/share/discord/;\
	sudo cp -r Discord/ /usr/share/discord/
	sudo ln -vsf /usr/share/discord/Discord /usr/bin/discord
	sudo ln -vsf /usr/share/discord/discord.desktop /usr/share/applications/discord.desktop
	rm -rf /tmp/discord
	

####################################################################################
#      Base Packages
####################################################################################
BASE_PKG := python3 git wget network-manager vim redshift-gtk yarnpkg i3 less bashrc nvidia-drivers
BASE_PKG += flameshot snapd X

python3:
	$(PKGINSTALL) $@
git:
	$(PKGINSTALL) $@
wget:
	$(PKGINSTALL) $@
network-manager:
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
	sudo echo "owner ${PWD}/redshift/redshift.conf r," | sudo tee -a /etc/apparmor.d/local/usr.bin.redshift

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

.PHONY: nvidia-drivers
nvidia-drivers: ## Install nvidia card drivers non-free
	$(PKGINSTALL) nvidia-driver firmware-misc-nonfree

.PHONY: flameshot
flameshot: ## Install flameshot screenshot utility
	$(PKGINSTALL) $@

.PHONY: snapd
snapd: ## Install snap package manager
	$(PKGINSTALL) $@

.PHONY: X
X:
	ln -vsf ${PWD}/Xressources/.Xressources ${HOME}/.Xressources


####################################################################################
#      snap packages
####################################################################################
SNAP_PKG := spotify


####################################################################################
#      node packages
####################################################################################
NODE_PKG := create-vite node nodemon prettier
.PHONY: installnodepkg
installnodepkg: yarnpkg
	yarnnpkg global add $(NODE_PKG)

####################################################################################
#      Grouping commands
####################################################################################
base: $(BASE_PKG) ## Install base packages

.PHONY: installfromsource
installfromsource: $(FROM_SOURCE)

.PHONY: allinstall
allinstall: base installfromsource installnodepkg ## Install everything

.PHONY: updatepackages
updatepackages: ## Update all packages
	sudo apt update
	sudo apt upgrade

.PHONY: allupdate
allupdate: updatepackages installfromsource## Update everything
