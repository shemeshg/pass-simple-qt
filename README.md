# Pass Simple

Multi-platform GUI for [pass](https://www.passwordstore.org/), the standard unix password manager



## Getting Started

### Prerequisites

#### On Macos for user
```
brew install pass pinentry-mac

echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf

gpgconf --kill gpg-agent

defaults write org.gpgtools.common UseKeychain -bool NO
```

#### On Macos for developer
```
brew install pass gpgme libgpg-error pinentry-mac yaml-cpp

echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf

gpgconf --kill gpg-agent

 defaults write org.gpgtools.common UseKeychain -bool NO
```

#### Ubuntu  for user

```
suto apt-get install pass ydotool
sudo chmod +s /usr/bin/ydotool
```

test ydotool, or use clipboard


#### Ubuntu  for developer

install qt https://web.stanford.edu/dept/cs_edu/resources/qt/install-linux

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

