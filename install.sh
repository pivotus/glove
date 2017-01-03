#!/bin/bash

set -e

echo "Gerekli paketlerin yüklenmesi için parolanızı girin!"
# update repos
sudo apt-get update

# install zsh, tmux
sudo apt-get install -y zsh tmux vim vim-gtk build-essential cmake exuberant-ctags

if [ ! $SHELL="/bin/zsh" ]; then
	echo "Kabuk değişimi için parolanızı girin!"
	chsh -s /bin/zsh
fi

GLOVE="$HOME/.glove"
BACKUP="$GLOVE/backup/$(date +%Y-%m-%d_%H:%M:%S)"

mkdir -p $BACKUP

say () {
	red='\033[0;31m'
	NC='\033[0m' # No Color
	echo -e "${red}$1${NC}"
}

file_exist () {
	if [ -e $1 ] || [ -h $1 ] || [ -d $1 ]; then
		true
	else
		false
	fi
}

cd $GLOVE

if ! git remote | grep upstream > /dev/null; then
	say "Güncelleme işlemleri için upstream ayarlanıyor..."
	git remote add upstream https://github.com/pivotus/glove.git
fi

say "mevcut rc dosyalarınız ~/.glove/backup dizini alınıyor..."
if file_exist "$HOME/.zshrc"; then
	mv $HOME/.zshrc $BACKUP
fi
ln -s $GLOVE/dotfiles/zsh/zshrc $HOME/.zshrc

if ! file_exist "$HOME/.oh-my-zsh"; then
	git clone https://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh
fi

if ! file_exist "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

if file_exist "$HOME/.tmux.conf"; then
	mv $HOME/.tmux.conf $BACKUP
fi
ln -s $GLOVE/dotfiles/tmux.conf $HOME/.tmux.conf

if file_exist "$HOME/.gemrc"; then
	mv $HOME/.gemrc $BACKUP
fi
ln -s $GLOVE/dotfiles/gemrc $HOME/.gemrc

if file_exist "$HOME/.gitconfig"; then
	mv $HOME/.gitconfig $BACKUP
fi
ln -s $GLOVE/dotfiles/gitconfig $HOME/.gitconfig

# for git config
git_username=$(git config user.name)
git_email=$(git config user.email)
github_user=$(git config github.user)

if [ -z "$git_username" ]; then
	say "Ad Soyad yazın: "
	read git_username
	sed -i "s/name\ =/name\ =\ $git_username/" $GLOVE/dotfiles/local/gitconfig.local
fi

if [ -z "$git_email" ]; then
	say "GitHub'da kullandığınız email adresini yazın: "
	read git_email
	sed -i "s/email\ =/email\ =\ $git_email/" $GLOVE/dotfiles/local/gitconfig.local
fi

if [ -z "$github_user" ]; then
	say "GitHub kullanıcı adınızı yazın: "
	read github_user
	sed -i "s/user\ =/user\ =\ $github_user/" $GLOVE/dotfiles/local/gitconfig.local
fi

if file_exist "$HOME/.gitignore_global"; then
	mv $HOME/.gitignore_global $BACKUP
fi
ln -s $GLOVE/dotfiles/gitignore_global $HOME/.gitignore_global

if ! file_exist "$HOME/.config"; then
	mkdir $HOME/.config
fi

if file_exist "$HOME/.config/mc"; then
	mv $HOME/.config/mc $BACKUP
fi
ln -s $GLOVE/dotfiles/mc $HOME/.config/mc

if file_exist "$HOME/.vimrc"; then
	mv $HOME/.vimrc $BACKUP
fi
ln -s $GLOVE/dotfiles/vim/vimrc $HOME/.vimrc

if ! file_exist "$HOME/.config/autostart"; then
	mkdir $HOME/.config/autostart
fi

if file_exist "$HOME/.config/autostart/guake.desktop"; then
	mv $HOME/.config/autostart/guake.desktop $BACKUP
fi
ln -s $GLOVE/tools/guake.desktop $HOME/.config/autostart

if ! file_exist "$HOME/.vim"; then
	mkdir -p .vim/bundle
else
	mv $HOME/.vim $BACKUP
fi
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# guake
if [ ! -z "$DESKTOP_SESSION" ]; then
	sudo apt-get install -y guake

	# monaco font
	cd $GLOVE/tools/monaco-font
	bash install-font-ubuntu.sh

	gconftool-2 --type boolean  --set /apps/guake/general/use_default_font false
	gconftool-2 --type string  --set /apps/guake/style/font/style 'Monaco 12'
	gconftool-2 --type integer  --set /apps/guake/style/background/transparency 0
	gconftool-2 --type integer  --set /apps/guake/style/cursor_blink_mode 2
	gconftool-2 --type integer  --set /apps/guake/general/window_height 100
	gconftool-2 --type float  --set /apps/guake/general/window_height_f 100
	gconftool-2 --type boolean  --set /apps/guake/general/window_tabbar false
	gconftool-2 --type boolean  --set /apps/guake/general/start_fullscreen true

	# guake neon colorscheme
	cd $GLOVE/tools/guake-colors
	bash neon.sh

	# powerline font
	cd $GLOVE/tools/powerline-font
	bash install.sh
fi

# dircolors
if ! file_exist "$HOME/.dircolors"; then
	mkdir $HOME/.dircolors
fi
if ! file_exist "$HOME/.dircolors/dircolors.256dark"; then
	ln -s $GLOVE/tools/dircolors-solarized/dircolors.256dark $HOME/.dircolors
fi

say "Vim eklentileri yükleniyor..."

# vim için tmp dizini oluştur
mkdir ~/.vim/.tmp

vim +PluginInstall +qall

# fzf
say "fzf kuruluyor..."

if ! file_exist "$HOME/.fzf"; then
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	sed -i 's/curl\ -fL/curl\ -kfL/' ~/.fzf/install
	sed -i 's/wget\ -O/wget\ --no-check-certificate\ -O/' ~/.fzf/install
fi

type fzf >/dev/null 2>&1 ||  ~/.fzf/install

say "ruby kuruluyor..."
$GLOVE/bin/kur ruby

say "docker kuruluyor..."
$GLOVE/bin/kur docker

say "docker-compose kuruluyor..."
$GLOVE/bin/kur docker-compose

say "Kurulum tamamlandı. Bilgisayarınızı yeniden başlatın!"
