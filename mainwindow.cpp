#include "AppSettings.h"
#include <QAction>
#include <QClipboard>
#include <QMenu>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScroller>
#include <QSystemTrayIcon>
#include <QTimer>


#include "ui_mainwindow.h"
#include "ui_about.h"
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

    keyZoomIn = new QShortcut(this);
    //Qt::CTRL + Qt::Key\_P
    keyZoomIn->setKeys({Qt::CTRL | Qt::Key_Plus,Qt::CTRL | Qt::Key_Equal});
    connect(keyZoomIn, &QShortcut::activated, this, [=]() {
        QFont font = QApplication::font();
        font.setPointSize(font.pointSize()+1);
        QApplication::setFont(font);
        QString  s = mainqmltype->filePath();
        ui->quickWidget->setSource(QUrl("qrc:/mainQml.qml"));
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
        ui->quickWidget->setSource(QUrl("qrc:/mainQml.qml"));
        if (treeViewItemSelected){
            QTimer::singleShot(10, this, SLOT(indexHasChanged()));
        }
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
        treeViewItemSelected = true;
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
