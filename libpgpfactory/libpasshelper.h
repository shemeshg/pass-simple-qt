#pragma once
#include <iostream>
#include <filesystem>
#include "libpgpfactory.h"

class PassFile
{
public:
  PassFile(std::string fullPath, GpgFactory *g):fullPath{fullPath},g{g}
  {
  }

  bool isGpgFile(){
    std::filesystem::path path(fullPath);
    return (path.extension().string() == ".gpg");
  }

  void decrypt(){ 
    PgpmeDataRII din{fullPath,FROM_FILENAME}, 
                    dout{};
    g->decryptValidate(din,dout,false);
    decrypted = dout.getString();
  }

  std::string &getDecrypted(){
    return decrypted;
  }

private:
  std::string fullPath, decrypted;
  GpgFactory *g;
};

class PassHelper {
  public:
  PassHelper(){
    g.initPgpFactory(); 
  };

 std::unique_ptr<PassFile> getPassFile(std::string fullPath){
    return std::make_unique<PassFile>(fullPath, &g);
  }

  GpgFactory g{};

};