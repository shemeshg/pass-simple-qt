#include "libpgpfactory.h"
#include "mainwindow.h"

#include <QApplication>
#include <QLocale>
#include <QTranslator>

#include "libpasshelper.h"

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);


    PassHelper passHelper{};
    std::unique_ptr<PassFile> pf = passHelper.getPassFile("/Users/osx/.password-store/develop/boboadsf.gpg");
    //pf->isGpgFile()
    pf->decrypt();
    qDebug() << QString::fromStdString(pf->getDecrypted());


    QTranslator translator;
    const QStringList uiLanguages = QLocale::system().uiLanguages();
    for (const QString &locale : uiLanguages) {
        const QString baseName = "pass-simple-qt_" + QLocale(locale).name();
        if (translator.load(":/i18n/" + baseName)) {
            a.installTranslator(&translator);
            break;
        }
    }
    MainWindow w;
    w.show();
    return a.exec();
}
