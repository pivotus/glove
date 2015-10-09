maketar () {
        tar -cvf $1.tar $1;
}

maketargz () {
        tar -cvzf $1.tar.gz $1;
}

makerar () {
        rar a -ap $1.rar $1
}
