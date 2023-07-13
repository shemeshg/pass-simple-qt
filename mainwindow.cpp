#include "AppSettings.h"
#include <QAction>
#include <QClipboard>
#include <QMenu>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScroller>
#include <QSystemTrayIcon>
#include <QTimer>
#include <QFontDatabase>

#include "ui_mainwindow.h"
#include "ui_about.h"
#include "mainwindow.h"

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);



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

    auto actionAddItem = new QAction(QIcon("://icons/outline_add_file_black_24dp.png"),tr("Add Item"), this);
    auto actionUploadFile = new QAction(QIcon("://icons/outline_file_upload_black_24dp.png"),tr("Upload file"), this);
    auto actionUploadFolder = new QAction(QIcon("://icons/outline_drive_folder_upload_black_24dp.png"),tr("Upload folder content"), this);
    auto actionDownloadFile = new QAction(QIcon("://icons/outline_file_download_black_24dp.png"),tr("Download file"), this);
    auto actionDownloadFolder = new QAction(QIcon("://icons/outline_drive_folder_download_black_24dp.png"),tr("Download folder content"), this);
    auto actionAbout = new QAction(QIcon("://icons/outline_info_black_24dp.png"),tr("About"), this);
    auto actionQuit = new QAction(QIcon("://icons/outline_exit_to_app_black_24dp.png"),tr("Quit"), this);

    actionQuit->setStatusTip(tr("Quit"));
    connect(actionQuit, &QAction::triggered, this, &QApplication::quit);

    connect(actionAddItem, &QAction::triggered, this, [=]() {
        mainqmltype->setMenubarCommStr("addItemAct");
        ui->quickWidget->setFocus();
    });
    connect(actionUploadFile, &QAction::triggered, this, [=]() {
        mainqmltype->setMenubarCommStr("uploadFileAct");
    });
    connect(actionUploadFolder, &QAction::triggered, this, [=]() {
       mainqmltype->setMenubarCommStr("uploadFolderAct");
    });
    connect(actionDownloadFile, &QAction::triggered, this, [=]() {
        mainqmltype->setMenubarCommStr("downloadFileAct");
    });
    connect(actionDownloadFolder, &QAction::triggered, this, [=]() {
       mainqmltype->setMenubarCommStr("downloadFolderAct");
    });
    connect(actionAbout, &QAction::triggered, this, [=]() {
        auto aboutDialog = new QDialog(this);
        auto aboutUI = new Ui::AboutDialog();
        aboutUI->setupUi(aboutDialog);
        aboutUI->versionLabel->setText(AppSettings::appVer());
        aboutDialog->exec();
    });

    ui->toolBar->addAction(actionAddItem);
    ui->toolBar->addSeparator();
    ui->toolBar->addAction(actionUploadFile);
    ui->toolBar->addAction(actionUploadFolder);
    ui->toolBar->addSeparator();
    ui->toolBar->addAction(actionDownloadFile);
    ui->toolBar->addAction(actionDownloadFolder);
    ui->toolBar->addSeparator();
    ui->toolBar->addAction(actionAbout);
    ui->toolBar->addSeparator();
    ui->toolBar->addAction(actionQuit);

    initFileSystemModel("");

    ui->splitter->setSizes(QList<int>({150, 400})); // INT_MAX

    // Demonstrating look and feel features
    ui->treeView->setAnimated(false);
    ui->treeView->setIndentation(20);
    ui->treeView->setSortingEnabled(true);
    ui->treeView->header()->setSortIndicator(0,Qt::SortOrder::AscendingOrder);

    // const QSize availableSize = ui->treeView->size(); //ui->treeView->screen()
    //->availableGeometry().size();
    // ui->treeView->resize(availableSize / 2);
    ui->treeView->setColumnWidth(0, 200);
    ui->treeView->setColumnWidth(1, 10);
    ui->treeView->setColumnWidth(2, 10);

    ui->treeView->setDragEnabled(true);

    // Make it flickable on touchscreens
    QScroller::grabGesture(ui->treeView, QScroller::TouchGesture);

    ui->treeView->setWindowTitle(QObject::tr("Dir View"));

    ui->quickWidget->setClearColor(Qt::transparent);
    ui->quickWidget->setAttribute(Qt::WA_AlwaysStackOnTop);

    QQmlContext *context = ui->quickWidget->rootContext();
    mainqmltype = new MainQmlType(filesystemModel,
                                  ui->treeView,
                                  ui->splitter,
                                  autoTypeFields,
                                  autoTypeSelected,
                                  ui->quickWidget); // NOLINT

    static bool isQuickWidgetFocus = ui->quickWidget->hasFocus();
    connect(mainqmltype, &MainQmlType::mainUiDisable, this, [=]() {
        isQuickWidgetFocus = ui->quickWidget->hasFocus();
        QWidget::setEnabled(false);
    });
    connect(mainqmltype, &MainQmlType::mainUiEnable, this, [=]() {
        QWidget::setEnabled(true);
        if(isQuickWidgetFocus){
            ui->quickWidget->setFocus();
        } else {
            ui->treeView->setFocus();
        }

    });
    connect(mainqmltype, &MainQmlType::initFileSystemModel, this, [=](QString filePath) {
        initFileSystemModel(filePath);

    });

    context->setContextProperty(QStringLiteral("mainqmltype"), mainqmltype);

    mainqmltype->setFilePanSize(150);

    setQmlSource();






    QObject::connect(ui->quickWidget->engine(),
                     &QQmlApplicationEngine::quit,
                     this,
                     &QGuiApplication::quit);

    keyZoomIn = new QShortcut(this);
    //Qt::CTRL + Qt::Key\_P
    keyZoomIn->setKeys({Qt::CTRL | Qt::Key_Plus,Qt::CTRL | Qt::Key_Equal});
    connect(keyZoomIn, &QShortcut::activated, this, [=]() {
        QFont font = QApplication::font();
        font.setPointSize(font.pointSize()+1);
        QApplication::setFont(font);
        //QString  s = mainqmltype->filePath();
        setQmlSource();
        if (treeViewItemSelected){            
            QTimer::singleShot(10, this, SLOT(indexHasChanged()));
        }

     });


    keyZoomOut = new QShortcut(this);
    keyZoomOut->setKeys({Qt::CTRL | Qt::Key_Minus, Qt::CTRL | Qt::Key_Underscore});
    connect(keyZoomOut, &QShortcut::activated, this, [=]() {
        QFont font = QApplication::font();
        font.setPointSize(font.pointSize()-1);
        QApplication::setFont(font);
        setQmlSource();
        if (treeViewItemSelected){            
            QTimer::singleShot(10, this, SLOT(indexHasChanged()));
        }
     });
}

