#pragma once

#include "config.h"
#include "mainqmltype.h"
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

private:
    Ui::MainWindow *ui;
    QFileSystemModel *filesystemModel;
    QFileIconProvider iconProvider;
    MainQmlType *mainqmltype;
    QModelIndex treeIndex;
    QShortcut *keyZoomIn;
    QShortcut *keyZoomOut;
    AppSettings appSettings;

    bool treeViewItemSelected = false;

    void setQmlSource();
};
