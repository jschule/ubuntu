gpg --armor --export 9E62229E | tee ../../repo.key | gpg --no-default-keyring --primary-keyring ./src/etc/apt/trusted.gpg.d/jschule.gpg --import
