# Pass Simple

Multi-platform GUI for [pass](https://www.passwordstore.org/), the standard unix password manager

https://sourceforge.net/projects/pass-simple/

## Getting Started

### Template file example

```YAML
---
user name: 
password: 
home page: 
totp: 
description: ""
fields type:
  user name: text
  password: password
  home page: url
  totp: totp
  description: textedit  
```

### Prerequisites

#### On Macos for user
1. Install pass
```
brew install pass pinentry-mac

echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf

gpgconf --kill gpg-agent

defaults write org.gpgtools.common UseKeychain -bool NO
```

Create a note with pass command line, ensure all well

```
pass
pass edit whatever
```

2. Install pass-simple 
```
brew install --cask shemeshg/homebrew-tap/pass-simple
```

3. Ensure you can read and write the test note created on step 2.


#### On Macos develop env
```
brew install gpgme libgpg-error pinentry-mac yaml-cpp

```

#### Ubuntu  


No appImage yet, compile yourself


install qt https://web.stanford.edu/dept/cs_edu/resources/qt/install-linux

```
suto apt-get install pass 
```

test ydotool, or use clipboard (by default)
(in application settings)

```
sudo apt install libyaml-cpp-dev libgpgme-dev
sudo apt-get install -y libgpgmepp-dev
```



### Installing







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

