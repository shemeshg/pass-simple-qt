#include <QStandardPaths>
#include "AppSettings.h"
#include "config.h"

AppSettings::AppSettings(QObject *parent)
    : QObject(parent)
{
    /* [[[cog
    import cog
    import appSettings
    cog.outl(appSettings.getQ_src_contrs(),
        dedent=True, trimblanklines=True)
    ]]] */
    m_passwordStorePath = settings.value("passwordStorePath", "").toString();
    m_tmpFolderPath = settings.value("tmpFolderPath", "").toString();
    m_gitExecPath = settings.value("gitExecPath", "").toString();
    m_vscodeExecPath = settings.value("vscodeExecPath", "").toString();
    m_autoTypeCmd = settings.value("autoTypeCmd", "").toString();
    m_ctxSigner = settings.value("ctxSigner", "").toString();
    m_fontSize = settings.value("fontSize", "").toString();
    m_commitMsg = settings.value("commitMsg", "").toString();
    m_ddListStores = settings.value("ddListStores", "").toString();
    m_binaryExts = settings.value("binaryExts", "").toString();
    m_useClipboard = settings.value("useClipboard", false).toBool();
    m_allowScreenCapture = settings.value("allowScreenCapture", false).toBool();
    m_doSign = settings.value("doSign", false).toBool();
    m_preferYamlView = settings.value("preferYamlView", true).toBool();
    m_isFindMemCash = settings.value("isFindMemCash", false).toBool();
    m_isFindSlctFrst = settings.value("isFindSlctFrst", false).toBool();
    m_isShowPreview = settings.value("isShowPreview", true).toBool();
    m_openWith = settings.value("openWith", 0).toInt();
    m_rnpgpHome = settings.value("rnpgpHome", "").toString();

    //[[[end]]]
    m_useRnpgp = settings.value("useRnpgp", false).toBool();
}


/* [[[cog
    import cog
    import appSettings
    cog.outl(appSettings.getQ_src_setters(),
        dedent=True, trimblanklines=True)
    ]]] */
void AppSettings::setPasswordStorePath(const QString &passwordStorePath)
{
    if (passwordStorePath == m_passwordStorePath)
        return;
    m_passwordStorePath = passwordStorePath;
    settings.setValue("passwordStorePath", m_passwordStorePath);
    emit passwordStorePathChanged();
}

void AppSettings::setTmpFolderPath(const QString &tmpFolderPath)
{
    if (tmpFolderPath == m_tmpFolderPath)
        return;
    m_tmpFolderPath = tmpFolderPath;
    settings.setValue("tmpFolderPath", m_tmpFolderPath);
    emit tmpFolderPathChanged();
}

void AppSettings::setGitExecPath(const QString &gitExecPath)
{
    if (gitExecPath == m_gitExecPath)
        return;
    m_gitExecPath = gitExecPath;
    settings.setValue("gitExecPath", m_gitExecPath);
    emit gitExecPathChanged();
}

void AppSettings::setVscodeExecPath(const QString &vscodeExecPath)
{
    if (vscodeExecPath == m_vscodeExecPath)
        return;
    m_vscodeExecPath = vscodeExecPath;
    settings.setValue("vscodeExecPath", m_vscodeExecPath);
    emit vscodeExecPathChanged();
}

void AppSettings::setAutoTypeCmd(const QString &autoTypeCmd)
{
    if (autoTypeCmd == m_autoTypeCmd)
        return;
    m_autoTypeCmd = autoTypeCmd;
    settings.setValue("autoTypeCmd", m_autoTypeCmd);
    emit autoTypeCmdChanged();
}

void AppSettings::setCtxSigner(const QString &ctxSigner)
{
    if (ctxSigner == m_ctxSigner)
        return;
    m_ctxSigner = ctxSigner;
    settings.setValue("ctxSigner", m_ctxSigner);
    emit ctxSignerChanged();
}

void AppSettings::setFontSize(const QString &fontSize)
{
    if (fontSize == m_fontSize)
        return;
    m_fontSize = fontSize;
    settings.setValue("fontSize", m_fontSize);
    emit fontSizeChanged();
}

