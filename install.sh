#!/bin/bash

set -e

echo "Gerekli paketlerin yüklenmesi için parolanızı girin!"
# update repos
sudo apt-get update

# install zsh, tmux
sudo apt-get install zsh tmux vim vim-gtk build-essential cmake python-dev

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

say "Güncelleme işlemleri için upstream ayarlanıyor..."
git remote add upstream https://github.com/pivotus/glove.git

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

if ! file_exist "$HOME/.vim"; then
	mkdir -p .vim/bundle
else
	mv $HOME/.vim $BACKUP
fi
git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim


# guake
if [ ! -z $DESKTOP_SESSION ]; then
	sudo apt-get install guake
	# monaco font
	$GLOVE/tools/monaco-font/install-font-ubuntu.sh
	gconftool-2 --type string  --set /apps/guake/style/font/style 'Monaco 12'
	$GLOVE/tools/guake-colors/neon.sh
	# powerline font
	$GLOVE/tools/powerline-font/install.sh
fi

# dircolors
if ! file_exist "$HOME/.dircolors"; then
	mkdir $HOME/.dircolors
fi
if ! file_exist "$HOME/.dircolors/dircolors.256dark"; then
	ln -s $GLOVE/tools/dircolors-solarized/dircolors.256dark $HOME/.dircolors
fi

say "
vim eklentilerinin yüklenmesi için herhangi bir tuşa basın. Gelecek hata
mesajlarını 'Enter' tuşu ile geçiniz. Eklenti kurulumu bittikten sonra,
vim'den normal bir biçimde çıkış yaptığınızda işlem tamamlanmış olacaktır.
"
read -n 1

# vim için tmp dizini oluştur
mkdir ~/.vim/.tmp

vim +PluginInstall +qall

# YCM
say " YouCompleteMe bileşenleri kuruluyor..."
cd ~/.vim/bundle/YouCompleteMe
./install.sh

# fzf
say "fzf kuruluyor..."

if ! file_exist "$HOME/.fzf"; then
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	sed -i 's/curl\ -fL/curl\ -kfL/' ~/.fzf/install
	sed -i 's/wget\ -O/wget\ --no-check-certificate\ -O/' install
fi

! type fzf >/dev/null 2>&1 ||  ~/.fzf/install

say "Kurulum tamamlandı. 'source ~/.zshrc' ile çalışmaya başlayabilirsiniz."
