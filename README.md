### Nedir?

guake, zsh, tmux ve vim ile harikalar yaratmanız için sevgiyle oluşuturulmuş bir
kişiselleştirme deposudur. Tamamen @ecylmz'nin zevk ve tercihleri ile
hazırlanmıştır.

### Gereksinimler

-    Ubuntu: 14.04 test edildi.
-    git: Deponun klonlanması için gerekiyor.

### Kurulum

- Depoyu kendi github hesabınıza fork'layın.

- Forkladığınız depoyu aşağıdaki şekilde bilgisayarınıza klonlayın:

```sh
git clone git@github.com:kullanıcı-adınız/glove.git ~/.glove
```

**Yukarıdaki kullanıcı-adınız kısmını kendi kullanıcı adınızla değiştirmeyi unutmayın.**

-    Kurulum betiğini çalıştır.

```sh
bash ~/.glove/install.sh
```

### Güncelleme

```sh
cd ~/.glove
git pull upstream master
```

### Özelleştirme

`~/.glove/dotfiles/local` dizini içerisinde bulunan dosyalara istediğiniz ayarları yazabilirsiniz.

Vim için renk şeması eklemek isterseniz; ~/.vim/colors dizini açıp .vim uzantılı şemayı buraya atabilirsiniz.
Bu öneri hoşunuza gitmediyse, renk şeması isteğinizi "issue" açarak iletebilirsiniz.

### Kaldırma

Glove'u kaldırmak için glove dizinine kurulum tarihi ve saatiyle yedeklenmiş
(~/.glove/backup) olan eski konfigürasyonu geri yükleyin. Kaldırma için
(şimdilik) ayrı bir betiğe ihtiyaç görülmemiştir.

### Uyarı

Tamamen şahsi istekler doğrultusunda, kısa sürede oluşturulmuştur. Kullanmak
isteyenlere herhangi bir memnuniyet garantisi sunmadığı gibi başlarına bela
açması da muhtemeldir.
