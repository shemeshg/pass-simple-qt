#pragma once

#include "config.h"
#include "mainqmltype.h"
#include "appfilesysmodel.h"
#include <QFileIconProvider>
#include <QFileSystemModel>
#include <QMainWindow>
#include <QMessageBox>
#include <QModelIndex>
#include <QTreeView>
#include <QShortcut>

QT_BEGIN_NAMESPACE
namespace Ui {
class MainWindow;
}
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();



private slots:
    void on_splitter_splitterMoved(int pos, int index);
    void selectionChangedSlot(const QItemSelection &current /*newSelection*/,
                              const QItemSelection previous /*oldSelection*/);
    void currentChangedSlot(const QModelIndex &current, const QModelIndex &previous);

    void about() { QMessageBox::about(this, tr("About Menu"), tr("Version %1").arg(PROJECT_VER)); }

    void initFileSystemModel(QString filePath);

    void setTreeviewCurrentIndex(QString filePath);



    void prepareMenu(const QPoint &pos);
private:
    Ui::MainWindow *ui;
    AppFileSysModel *filesystemModel = new AppFileSysModel(this);
    QFileIconProvider iconProvider;
    MainQmlType *mainqmltype;
    QModelIndex treeIndex;
    QShortcut *keyZoomIn;
    QShortcut *keyZoomOut;
    AppSettings appSettings;

    QAction *actionAddItem;
    QAction *actionUploadFile;
    QAction *actionUploadFolder;
    QAction *actionDownloadFile;
    QAction *actionDownloadFolder;
    QAction *actionAbout;
    QAction *actionQuit;    

    bool treeViewItemSelected = false;

    void setQmlSource();

    QImage shape_icon(const QString &icon, const QColor &color, const qreal &strength=1.0, const int &w=40, const int &h=40);

    QPixmap getIcon(QString s){
        return QPixmap::fromImage(
            shape_icon(s,QApplication::palette().text().color()));
    }

    void SetActionItems();

    bool is_subpath(const std::filesystem::path& path, const std::filesystem::path& base);

};