MainWindow::~MainWindow()
{
    delete ui;
}



void MainWindow::selectionChangedSlot(const QItemSelection &current /*newSelection*/,
                                      const QItemSelection previous /*oldSelection*/)
{

}

void MainWindow::currentChangedSlot(const QModelIndex &current, const QModelIndex &previous)
{
    try {
        treeIndex = current; //ui->treeView->selectionModel()->currentIndex();
        auto idx = treeIndex.model()->index(treeIndex.row(), 0, treeIndex.parent());
        mainqmltype->setFilePath(filesystemModel->filePath(idx));
        treeViewItemSelected = true;
    } catch (const std::exception &e) {
        qDebug() << e.what();
    }
}

void MainWindow::initFileSystemModel(QString filePath)
{
    /*
    if(filesystemModel != nullptr) {
        filesystemModel->deleteLater();
    }
    */

    filesystemModel = new QFileSystemModel(this);
    filesystemModel->setIconProvider(&iconProvider);
    filesystemModel->setRootPath("");
    filesystemModel->setOption(QFileSystemModel::DontWatchForChanges);
    filesystemModel->setFilter( // QDir::Hidden |
        QDir::NoDotAndDotDot | QDir::AllDirs | QDir::AllEntries);

    ui->treeView->setModel(filesystemModel);

    QString rootPath = appSettings.passwordStorePath();

    if (!rootPath.isEmpty()) {
        const QModelIndex rootIndex = filesystemModel->index(QDir::cleanPath(rootPath));
        if (rootIndex.isValid())
            ui->treeView->setRootIndex(rootIndex);
    }

    // selection changes shall trigger a slot
    QItemSelectionModel *selectionModel = ui->treeView->selectionModel();
    connect(selectionModel,
            &QItemSelectionModel::selectionChanged,
            this,
            &MainWindow::selectionChangedSlot
            );

    connect(selectionModel,
            &QItemSelectionModel::currentChanged,
            this,
            &MainWindow::currentChangedSlot
            );

    QTimer::singleShot(500, this, [=](){
        if(!filePath.isEmpty()){
            const QModelIndex idx=filesystemModel->index(QDir::cleanPath(filePath));
            if (idx.isValid()){
                ui->treeView->setCurrentIndex(idx);
            }
        }
    });

}

void MainWindow::setQmlSource()
{
    ui->quickWidget->setSource(QUrl("qrc:/qt/qml/MainQml/Main.qml"));
}

void MainWindow::on_splitter_splitterMoved(int pos, int index)
{
    if (index == 1) {
        mainqmltype->setFilePanSize(pos);
    }
}
