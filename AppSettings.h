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
    /* [[[cog
    import cog
    import appSettings
    cog.outl(appSettings.getQ_Properties(),
        dedent=True, trimblanklines=True)
    ]]] */
    Q_PROPERTY( QString passwordStorePath READ passwordStorePath WRITE setPasswordStorePath NOTIFY passwordStorePathChanged)
    Q_PROPERTY( QString tmpFolderPath READ tmpFolderPath WRITE setTmpFolderPath NOTIFY tmpFolderPathChanged)
    Q_PROPERTY( QString gitExecPath READ gitExecPath WRITE setGitExecPath NOTIFY gitExecPathChanged)
    Q_PROPERTY( QString vscodeExecPath READ vscodeExecPath WRITE setVscodeExecPath NOTIFY vscodeExecPathChanged)
    Q_PROPERTY( QString autoTypeCmd READ autoTypeCmd WRITE setAutoTypeCmd NOTIFY autoTypeCmdChanged)
    Q_PROPERTY( QString ctxSigner READ ctxSigner WRITE setCtxSigner NOTIFY ctxSignerChanged)
    Q_PROPERTY( QString fontSize READ fontSize WRITE setFontSize NOTIFY fontSizeChanged)
    Q_PROPERTY( QString commitMsg READ commitMsg WRITE setCommitMsg NOTIFY commitMsgChanged)
    Q_PROPERTY( QString binaryExts READ binaryExts WRITE setBinaryExts NOTIFY binaryExtsChanged)
    Q_PROPERTY( bool useClipboard READ useClipboard WRITE setUseClipboard NOTIFY useClipboardChanged)
    Q_PROPERTY( bool doSign READ doSign WRITE setDoSign NOTIFY doSignChanged)
    Q_PROPERTY( bool preferYamlView READ preferYamlView WRITE setPreferYamlView NOTIFY preferYamlViewChanged)
    Q_PROPERTY( bool isFindMemCash READ isFindMemCash WRITE setIsFindMemCash NOTIFY isFindMemCashChanged)
    Q_PROPERTY( bool isFindSlctFrst READ isFindSlctFrst WRITE setIsFindSlctFrst NOTIFY isFindSlctFrstChanged)
    Q_PROPERTY( bool isShowPreview READ isShowPreview WRITE setIsShowPreview NOTIFY isShowPreviewChanged)
    Q_PROPERTY( int openWith READ openWith WRITE setOpenWith NOTIFY openWithChanged)
    Q_PROPERTY( QString appVer READ appVer CONSTANT)

    //[[[end]]]
    QML_ELEMENT
