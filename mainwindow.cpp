#include "AppSettings.h"
#include <QAction>
#include <QClipboard>
#include <QMenu>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScroller>
#include <QSystemTrayIcon>
#include <QFontDatabase>
#include <QGraphicsScene>
#include <QGraphicsColorizeEffect>
#include <QGraphicsPixmapItem>
#include <QPainter>
#include "ui_mainwindow.h"
#include "ui_about.h"
#include "mainwindow.h"

QImage MainWindow::shape_icon(const QString &icon, const QColor &color, const qreal &strength, const int &w, const int &h)
{
    // Resize icon and put it into QImage
    QImage src = QIcon(icon).pixmap(QSize(w,h)).toImage();
    if(src.isNull()) return QImage();

    // prepare graphics scene and pixmap
    QGraphicsScene scene;
    QGraphicsPixmapItem item;
    item.setPixmap(QPixmap::fromImage(src));

    // create an effect with color and strength
    QGraphicsColorizeEffect effect;
    effect.setColor(color);
    effect.setStrength(strength);
    item.setGraphicsEffect(&effect);
    scene.addItem(&item);
    QImage res = src;
    QPainter ptr(&res);
    scene.render(&ptr, QRectF(), src.rect() );
    return res;
}

void MainWindow::SetActionItems()
{
    actionAddItem = new QAction(getIcon("://icons/outline_add_file_black_24dp.png")
                                ,tr("Add Item"), this);    
    actionUploadFile = new QAction(getIcon("://icons/outline_file_upload_black_24dp.png"),tr("Upload file"), this);
    actionUploadFolder = new QAction(getIcon("://icons/outline_drive_folder_upload_black_24dp.png"),tr("Upload folder content"), this);
    actionDownloadFile = new QAction(getIcon("://icons/outline_file_download_black_24dp.png"),tr("Download file"), this);
    actionDownloadFolder = new QAction(getIcon("://icons/outline_drive_folder_download_black_24dp.png"),tr("Download folder content"), this);
    actionAbout = new QAction(getIcon("://icons/outline_info_black_24dp.png"),tr("About"), this);
    actionQuit = new QAction(getIcon("://icons/outline_exit_to_app_black_24dp.png"),tr("Quit"), this);

}

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    QFont font = QApplication::font();
    font.setPointSize(appSettings.fontSize().toInt());
    QApplication::setFont(font);


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

    QAction *logoutAction = new QAction(tr("Logout"), this);
    connect(logoutAction, &QAction::triggered, qApp, [=]() {
        AppSettings appSettings{};
        QString rootPath = appSettings.passwordStorePath();
        mainqmltype->setTreeViewSelected(rootPath);


        auto full_path = appSettings.getFindExecutable("gpgconf");


        if (full_path.isEmpty()){
            qDebug()<<"could not found gpgconf";
            return;
        }
        QProcess::startDetached(full_path, QStringList() <<"--kill"<<"gpg-agent");
    });
    trayIconMenu->addAction(logoutAction);

    QAction *quitAction = new QAction(tr("&Quit"), this);
    connect(quitAction, &QAction::triggered, qApp, &QCoreApplication::quit);
    trayIconMenu->addAction(quitAction);

    trayIcon->setContextMenu(trayIconMenu);
    trayIcon->setIcon(QIcon(":/icon.png"));
    trayIcon->show();

    QVariantMap variantMap;
    variantMap.insert("color",QColor(10,10,10));

    SetActionItems();

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
    mainqmltype = new MainQmlType(
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

    connect(mainqmltype, &MainQmlType::setTreeviewCurrentIndex, this, &MainWindow::setTreeviewCurrentIndex);


    connect(mainqmltype, &MainQmlType::setRootTreeView, this, [=](QString rootPath) {
        if (!rootPath.isEmpty()) {
            const QModelIndex rootIndex = filesystemModel->index(QDir::cleanPath(rootPath));
            if (rootIndex.isValid())
                ui->treeView->setRootIndex(rootIndex);
        }

    });

    connect(mainqmltype, &MainQmlType::systemPlateChanged, this, [=](bool isDarkTheme) {
        actionAddItem->setIcon(getIcon("://icons/outline_add_file_black_24dp.png"));
        actionUploadFile->setIcon(getIcon("://icons/outline_file_upload_black_24dp.png"));
        actionUploadFolder->setIcon(getIcon("://icons/outline_drive_folder_upload_black_24dp.png"));
        actionDownloadFile->setIcon(getIcon("://icons/outline_file_download_black_24dp.png"));
        actionDownloadFolder->setIcon(getIcon("://icons/outline_drive_folder_download_black_24dp.png"));
        actionAbout->setIcon(getIcon("://icons/outline_info_black_24dp.png"));
        actionQuit->setIcon(getIcon("://icons/outline_exit_to_app_black_24dp.png"));

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

        AppSettings appSettings{};
        QString rootPath = appSettings.passwordStorePath();
        mainqmltype->setTreeViewSelected(rootPath);
        setQmlSource();

     });


    keyZoomOut = new QShortcut(this);
    keyZoomOut->setKeys({Qt::CTRL | Qt::Key_Minus, Qt::CTRL | Qt::Key_Underscore});
    connect(keyZoomOut, &QShortcut::activated, this, [=]() {
        QFont font = QApplication::font();
        font.setPointSize(font.pointSize()-1);
        QApplication::setFont(font);

        AppSettings appSettings{};
        QString rootPath = appSettings.passwordStorePath();
        mainqmltype->setTreeViewSelected(rootPath);
        setQmlSource();

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
        if(mainqmltype->getNearestGpgId().isEmpty()){
            actionDownloadFolder->setEnabled(false);
            actionUploadFolder->setEnabled(false);
            actionUploadFile->setEnabled(false);
            actionAddItem->setEnabled(false);
        } else {
            actionDownloadFolder->setEnabled(true);
            actionUploadFolder->setEnabled(true);
            actionUploadFile->setEnabled(true);
            actionAddItem->setEnabled(true);
        }
        if(mainqmltype->isGpgFile()){
            actionDownloadFile->setEnabled(true);
        } else {
            actionDownloadFile->setEnabled(false);
        }

    } catch (const std::exception &e) {
        qDebug() << e.what();
    }
}

void MainWindow::initFileSystemModel(QString filePath)
{
    static QList<QMetaObject::Connection> connections;
    foreach (auto var, connections) {
        QObject::disconnect(var);
    }
    filesystemModel->deleteLater();
    filesystemModel = new QFileSystemModel(this);
    filesystemModel->setIconProvider(&iconProvider);
    filesystemModel->setRootPath("");
    filesystemModel->setOption(QFileSystemModel::DontWatchForChanges);
    filesystemModel->setFilter( // QDir::Hidden |
        QDir::NoDotAndDotDot | QDir::AllDirs | QDir::AllEntries);

    ui->treeView->setModel(filesystemModel);

    AppSettings appSettings{};
    QString rootPath = appSettings.passwordStorePath();

    if (!rootPath.isEmpty()) {
        const QModelIndex rootIndex = filesystemModel->index(QDir::cleanPath(rootPath));
        if (rootIndex.isValid())
            ui->treeView->setRootIndex(rootIndex);

    }


    // selection changes shall trigger a slot
    QItemSelectionModel *selectionModel = ui->treeView->selectionModel();
    connections << connect(selectionModel,
            &QItemSelectionModel::selectionChanged,
            this,
            &MainWindow::selectionChangedSlot
            );

    connections << connect(selectionModel,
            &QItemSelectionModel::currentChanged,
            this,
            &MainWindow::currentChangedSlot
            );
    static bool setDirectoryLoadedOnce = false;
    setDirectoryLoadedOnce=false;
    connections << QObject::connect(filesystemModel, &QFileSystemModel::directoryLoaded, [=](const QString &directory) {
        if (!setDirectoryLoadedOnce) {
            setDirectoryLoadedOnce = true;
            setTreeviewCurrentIndex(filePath);
        }
    });









}

void MainWindow::setTreeviewCurrentIndex(QString filePath)
{

    if(!filePath.isEmpty()){
        const QModelIndex idx=filesystemModel->index(QDir::cleanPath(filePath));
        if (idx.isValid()){
            try {
                ui->treeView->setCurrentIndex(idx);
            } catch (const std::exception &e) {
                qDebug() << e.what();
            }
        }
    }

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