void AppSettings::setCommitMsg(const QString &commitMsg)
{
    if (commitMsg == m_commitMsg)
        return;
    m_commitMsg = commitMsg;
    settings.setValue("commitMsg", m_commitMsg);
    emit commitMsgChanged();
}

void AppSettings::setDdListStores(const QString &ddListStores)
{
    if (ddListStores == m_ddListStores)
        return;
    m_ddListStores = ddListStores;
    settings.setValue("ddListStores", m_ddListStores);
    emit ddListStoresChanged();
}

void AppSettings::setBinaryExts(const QString &binaryExts)
{
    if (binaryExts == m_binaryExts)
        return;
    m_binaryExts = binaryExts;
    settings.setValue("binaryExts", m_binaryExts);
    emit binaryExtsChanged();
}

void AppSettings::setUseClipboard(const bool useClipboard)
{
    if (useClipboard == m_useClipboard)
        return;
    m_useClipboard = useClipboard;
    settings.setValue("useClipboard", m_useClipboard);
    emit useClipboardChanged();
}

void AppSettings::setAllowScreenCapture(const bool allowScreenCapture)
{
    if (allowScreenCapture == m_allowScreenCapture)
        return;
    m_allowScreenCapture = allowScreenCapture;
    settings.setValue("allowScreenCapture", m_allowScreenCapture);
    emit allowScreenCaptureChanged();
}

void AppSettings::setDoSign(const bool doSign)
{
    if (doSign == m_doSign)
        return;
    m_doSign = doSign;
    settings.setValue("doSign", m_doSign);
    emit doSignChanged();
}

void AppSettings::setPreferYamlView(const bool preferYamlView)
{
    if (preferYamlView == m_preferYamlView)
        return;
    m_preferYamlView = preferYamlView;
    settings.setValue("preferYamlView", m_preferYamlView);
    emit preferYamlViewChanged();
}

void AppSettings::setIsFindMemCash(const bool isFindMemCash)
{
    if (isFindMemCash == m_isFindMemCash)
        return;
    m_isFindMemCash = isFindMemCash;
    
    emit isFindMemCashChanged();
}

void AppSettings::setIsFindSlctFrst(const bool isFindSlctFrst)
{
    if (isFindSlctFrst == m_isFindSlctFrst)
        return;
    m_isFindSlctFrst = isFindSlctFrst;
    
    emit isFindSlctFrstChanged();
}

void AppSettings::setIsShowPreview(const bool isShowPreview)
{
    if (isShowPreview == m_isShowPreview)
        return;
    m_isShowPreview = isShowPreview;
    
    emit isShowPreviewChanged();
}

void AppSettings::setOpenWith(const int openWith)
{
    if (openWith == m_openWith)
        return;
    m_openWith = openWith;
    
    emit openWithChanged();
}

void AppSettings::setRnpgpHome(const QString &rnpgpHome)
{
    if (rnpgpHome == m_rnpgpHome)
        return;
    m_rnpgpHome = rnpgpHome;
    settings.setValue("rnpgpHome", m_rnpgpHome);
    emit rnpgpHomeChanged();
}

//[[[end]]]

bool AppSettings::useRnpgp() const
{
#if defined(__APPLE__) || defined(__linux__)
    return m_useRnpgp;
#else
    return true;
#endif
}

void AppSettings::setUseRnpgp(const bool useRnpgp)
{
    if (useRnpgp == m_useRnpgp)
        return;
    m_useRnpgp = useRnpgp;
    settings.setValue("useRnpgp", m_useRnpgp);
    emit useRnpgpChanged();
}

const QString AppSettings::ddListStores() const
{
    if (m_ddListStores.isEmpty()) {
        return "default # " + QDir::homePath() + "/.password-store"
               + "\npassword store 1 # /Volume/path";
    }
    return m_ddListStores;
}

