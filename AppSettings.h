#pragma once

#include <QApplication>
#include <QDir>
#include <QFont>
#include <QSettings>
#include <QString>
#include <qqmlregistration.h>


class AppSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString passwordStorePath READ passwordStorePath WRITE setPasswordStorePath NOTIFY
                   passwordStorePathChanged)
    Q_PROPERTY(
        QString tmpFolderPath READ tmpFolderPath WRITE setTmpFolderPath NOTIFY tmpFolderPathChanged)
    Q_PROPERTY(QString gitExecPath READ gitExecPath WRITE setGitExecPath NOTIFY gitExecPathChanged)
    Q_PROPERTY(QString vscodeExecPath READ vscodeExecPath WRITE setVscodeExecPath NOTIFY
                   vscodeExecPathChanged)
    Q_PROPERTY(QString autoTypeCmd READ autoTypeCmd WRITE setAutoTypeCmd NOTIFY autoTypeCmdChanged)
    Q_PROPERTY(QString ctxSigner READ ctxSigner WRITE setCtxSigner NOTIFY ctxSignerChanged)
    Q_PROPERTY(bool useClipboard READ useClipboard WRITE setUseClipboard NOTIFY useClipboardChanged)
    Q_PROPERTY(bool doSign READ doSign WRITE setDoSign NOTIFY doSignChanged)
    Q_PROPERTY(bool preferYamlView READ preferYamlView WRITE setPreferYamlView NOTIFY preferYamlViewChanged)
    Q_PROPERTY(QString fontSize READ fontSize WRITE setfontSize NOTIFY fontSizeChanged)
    Q_PROPERTY(QString appVer READ appVer CONSTANT )
    Q_PROPERTY(QString binaryExts READ binaryExts WRITE setBinaryExts NOTIFY binaryExtsChanged)
    QML_ELEMENT
public:
    AppSettings(QObject *parent = nullptr);
    const QString passwordStorePath() const;
    void setPasswordStorePath(const QString &passwordStorePath);
    const QString tmpFolderPath() const;
    void setTmpFolderPath(const QString &tmpFolderPath);
    const QString gitExecPath() const;
    void setGitExecPath(const QString &gitExecPath);
    const QString ctxSigner() const { return m_ctxSigner; };
    void setCtxSigner(const QString &ctxSigner);
    QString vscodeExecPath() const;
    void setVscodeExecPath(const QString &vscodeExecPath);
    const QString autoTypeCmd() const;
    void setAutoTypeCmd(const QString &autoTypeCmd);    
    const QString binaryExts() const;
    void setBinaryExts(const QString &binaryExts);
    bool useClipboard() const { return m_useClipboard; };
    bool doSign() const { return m_doSign; };
    bool preferYamlView() const { return m_preferYamlView; };
    void setUseClipboard(const bool useClipboard);
    void setDoSign(const bool doSign);
    void setPreferYamlView(const bool preferYamlView);
    QString fontSize() const {
        if (m_fontSize.isEmpty()){
            return QString::number(QApplication::font().pointSize());
        }
        return m_fontSize;
    };
    void setfontSize(const QString fontSize);
    static QString appVer();


    const QString getFindExecutable(const QString &exec) const;

signals:
    void passwordStorePathChanged();
    void tmpFolderPathChanged();
    void gitExecPathChanged();
    void vscodeExecPathChanged();
    void autoTypeCmdChanged();
    void binaryExtsChanged();
    void useClipboardChanged();
    void doSignChanged();
    void preferYamlViewChanged();
    void fontSizeChanged();
    void ctxSignerChanged();

private:
    QSettings settings{"shemeshg", "PassSimple"};
    QString m_passwordStorePath;
    QString m_tmpFolderPath;
    QString m_gitExecPath;
    QString m_vscodeExecPath;
    QString m_autoTypeCmd;
    QString m_binaryExts;
    QString m_ctxSigner;
    bool m_useClipboard;
    bool m_doSign;
    bool m_preferYamlView;
    QString m_fontSize;
};