public:
    AppSettings(QObject *parent = nullptr);
    /* [[[cog
    cog.outl(appSettings.getQ_header_publics(),
        dedent=True, trimblanklines=True)
    ]]] */
    const QString passwordStorePath() const;
    void setPasswordStorePath(const QString &passwordStorePath);
    const QString tmpFolderPath() const;
    void setTmpFolderPath(const QString &tmpFolderPath);
    const QString gitExecPath() const;
    void setGitExecPath(const QString &gitExecPath);
    const QString vscodeExecPath() const;
    void setVscodeExecPath(const QString &vscodeExecPath);
    const QString autoTypeCmd() const;
    void setAutoTypeCmd(const QString &autoTypeCmd);
    const QString ctxSigner() const;
    void setCtxSigner(const QString &ctxSigner);
    const QString fontSize() const;
    void setFontSize(const QString &fontSize);
    const QString commitMsg() const;
    void setCommitMsg(const QString &commitMsg);
    const QString binaryExts() const;
    void setBinaryExts(const QString &binaryExts);
    bool useClipboard() const { return m_useClipboard; };
    void setUseClipboard(const bool useClipboard);
    bool doSign() const { return m_doSign; };
    void setDoSign(const bool doSign);
    bool preferYamlView() const { return m_preferYamlView; };
    void setPreferYamlView(const bool preferYamlView);
    bool isFindMemCash() const { return m_isFindMemCash; };
    void setIsFindMemCash(const bool isFindMemCash);
    bool isFindSlctFrst() const { return m_isFindSlctFrst; };
    void setIsFindSlctFrst(const bool isFindSlctFrst);
    bool isShowPreview() const { return m_isShowPreview; };
    void setIsShowPreview(const bool isShowPreview);
    int openWith() const { return m_openWith; };
    void setOpenWith(const int openWith);

    //[[[end]]]

    /* [[[cog
    cog.outl(appSettings.get_appWindowStates(),
        dedent=True, trimblanklines=True)
    ]]] */
    QByteArray appWindowState() const {
        return settings.value("app/windowState").toByteArray();
    }
    void setAppWindowState(const QByteArray &appWindowState){
        settings.setValue("app/windowState", appWindowState);
    }            

    QByteArray appGeometry() const {
        return settings.value("app/geometry").toByteArray();
    }
    void setAppGeometry(const QByteArray &appGeometry){
        settings.setValue("app/geometry", appGeometry);
    }            

    QByteArray appSplitter() const {
        return settings.value("app/splitter").toByteArray();
    }
    void setAppSplitter(const QByteArray &appSplitter){
        settings.setValue("app/splitter", appSplitter);
    }            

    QByteArray appTreeviewHeaderState() const {
        return settings.value("app/treeviewHeaderState").toByteArray();
    }
    void setAppTreeviewHeaderState(const QByteArray &appTreeviewHeaderState){
        settings.setValue("app/treeviewHeaderState", appTreeviewHeaderState);
    }            

    bool appIsShowTree() const {
        return settings.value("app/isShowTree",true).toBool();
    }
    void setAppIsShowTree(const bool appIsShowTree){
        settings.setValue("app/isShowTree", appIsShowTree);
    }         

    //[[[end]]]

    /* [[[cog
    cog.outl(appSettings.getQ_header_save_items(),
        dedent=True, trimblanklines=True)
    ]]] */
    void saveIsFindMemCash(){
        settings.setValue("isFindMemCash", m_isFindMemCash);
    };
    void saveIsFindSlctFrst(){
        settings.setValue("isFindSlctFrst", m_isFindSlctFrst);
    };
    void saveIsShowPreview(){
        settings.setValue("isShowPreview", m_isShowPreview);
    };
    void saveOpenWith(){
        settings.setValue("openWith", m_openWith);
    };

   //[[[end]]]
    static QString appVer();
    const QString getFindExecutable(const QString &exec) const;


signals:
    /* [[[cog
    cog.outl(appSettings.getQ_header_signals(),
        dedent=True, trimblanklines=True)
    ]]] */
    void passwordStorePathChanged();
    void tmpFolderPathChanged();
    void gitExecPathChanged();
    void vscodeExecPathChanged();
    void autoTypeCmdChanged();
    void ctxSignerChanged();
    void fontSizeChanged();
    void commitMsgChanged();
    void binaryExtsChanged();
    void useClipboardChanged();
    void doSignChanged();
    void preferYamlViewChanged();
    void isFindMemCashChanged();
    void isFindSlctFrstChanged();
    void isShowPreviewChanged();
    void openWithChanged();

    //[[[end]]]

 private:
    QSettings settings{"shemeshg", "PassSimple"};
    /* [[[cog
    cog.outl(appSettings.getQ_header_privates(),
        dedent=True, trimblanklines=True)
    ]]] */
    QString m_passwordStorePath;
    QString m_tmpFolderPath;
    QString m_gitExecPath;
    QString m_vscodeExecPath;
    QString m_autoTypeCmd;
    QString m_ctxSigner;
    QString m_fontSize;
    QString m_commitMsg;
    QString m_binaryExts;
    bool m_useClipboard;
    bool m_doSign;
    bool m_preferYamlView;
    bool m_isFindMemCash;
    bool m_isFindSlctFrst;
    bool m_isShowPreview;
    int m_openWith;

    //[[[end]]]
};