const QString AppSettings::passwordStorePath() const
{
    QString passwordStorePathDefault;
    #if defined(__APPLE__) || defined(__linux__)
    passwordStorePathDefault = QDir::homePath() + "/.password-store";
#else
    std::filesystem::path s{QStandardPaths::writableLocation(
        QStandardPaths::AppLocalDataLocation).toStdString()};
    s = s.remove_filename();
    // get user
    QStringList pathList = QString::fromStdString(s.u8string()).split("/");
    QString username = pathList[2];
    //

    std::string p = s.u8string() + "gopass/stores/"  + username.toStdString();

    passwordStorePathDefault = QString::fromStdString(p);
    #endif
    if (m_passwordStorePath.isEmpty() || !QDir(m_passwordStorePath).exists()) {
        return passwordStorePathDefault;
    }

    return QDir(m_passwordStorePath).absolutePath();
}

const QString AppSettings::rnpgpHome() const
{
#if defined(__APPLE__) || defined(__linux__)

    QString defaultHomedire = QDir::homePath() + "/.gnupg";
    if (!QDir(defaultHomedire).exists()) {
        defaultHomedire = QDir::homePath() + "/.rnp";
    }
    if (!m_rnpgpHome.isEmpty() && QDir(m_rnpgpHome).exists()) {
        defaultHomedire = m_rnpgpHome;
    }

    if (!QDir(defaultHomedire).exists()){
        std::filesystem::create_directory(defaultHomedire.toStdString());
    }
    return defaultHomedire;

#else
    std::filesystem::path s{
                            QStandardPaths::standardLocations(QStandardPaths::AppDataLocation)
                                .at(0).toStdString()};
    s = s.remove_filename();
    s = s / "gnupg";
    QString defaultHomedire =QString::fromStdString(s.u8string());

    if (!m_rnpgpHome.isEmpty() && QDir(m_rnpgpHome).exists()) {
        defaultHomedire = m_rnpgpHome;
    }

    if (!QDir(defaultHomedire).exists()){
        std::filesystem::create_directory(defaultHomedire.toStdString());
    }

    return defaultHomedire;
#endif
}

const QString AppSettings::tmpFolderPath() const
{
    if (m_tmpFolderPath.isEmpty() ||  !QDir(m_tmpFolderPath).exists()) {
        QString tmpFolderPathDefault = QDir::tempPath();
#ifdef __linux__
        if (QDir("/dev/shm").exists()) {
            tmpFolderPathDefault = "/dev/shm";
        }
#endif
        return tmpFolderPathDefault;
    }
    return QDir(m_tmpFolderPath).absolutePath();
}


const QString AppSettings::gitExecPath() const
{
    if (m_gitExecPath.isEmpty()) {
        return getFindExecutable("git");
    }
    return m_gitExecPath;
}



const QString AppSettings::vscodeExecPath() const
{
    if (m_vscodeExecPath.isEmpty()) {
        return getFindExecutable("code");
    }
    return m_vscodeExecPath;
}



const QString AppSettings::binaryExts() const
{
    if (m_binaryExts.isEmpty()) {

        return QString{".zip\n.pdf"};
    }
    return m_binaryExts;
}

const QString AppSettings::autoTypeCmd() const
{
    if (m_autoTypeCmd.isEmpty()) {
#ifdef __linux__
            return R"V0G0N(echo -n sequence | xclip -selection clipboard)V0G0N";
#else
        return QString{};
#endif
    }
    return m_autoTypeCmd;
}


const QString AppSettings::ctxSigner() const
{
    return m_ctxSigner;
}


const QString AppSettings::fontSize() const {
    if (m_fontSize.isEmpty()){
        return QString::number(QApplication::font().pointSize());
    }
    return m_fontSize;
}


const QString AppSettings::commitMsg() const {
    if (m_commitMsg.isEmpty()){
        return "pass simple";
    }
    return m_commitMsg;
}

QString AppSettings::appVer() {
    return "App:" + QString(PROJECT_VER) + " qt:" + qVersion();
}

const QString AppSettings::getFindExecutable(const QString &exec) const
{
    auto full_path = QStandardPaths::findExecutable(exec);
    if (full_path.isEmpty()){
        full_path = QStandardPaths::findExecutable(exec,{"/usr/local/bin","/opt/homebrew/bin"});
    }

    return full_path;
}
