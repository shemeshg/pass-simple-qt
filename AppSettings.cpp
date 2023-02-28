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
    m_ctxSigner = settings.value("ctxSigner", "").toString();
    m_useClipboard = settings.value("useClipboard", "").toBool();
    m_preferYamlView = settings.value("preferYamlView", "").toBool();
    m_fontSize = settings.value("fontSize", "14").toInt();
}

const QString AppSettings::passwordStorePath() const
{
    QString passwordStorePathDefault = QDir::homePath() + "/.password-store";
    if (m_passwordStorePath.isEmpty() || !QDir(m_passwordStorePath).exists()) {
        return passwordStorePathDefault;
    }

    return m_passwordStorePath;
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
    if (!QDir(m_tmpFolderPath).exists()) {
        QString tmpFolderPathDefault = QDir::tempPath();
#ifdef __linux__
        if (QDir("/dev/shm").exists()) {
            tmpFolderPathDefault = "/dev/shm";
        }
#endif
        return tmpFolderPathDefault;
    }
    return m_tmpFolderPath;
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
        auto full_path = QStandardPaths::findExecutable("git");
        return full_path;
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

            auto full_path = QStandardPaths::findExecutable("code",{"/usr/local/bin"});
            if (full_path.isEmpty()){
                full_path = QStandardPaths::findExecutable("code");
            }
            return full_path;
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

void AppSettings::setPreferYamlView(const bool preferYamlView)
{
    if (preferYamlView == m_preferYamlView)
        return;
    m_preferYamlView = preferYamlView;
    settings.setValue("preferYamlView", m_preferYamlView);
    emit preferYamlViewChanged();
}

void AppSettings::setfontSize(const int fontSize)
{
    if (fontSize == m_fontSize)
        return;
    m_fontSize = fontSize;
    settings.setValue("fontSize", m_fontSize);
    emit fontSizeChanged();
}

QString AppSettings::appVer() const {
    return "App:" + QString(PROJECT_VER) + " qt:" + qVersion();
}
