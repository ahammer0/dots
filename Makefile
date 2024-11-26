PKGINSTALL := sudo apt-get install -y
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
	$(PKGINSTALL) libqt5webengine5
	sudo rm -rf /opt/qutebrowser
	sudo git clone https://github.com/qutebrowser/qutebrowser.git /opt/qutebrowser
	( cd /opt/qutebrowser;\
	sudo python3 scripts/mkvenv.py)
	sudo cp ${PWD}/qutebrowser/qutebrowserWrapper /usr/bin/qutebrowser
	sudo chmod a+rx /usr/bin/qutebrowser
	sudo mkdir -p ${HOME}/.config/qutebrowser/
	sudo chown axel ${HOME}/.config/qutebrowser/
	sudo ln -vsf ${PWD}/qutebrowser/config.py ${HOME}/.config/qutebrowser/config.py

.PHONY: nnn-nav
nnn-nav: ## Install nnn terminal browser
	$(PKGINSTALL) gcc pkg-config libncursesw5-dev libreadline-dev
	sudo mkdir -p /tmp/nnn/
	cd /tmp/nnn/;\
	sudo wget https://github.com/jarun/nnn/archive/refs/tags/v5.0.tar.gz;\
	sudo tar -xzf *.tar.gz;\
	cd nnn-*;\
	sudo cp -fv $(DOTS)/nnn/nnn.h ./src/nnn.h;\
	sudo make strip install
	sudo rm -rf /tmp/nnn
	echo "Installing NNN plugins"
	curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs >> /tmp/nnnGetplugs.sh
	sudo chmod +x /tmp/nnnGetplugs.sh
	/tmp/nnnGetplugs.sh

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
	sudo rm -rf /tmp/discord
	

####################################################################################
#      Base Packages
####################################################################################
BASE_PKG := python3 git wget network-manager vim redshift-gtk yarnpkg i3 less bashrc 
BASE_PKG += flameshot snapd X playerctl syncthing basics imv fzf alacritty
BASE_PKG += httpie

BASICS_PKG := git ca-certificates python3 python3-venv libgl1 libxkbcommon-x11-0 libegl1-mesa 
BASICS_PKG += libfontconfig1 libglib2.0-0 libdbus-1-3 libxcb-cursor0 libxcb-icccm4 libxcb-keysyms1 
BASICS_PKG += libxcb-shape0 libnss3 libxcomposite1 libxdamage1 libxrender1 libxrandr2 libxtst6 libxi6 
BASICS_PKG += libasound2 pulseaudio alsa-utils nm-tray udisks2 alacritty npm firefox-esr
BASICS_PKG += libasound2-plugins-bluez pavucontrol docker
basics:
	$(PKGINSTALL) 
python3:
	$(PKGINSTALL) $@
	$(PKGINSTALL) $@-venv
.PHONY: git
git:
	$(PKGINSTALL) $@
	ln -vsf ${PWD}/git/dotgitconfig ${HOME}/.gitconfig
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
	$(PKGINSTALL) i3 j4-dmenu-desktop
	mkdir -p ${HOME}/.i3/
	ln -vsf ${PWD}/i3/i3config ${HOME}/.config/i3/config
	mkdir -p ${HOME}/.config/i3status/
	ln -vsf ${PWD}/i3/i3statusconfig ${HOME}/.config/i3status/config

.PHONY: less
less:
	ln -vsf ${PWD}/less/.lesskey ${HOME}/.lesskey

.PHONY: bashrc
bashrc:
	ln -vsf ${PWD}/bashrc/.bashrc ${HOME}/.bashrc


.PHONY: flameshot
flameshot: ## Install flameshot screenshot utility
	$(PKGINSTALL) $@

.PHONY: snapd
snapd: ## Install snap package manager
	$(PKGINSTALL) $@

.PHONY: X
X:
	ln -vsf ${PWD}/Xressources/.Xressources ${HOME}/.Xressources

.PHONY: playerctl
playerctl:
	$(PKGINSTALL) $@

.PHONY: syncthing
syncthing:
	$(PKGINSTALL) $@

.PHONY: imv
imv:
	$(PKGINSTALL) $@
	xdg-mime default imv.desktop image/jpeg
	xdg-mime default imv.desktop image/png
	xdg-mime default imv.desktop image/jpg
	xdg-mime default imv.desktop image/webp

.PHONY: fzf
fzf:
	$(PKGINSTALL) $@

.PHONY: alacritty
alacritty:
	$(PKGINSTALL) $@
	mkdir -p ${HOME}/.config/alacritty/
	ln -vsf ${PWD}/alacritty/alacritty.yml ${HOME}/.config/alacritty/alacritty.yml

####################################################################################
#      snap packages
####################################################################################
SNAP_PKG := spotify logseq postman

####################################################################################
#      configs      
####################################################################################

.PHONY: mimeapps
mimeapps:
	ln -vsf ${PWD}/mimeConfig/mimeapps.list ${HOME}/.config/mimeapps.list
####################################################################################
#      node packages
####################################################################################
NODE_PKG := create-vite node nodemon prettier tget
.PHONY: installnodepkg
installnodepkg: yarnpkg
	yarnpkg global add $(NODE_PKG)

####################################################################################
#      Grouping commands
####################################################################################
base: $(BASE_PKG) ## Install base packages

installsnap: snapd ## Install snap packages
	sudo snap install $(SNAP_PKG)
	# sudo ln -vsf /snap/spotify/current/meta/gui/spotify

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
