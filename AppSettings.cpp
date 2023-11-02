#include <QStandardPaths>
#include "AppSettings.h"
#include "config.h"

AppSettings::AppSettings(QObject *parent)
    : QObject(parent)
{
    m_passwordStorePath = settings.value("passwordStorePath", "").toString();
    m_tmpFolderPath = settings.value("tmpFolderPath", "").toString();
    m_gitExecPath = settings.value("gitExecPath", "").toString();
    m_vscodeExecPath = settings.value("vscodeExecPath", "").toString();
    m_autoTypeCmd = settings.value("autoTypeCmd", "").toString();
    m_binaryExts = settings.value("binaryExts", "").toString();
    m_ctxSigner = settings.value("ctxSigner", "").toString();
    m_useClipboard = settings.value("useClipboard", false).toBool();
    m_doSign = settings.value("doSign", false).toBool();
    m_preferYamlView = settings.value("preferYamlView", true).toBool();
    m_fontSize = settings.value("fontSize", "").toString();
    m_commitMsg = settings.value("commitMsg", "").toString();
    m_isFindMemCash = settings.value("isFindMemCash", false).toBool();
    m_isShowPreview = settings.value("isShowPreview", true).toBool();
    m_isFindSlctFrst = settings.value("isFindSlctFrst", false).toBool();
    m_openWith = settings.value("openWith", 0).toInt();
}


const QString AppSettings::passwordStorePath() const
{
    QString passwordStorePathDefault = QDir::homePath() + "/.password-store";
    if (m_passwordStorePath.isEmpty() || !QDir(m_passwordStorePath).exists()) {
        return passwordStorePathDefault;
    }


    return QDir(m_passwordStorePath).absolutePath();
}

void AppSettings::setPasswordStorePath(const QString &passwordStorePath)
{
    if (passwordStorePath == m_passwordStorePath)
        return;


    m_passwordStorePath = passwordStorePath;    
    settings.setValue("passwordStorePath", m_passwordStorePath);
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

void AppSettings::setTmpFolderPath(const QString &tmpFolderPath)
{
    if (tmpFolderPath == m_tmpFolderPath)
        return;
    m_tmpFolderPath = tmpFolderPath;
    settings.setValue("tmpFolderPath", m_tmpFolderPath);
}

const QString AppSettings::gitExecPath() const
{
    if (m_gitExecPath.isEmpty()) {
        return getFindExecutable("git");
    }
    return m_gitExecPath;
}

void AppSettings::setGitExecPath(const QString &gitExecPath)
{
    if (gitExecPath == m_gitExecPath)
        return;
    m_gitExecPath = gitExecPath;
    settings.setValue("gitExecPath", m_gitExecPath);
    emit gitExecPathChanged();
}

void AppSettings::setCtxSigner(const QString &ctxSigner)
{
    if (ctxSigner == m_ctxSigner)
        return;
    m_ctxSigner = ctxSigner;
    settings.setValue("ctxSigner", m_ctxSigner);
    emit ctxSignerChanged();
}

QString AppSettings::vscodeExecPath() const
{
    if (m_vscodeExecPath.isEmpty()) {
        return getFindExecutable("code");
    }
    return m_vscodeExecPath;
}

void AppSettings::setVscodeExecPath(const QString &vscodeExecPath)
{
    if (vscodeExecPath == m_vscodeExecPath)
        return;

    m_vscodeExecPath = vscodeExecPath;
    settings.setValue("vscodeExecPath", m_vscodeExecPath);

    emit vscodeExecPathChanged();
}


const QString AppSettings::binaryExts() const
{
    if (m_binaryExts.isEmpty()) {

        return QString{".zip\n.pdf"};
    }
    return m_binaryExts;
}

void AppSettings::setBinaryExts(const QString &binaryExts)
{
    if (binaryExts == m_binaryExts)
        return;
    m_binaryExts = binaryExts;
    settings.setValue("binaryExts", m_binaryExts);
    emit binaryExtsChanged();
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

void AppSettings::setAutoTypeCmd(const QString &autoTypeCmd)
{
    if (autoTypeCmd == m_autoTypeCmd)
        return;
    m_autoTypeCmd = autoTypeCmd;
    settings.setValue("autoTypeCmd", m_autoTypeCmd);
    emit autoTypeCmdChanged();
}

void AppSettings::setUseClipboard(const bool useClipboard)
{
    if (useClipboard == m_useClipboard)
        return;
    m_useClipboard = useClipboard;
    settings.setValue("useClipboard", m_useClipboard);
    emit useClipboardChanged();
}

void AppSettings::setDoSign(const bool doSign)
{
    if (doSign == m_doSign)
        return;
    m_doSign = doSign;
    settings.setValue("doSign", m_doSign);
    emit doSignChanged();
}

void AppSettings::setIsFindMemCash(const bool isFindMemCash)
{
    if (isFindMemCash == m_isFindMemCash)
        return;
    m_isFindMemCash = isFindMemCash;

    emit isFindMemCashChanged();
}

void AppSettings::setIsShowPreview(const bool isShowPreview)
{
    if (isShowPreview == m_isShowPreview)
        return;
    m_isShowPreview= isShowPreview;

    emit isShowPreviewChanged();
}

void AppSettings::setOpenWith(const int openWith)
{
    if (openWith == m_openWith)
        return;
    m_openWith= openWith;

    emit openWithChanged();
}

void AppSettings::setIsFindSlctFrst(const bool isFindSlctFrst)
{
    if (isFindSlctFrst == m_isFindSlctFrst)
        return;
    m_isFindSlctFrst = isFindSlctFrst;    
    emit isFindSlctFrstChanged();
}

void AppSettings::setPreferYamlView(const bool preferYamlView)
{
    if (preferYamlView == m_preferYamlView)
        return;
    m_preferYamlView = preferYamlView;
    settings.setValue("preferYamlView", m_preferYamlView);
    emit preferYamlViewChanged();
}

void AppSettings::setfontSize(const QString fontSize)
{
    if (fontSize == m_fontSize)
        return;

    m_fontSize = fontSize;
    settings.setValue("fontSize", m_fontSize);
    emit fontSizeChanged();
}

void AppSettings::setCommitMsg(const QString commitMsg)
{
    if (commitMsg == m_commitMsg)
        return;

    m_commitMsg = commitMsg;
    settings.setValue("commitMsg", m_commitMsg);
    emit commitMsgChanged();
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
