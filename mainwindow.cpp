#include "AppSettings.h"
#include <QAction>
#include <QClipboard>
#include <QMenu>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScroller>
#include <QSystemTrayIcon>
#include <QTimer>

#include "./ui_mainwindow.h"
#include "UiGuard.h"
#include "mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    AppSettings as;

    QSystemTrayIcon *trayIcon = new QSystemTrayIcon(this);
    QMenu *trayIconMenu = new QMenu(this);

    QMenu *autoTypeFields = new QMenu(tr("auto type field"), this);


    trayIconMenu->addMenu(autoTypeFields);
    QAction *autoTypeSelected = new QAction(tr("auto type selected"), this);
    trayIconMenu->addAction(autoTypeSelected);

    QAction *clearClipboard = new QAction(tr("Clear clipboard"), this);

    connect(clearClipboard, &QAction::triggered, autoTypeFields, [=]() {
        QClipboard *clipboard = QGuiApplication::clipboard();
        clipboard->clear();
    });

    trayIconMenu->addAction(clearClipboard);
    trayIconMenu->addSeparator();

    QAction *quitAction = new QAction(tr("&Quit"), this);
    connect(quitAction, &QAction::triggered, qApp, &QCoreApplication::quit);

    trayIconMenu->addAction(quitAction);
    trayIcon->setContextMenu(trayIconMenu);
    trayIcon->setIcon(QIcon(":/icon.png"));
    trayIcon->show();

    QAction *addItemAct = new QAction(QIcon("://icons/icons8-add-file-64.png"),tr("Add Item"), this);

    QAction *uploadFileAct = new QAction(QIcon("://icons/icons8-upload-file-64.png"),tr("Upload file"), this);
    QAction *uploadFolderAct = new QAction(QIcon("://icons/icons8-upload-folder-67.png"),tr("Upload folder content"), this);

    QAction *downloadFileAct = new QAction(QIcon("://icons/icons8-download-file-64.png"),tr("Download file"), this);
    QAction *downloadFolderAct = new QAction(QIcon("://icons/icons8-download-folder-67.png"),tr("Download folder content"), this);

    QAction *quitQtAct = new QAction(QIcon("://icons/icons8-logout-64.png"),tr("Quit"), this);
    quitQtAct->setStatusTip(tr("Quit"));
    connect(quitQtAct, &QAction::triggered, this, &QApplication::quit);

    ui->toolBar->addAction(addItemAct);
    ui->toolBar->addSeparator();
    ui->toolBar->addAction(uploadFileAct);
    ui->toolBar->addAction(uploadFolderAct);
    ui->toolBar->addSeparator();
    ui->toolBar->addAction(downloadFileAct);
    ui->toolBar->addAction(downloadFolderAct);
    ui->toolBar->addSeparator();
    ui->toolBar->addAction(quitQtAct);

    filesystemModel.setIconProvider(&iconProvider);
    filesystemModel.setRootPath("");
    filesystemModel.setFilter( // QDir::Hidden |
        QDir::NoDotAndDotDot | QDir::AllDirs | QDir::AllEntries);

    ui->treeView->setModel(&filesystemModel);
    ui->splitter->setSizes(QList<int>({150, 400})); // INT_MAX

    // Demonstrating look and feel features
    ui->treeView->setAnimated(false);
    ui->treeView->setIndentation(20);
    ui->treeView->setSortingEnabled(true);

    // const QSize availableSize = ui->treeView->size(); //ui->treeView->screen()
    //->availableGeometry().size();
    // ui->treeView->resize(availableSize / 2);
    ui->treeView->setColumnWidth(0, 200);
    ui->treeView->setColumnWidth(1, 10);
    ui->treeView->setColumnWidth(2, 10);

    // Make it flickable on touchscreens
    QScroller::grabGesture(ui->treeView, QScroller::TouchGesture);

    ui->treeView->setWindowTitle(QObject::tr("Dir View"));

    ui->quickWidget->setClearColor(Qt::transparent);
    ui->quickWidget->setAttribute(Qt::WA_AlwaysStackOnTop);

    QQmlContext *context = ui->quickWidget->rootContext();
    mainqmltype = new MainQmlType(&filesystemModel,
                                  ui->treeView,
                                  ui->splitter,
                                  autoTypeFields,
                                  autoTypeSelected,
                                  ui->quickWidget); // NOLINT
    context->setContextProperty(QStringLiteral("mainqmltype"), mainqmltype);

    mainqmltype->setFilePanSize(150);
    ui->quickWidget->setSource(QUrl("qrc:/mainQml.qml"));

    // selection changes shall trigger a slot
    QItemSelectionModel *selectionModel = ui->treeView->selectionModel();
    connect(selectionModel,
            SIGNAL(selectionChanged(const QItemSelection &, const QItemSelection &)),
            this,
            SLOT(selectionChangedSlot(const QItemSelection &, const QItemSelection &)));

    QObject::connect(ui->quickWidget->engine(),
                     &QQmlApplicationEngine::quit,
                     this,
                     &QGuiApplication::quit);

    connect(addItemAct, &QAction::triggered, this, [=]() {
           mainqmltype->setMenubarCommStr("addItemAct");
     });
    connect(uploadFileAct, &QAction::triggered, this, [=]() {
           mainqmltype->setMenubarCommStr("uploadFileAct");
     });
    connect(uploadFolderAct, &QAction::triggered, this, [=]() {
           mainqmltype->setMenubarCommStr("uploadFolderAct");
     });
    connect(downloadFileAct, &QAction::triggered, this, [=]() {
           mainqmltype->setMenubarCommStr("downloadFileAct");
     });
    connect(downloadFolderAct, &QAction::triggered, this, [=]() {
           mainqmltype->setMenubarCommStr("downloadFolderAct");
     });
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::indexHasChanged()
{
    UiGuard guard(this);
    // get the text of the selected item

    auto idx = treeIndex.model()->index(treeIndex.row(), 0, treeIndex.parent());
    try {
        mainqmltype->setFilePath(filesystemModel.filePath(idx));
    } catch (const std::exception &e) {
        qDebug() << e.what();
    }
}

void MainWindow::selectionChangedSlot(const QItemSelection & /*newSelection*/,
                                      const QItemSelection & /*oldSelection*/)
{
    treeIndex = ui->treeView->selectionModel()->currentIndex();
    QTimer::singleShot(10, this, SLOT(indexHasChanged()));
}

void MainWindow::on_splitter_splitterMoved(int pos, int index)
{
    if (index == 1) {
        mainqmltype->setFilePanSize(pos);
    }
}
