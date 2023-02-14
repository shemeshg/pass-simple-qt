# Pass Simple

Similar to [QtPass](https://github.com/IJHack/QtPass):

Multi-platform GUI for [pass](https://www.passwordstore.org/), the standard unix password manager

https://sourceforge.net/projects/pass-simple/

Screenshots: https://github.com/shemeshg/pass-simple-qt/wiki

## Getting Started

### Template file example

```YAML
---
user name: ""
password: ""
home page: ""
totp: ""
description: ""
fields type:
  user name: text
  password: password
  home page: url
  totp: totp
  description: textedit  
```
## Installing

### Prerequisites

#### Macos users

1. Install pass
```
brew install pass pinentry-mac

echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf

gpgconf --kill gpg-agent

defaults write org.gpgtools.common UseKeychain -bool NO
```

2. Create a note with pass command line, ensure all well

```
pass
pass edit whatever
```

If pass is not ok, follow this:
https://www.redhat.com/sysadmin/management-password-store

3. Install pass-simple 
```
brew install --cask shemeshg/homebrew-tap/pass-simple
```

4. Ensure you can read and write the test note created on step 2.

5. Backup your store to other drive

https://stackoverflow.com/questions/39471072/how-to-create-a-local-push-destination-on-a-hard-disk-using-git

6. Enable pgp for git, this will enable `git diff` within pgp
```
export PASSWORD_STORE_DIR=/Volumes/volume\ name/password-store
pass git init
```

or do it manually with

```bash
echo '*.gpg diff=gpg' > ".gitattributes"
git config --local diff.gpg.binary true
git config --local diff.gpg.textconv "gpg -d --quiet --yes --compress-algo=none --no-encrypt-to"
```

7. Consider running RAM drive for temporary files

```bash
diskutil erasevolume HFS+ RAM_Disk_4G `hdiutil attach -nomount ram://8192000`
```


#### Mac dev env also requires
1. 
```
brew install gpgme libgpg-error pinentry-mac yaml-cpp

```


#### Ubuntu  


No appImage yet, compile yourself


install qt https://web.stanford.edu/dept/cs_edu/resources/qt/install-linux

```
suto apt-get install pass 
```

test ydotool, or use clipboard (used by default
in application settings)

#### Ubuntu dev env also requires

```
sudo apt install libyaml-cpp-dev libgpgme-dev
sudo apt-get install -y libgpgmepp-dev
```

## Built With

- [Qt Quick and QT6 Open Source ](https://www.qt.io/)
- Gpgmepp
- LibGpgError
- pinentry-mac (Mac only)
- https://github.com/jbeder/yaml-cpp/
- Icons by https://icons8.com/icons/ 
- [keepassxc totp](https://github.com/keepassxreboot/keepassxc/tree/develop/src/totp)





## Authors

- **shemeshg**

## License

Copyright 2020 shemeshg

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

