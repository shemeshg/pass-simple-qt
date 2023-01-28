#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QFileSystemModel>
#include <QFileIconProvider>
#include "mainqmltype.h"
#include <QTreeView>
#include <QModelIndex>
#include "UiGuard.h"

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();


public slots:
    void indexHasChanged(){

        UiGuard guard(this);
        //get the text of the selected item

        auto idx = treeIndex.model()->index(treeIndex.row(), 0, treeIndex.parent());
        try {

            mainqmltype->setFilePath(filesystemModel.filePath(idx));
        } catch (const std::exception& e) {
            qDebug()<<e.what();
        }


    }

private slots:

    void on_splitter_splitterMoved(int pos, int index);

    void selectionChangedSlot(const QItemSelection & /*newSelection*/, const QItemSelection & /*oldSelection*/);


private:
    Ui::MainWindow *ui;
    QFileSystemModel filesystemModel;
    QFileIconProvider iconProvider;
    MainQmlType *mainqmltype;
    QModelIndex treeIndex;
};
#endif // MAINWINDOW_H
