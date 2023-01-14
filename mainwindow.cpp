#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include <QQmlContext>
#include <QScroller>

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    filesystemModel.setIconProvider(&iconProvider);
    filesystemModel.setRootPath("");
    filesystemModel.setFilter(QDir::Hidden | QDir::NoDotAndDotDot | QDir::AllDirs | QDir::AllEntries);

    ui->treeView->setModel(&filesystemModel);
    QString rootPath = QDir::homePath() + "/.password-store";

        if (!rootPath.isEmpty()) {
            const QModelIndex rootIndex = filesystemModel.index(QDir::cleanPath(rootPath));
            if (rootIndex.isValid())
                ui->treeView->setRootIndex(rootIndex);
        }

        ui->splitter->setSizes(QList<int>({150  , 400}));//INT_MAX

        // Demonstrating look and feel features
        ui->treeView->setAnimated(false);
        ui->treeView->setIndentation(20);
        ui->treeView->setSortingEnabled(true);


        //const QSize availableSize = ui->treeView->size(); //ui->treeView->screen()
        //->availableGeometry().size();
        //ui->treeView->resize(availableSize / 2);
        ui->treeView->setColumnWidth(0, 200);
        ui->treeView->setColumnWidth(1, 10);
        ui->treeView->setColumnWidth(2, 10);


        // Make it flickable on touchscreens
        QScroller::grabGesture(ui->treeView, QScroller::TouchGesture);

        ui->treeView->setWindowTitle(QObject::tr("Dir View"));

        ui->quickWidget->setClearColor(Qt::transparent);
        ui->quickWidget->setAttribute(Qt::WA_AlwaysStackOnTop);

        QQmlContext *context = ui->quickWidget->rootContext();
        mainqmltype = new MainQmlType(ui->splitter, ui->quickWidget); //NOLINT
        context->setContextProperty(QStringLiteral("mainqmltype"),mainqmltype);

        mainqmltype->setFilePanSize(150);
        ui->quickWidget->setSource(QUrl("qrc:/mainQml.qml"));
}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::on_splitter_splitterMoved(int pos, int index)
{
    if (index == 1){
        mainqmltype->setFilePanSize(pos);
    }

}


void MainWindow::on_treeView_clicked(const QModelIndex &index)
{    
    auto idx = index.model()->index(index.row(), 0, index.parent());
    mainqmltype->setFilePath(filesystemModel.filePath(idx));
}

