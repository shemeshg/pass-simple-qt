#include "mainwindow.h"
#include "AppSettings.h"
#include "ui_about.h"
#include "ui_mainwindow.h"
#include <QAction>
#include <QClipboard>
#include <QFileDialog>
#include <QFontDatabase>
#include <QGraphicsColorizeEffect>
#include <QGraphicsPixmapItem>
#include <QGraphicsScene>
#include <QInputDialog>
#include <QMenu>
#include <QPainter>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QScroller>
#include <QSystemTrayIcon>

QImage MainWindow::shape_icon(
    const QString &icon, const QColor &color, const qreal &strength, const int &w, const int &h)
{
    // Resize icon and put it into QImage
    QImage src = QIcon(icon).pixmap(QSize(w, h)).toImage();
    if (src.isNull())
        return QImage();

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
    scene.render(&ptr, QRectF(), src.rect());
    return res;
}

void MainWindow::SetActionItems()
{
    actionAddItem = new QAction(getIcon("://icons/outline_add_file_black_24dp.png"),
                                tr("Add Item"),
                                this);
    actionUploadFile = new QAction(getIcon("://icons/outline_file_upload_black_24dp.png"),
                                   tr("Upload file"),
                                   this);
    actionUploadFolder = new QAction(getIcon("://icons/outline_drive_folder_upload_black_24dp.png"),
                                     tr("Upload folder content"),
                                     this);
    actionDownloadFile = new QAction(getIcon("://icons/outline_file_download_black_24dp.png"),
                                     tr("Download file"),
                                     this);
    actionDownloadFolder = new QAction(getIcon(
                                           "://icons/outline_drive_folder_download_black_24dp.png"),
                                       tr("Download folder content"),
                                       this);
    actionAbout = new QAction(getIcon("://icons/outline_info_black_24dp.png"), tr("About"), this);
    actionQuit = new QAction(getIcon("://icons/outline_exit_to_app_black_24dp.png"),
                             tr("Quit"),
                             this);
}

bool MainWindow::is_subpath(const std::filesystem::path &path, const std::filesystem::path &base)
{
    // Get the relative path from base to path
    auto rel = std::filesystem::relative(path, base);

    // Check if the relative path is empty or starts with a dot
    return !rel.empty() && rel.native()[0] != '.';
}

void MainWindow::doAppGeometry()
{
    restoreState(appSettings.settings.value("app/windowState").toByteArray());
    const QByteArray geometry = appSettings.settings.value("app/geometry").toByteArray();
    if (geometry.isEmpty()) {
        const QRect availableGeometry = screen()->availableGeometry();
        resize(availableGeometry.width() / 3, availableGeometry.height() / 2);
        move((availableGeometry.width() - width()) / 2,
             (availableGeometry.height() - height()) / 2);
    } else {
        restoreGeometry(geometry);
    }

    bool isShowTree = appSettings.settings.value("app/isShowTree",true).toBool();
    const QByteArray splitter = appSettings.settings.value("app/splitter").toByteArray();

    if (splitter.isEmpty()) {
        ui->splitter->setSizes(QList<int>({150, 400}));
    } else {
        ui->splitter->restoreState(splitter);
    }

    if (!isShowTree) {
        mainqmltype->toggleFilepan();
    }

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

    QAction *autoTypeTimeout = new QAction(tr("auto type Timeout"), this);
    autoTypeTimeout->setCheckable(true);
    trayIconMenu->addAction(autoTypeTimeout);

    QAction *logoutAction = new QAction(tr("Logout"), this);
    connect(logoutAction, &QAction::triggered, qApp, [=]() {
        AppSettings appSettings{};
        QString rootPath = appSettings.passwordStorePath();
        mainqmltype->setTreeViewSelected(rootPath);

        auto full_path = appSettings.getFindExecutable("gpgconf");

        if (full_path.isEmpty()) {
            qDebug() << "could not found gpgconf";
            return;
        }
        QProcess::startDetached(full_path,
                                QStringList() << "--kill"
                                              << "gpg-agent");
    });
    trayIconMenu->addAction(logoutAction);

    QAction *quitAction = new QAction(tr("&Quit"), this);
    connect(quitAction, &QAction::triggered, qApp, &QCoreApplication::quit);
    trayIconMenu->addAction(quitAction);

    trayIcon->setContextMenu(trayIconMenu);
    trayIcon->setIcon(QIcon(":/icon.png"));
    trayIcon->show();

    QVariantMap variantMap;
    variantMap.insert("color", QColor(10, 10, 10));

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


    // Demonstrating look and feel features
    ui->treeView->setAnimated(false);
    ui->treeView->setIndentation(20);
    ui->treeView->setSortingEnabled(true);
    ui->treeView->header()->setSortIndicator(0, Qt::SortOrder::AscendingOrder);

    // const QSize availableSize = ui->treeView->size(); //ui->treeView->screen()
    //->availableGeometry().size();
    // ui->treeView->resize(availableSize / 2);

    const QByteArray treeviewHeaderState = appSettings.settings.value("app/treeviewHeaderState").toByteArray();
    if (treeviewHeaderState.isEmpty()) {
        ui->treeView->setColumnWidth(0, 200);
        ui->treeView->setColumnWidth(1, 10);
        ui->treeView->setColumnWidth(2, 10);
    } else {
        ui->treeView->header()->restoreState(treeviewHeaderState);
    }


    ui->treeView->setDragEnabled(true);

    ui->treeView->viewport()->setAcceptDrops(true);
    ui->treeView->setDropIndicatorShown(true);
    ui->treeView->setDragDropMode(QAbstractItemView::InternalMove);
    ui->treeView->setAcceptDrops(true);
    ui->treeView->setDefaultDropAction(Qt::MoveAction);
    ui->treeView->setSelectionMode(QTreeView::SelectionMode::ExtendedSelection);

    ui->treeView->setContextMenuPolicy(Qt::CustomContextMenu);
    connect(ui->treeView, &QTreeView::customContextMenuRequested, this, &MainWindow::prepareMenu);

    // Make it flickable on touchscreens
    QScroller::grabGesture(ui->treeView, QScroller::TouchGesture);

    ui->treeView->setWindowTitle(QObject::tr("Dir View"));

    ui->quickWidget->setClearColor(Qt::transparent);
    ui->quickWidget->setAttribute(Qt::WA_AlwaysStackOnTop);

    QQmlContext *context = ui->quickWidget->rootContext();
    mainqmltype = new MainQmlType(ui->splitter,
                                  autoTypeFields,
                                  autoTypeSelected,
                                  autoTypeTimeout,
                                  ui->quickWidget); // NOLINT

    static bool isQuickWidgetFocus = ui->quickWidget->hasFocus();
    connect(mainqmltype, &MainQmlType::mainUiDisable, this, [=]() {
        isQuickWidgetFocus = ui->quickWidget->hasFocus();
        QWidget::setEnabled(false);
    });
    connect(mainqmltype, &MainQmlType::mainUiEnable, this, [=]() {
        QWidget::setEnabled(true);
        if (isQuickWidgetFocus) {
            ui->quickWidget->setFocus();
        } else {
            ui->treeView->setFocus();
        }
    });
    connect(mainqmltype, &MainQmlType::initFileSystemModel, this, [=](QString filePath) {
        initFileSystemModel(filePath);
    });

    connect(mainqmltype,
            &MainQmlType::setTreeviewCurrentIndex,
            this,
            &MainWindow::setTreeviewCurrentIndex);

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
        actionDownloadFolder->setIcon(
            getIcon("://icons/outline_drive_folder_download_black_24dp.png"));
        actionAbout->setIcon(getIcon("://icons/outline_info_black_24dp.png"));
        actionQuit->setIcon(getIcon("://icons/outline_exit_to_app_black_24dp.png"));
    });

    context->setContextProperty(QStringLiteral("mainqmltype"), mainqmltype);

    mainqmltype->setFilePanSize(150);

    setQmlSource();

    doAppGeometry();


    QObject::connect(ui->quickWidget->engine(),
                     &QQmlApplicationEngine::quit,
                     this,
                     &QGuiApplication::quit);

    keyZoomIn = new QShortcut(this);
    //Qt::CTRL + Qt::Key\_P
    keyZoomIn->setKeys({Qt::CTRL | Qt::Key_Plus, Qt::CTRL | Qt::Key_Equal});
    connect(keyZoomIn, &QShortcut::activated, this, [=]() {
        QFont font = QApplication::font();
        font.setPointSize(font.pointSize() + 1);
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
        font.setPointSize(font.pointSize() - 1);
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

QStringList MainWindow::getFilesSelected()
{
    QStringList filesSelected;
    foreach (auto qmodeindex, ui->treeView->selectionModel()->selectedIndexes()) {
        if (qmodeindex.column() == 0) {
            QString str = filesystemModel->fileInfo(qmodeindex).filePath().trimmed();
            if (!str.isEmpty()
                && is_subpath(str.toStdString(),
                              appSettings.passwordStorePath().toStdString())) {
                filesSelected << str;
            }
        }
    }

    return filesSelected;
}

void MainWindow::prepareMenu(const QPoint &pos)
{
    QAction *actNewFolder = new QAction(tr("New folder"), this);
    actNewFolder->setToolTip(tr("Create new folder"));
    QAction *actRename = new QAction(tr("Rename"), this);
    actRename->setToolTip(tr("Rename selected file or folder"));
    QAction *actDelete = new QAction(tr("Delete"), this);
    actDelete->setToolTip(tr("Delete selected files or folders"));

    connect(actRename, &QAction::triggered, this, [=]() {
        bool ok{false};

        std::filesystem::path fullFilePath = mainqmltype->filePath().toStdString();
        std::filesystem::path fullFolderPath = fullFilePath.parent_path();
        std::string fileName = fullFilePath.filename();

        if (!is_subpath(fullFilePath,
                          appSettings.passwordStorePath().toStdString())){
            return;
        }

        QString text = QInputDialog::getText(this,
                                             tr("Rename"),
                                             tr("Rename: %1").arg( QString::fromStdString(fileName)),
                                             QLineEdit::Normal,
                                             QString::fromStdString(fileName),
                                             &ok).trimmed();
        if (ok && !text.isEmpty() && text != QString::fromStdString(fileName)) {
            std::filesystem::path newPath = fullFolderPath / text.toStdString();


            try {
                std::filesystem::rename(fullFilePath, newPath);
                initFileSystemModel(QString::fromStdString(newPath));
            } catch (std::filesystem::filesystem_error &e) {
                qDebug() << "Error moving file: " << e.what() << "\n";
            } catch (...) {
                qDebug() << "mv failed";
            }

        }
    });

    connect(actNewFolder, &QAction::triggered, this, [=]() {
        bool ok{false};
        QString text = QInputDialog::getText(this,
                                             tr("Add Folder"),
                                             tr("New Folder name:"),
                                             QLineEdit::Normal,
                                             "",
                                             &ok);
        if (ok && !text.isEmpty()) {
            std::filesystem::path p = mainqmltype->getFullPathFolder().toStdString();
            p = p / text.toStdString();
            if (!std::filesystem::exists(p)) {
                try {
                    std::filesystem::create_directory(p);
                    initFileSystemModel(QString::fromStdString(p));
                } catch (std::filesystem::filesystem_error &e) {
                    qDebug() << "Error add folder: " << e.what() << "\n";
                } catch (...) {
                    qDebug() << "mkdor failed";
                }
            }
        }
    });

    connect(actDelete, &QAction::triggered, this, [=]() {
        QStringList filesToDelete=getFilesSelected();

        if (filesToDelete.count()==0){
            return;
        }
        QMessageBox::StandardButton reply = QMessageBox::question(this,
                                                                  tr("Delete file or folder"),
                                                                  tr("Delete selected?"),
                                                                  QMessageBox::Yes
                                                                      | QMessageBox::No);
        if (reply == QMessageBox::Yes) {
            try {
                std::filesystem::path parentOfRemovedFile;
                foreach (auto file, filesToDelete) {
                    std::filesystem::path fileToRemove = file.toStdString();
                    std::filesystem::remove_all(fileToRemove);
                    parentOfRemovedFile = fileToRemove.parent_path();
                }

                initFileSystemModel(QString::fromStdString(parentOfRemovedFile));
            } catch (std::filesystem::filesystem_error &e) {
                qDebug() << "Error rm file or folder: " << e.what() << "\n";
            } catch (...) {
                qDebug() << "rm failed";
            }
        }
    });

    QMenu menu(this);
    menu.setToolTipsVisible(true);
    menu.addAction(actNewFolder);
    menu.addAction(actRename);
    menu.addAction(actDelete);

    int filesToDeleteCount = getFilesSelected().count();
    actNewFolder->setVisible(filesToDeleteCount <= 1);
    actRename->setVisible(filesToDeleteCount==1);
    actDelete->setVisible(filesToDeleteCount>=1);


    QPoint pt(pos);
    menu.exec(ui->treeView->mapToGlobal(pos));
}

void MainWindow::closeEvent(QCloseEvent *event)
{
    bool okToClose = true;
    okToClose = okToClose && mainqmltype->waitItems().count() == 0;
    okToClose = okToClose && mainqmltype->noneWaitItems().count() == 0;
    if (!okToClose){
        QMessageBox msgBox;
        msgBox.setText(tr("Close all opened files before quit."));
        msgBox.exec();
        event->ignore();
        return;
    }

    appSettings.settings.setValue("app/geometry", saveGeometry());
    appSettings.settings.setValue("app/windowState", saveState());
    appSettings.settings.setValue("app/treeviewHeaderState", ui->treeView->header()->saveState());

    if (ui->splitter->sizes()[0]==0){
        appSettings.settings.setValue("app/isShowTree",false);
    } else {
        appSettings.settings.setValue("app/isShowTree",true);
        appSettings.settings.setValue("app/splitter", ui->splitter->saveState());
    }
    event->accept();

}

void MainWindow::selectionChangedSlot(const QItemSelection &current /*newSelection*/,
                                      const QItemSelection previous /*oldSelection*/)
{}

void MainWindow::currentChangedSlot(const QModelIndex &current, const QModelIndex &previous)
{
    try {
        treeIndex = current; //ui->treeView->selectionModel()->currentIndex();
        auto idx = treeIndex.model()->index(treeIndex.row(), 0, treeIndex.parent());
        mainqmltype->setFilePath(filesystemModel->filePath(idx));
        treeViewItemSelected = true;
        if (mainqmltype->getNearestGpgId().isEmpty()) {
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
        if (mainqmltype->isGpgFile()) {
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
    filesystemModel = new AppFileSysModel(this);
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
                           &MainWindow::selectionChangedSlot);

    connections << connect(selectionModel,
                           &QItemSelectionModel::currentChanged,
                           this,
                           &MainWindow::currentChangedSlot);

    static bool setDirectoryLoadedOnce = false;
    setDirectoryLoadedOnce = false;
    connections << QObject::connect(filesystemModel,
                                    &QFileSystemModel::directoryLoaded,
                                    [=](const QString &directory) {
                                        if (!setDirectoryLoadedOnce) {
                                            setDirectoryLoadedOnce = true;
                                            setTreeviewCurrentIndex(filePath);
                                        }
                                    });

    connections << QObject::connect(
        filesystemModel, &AppFileSysModel::moveFile, this, [=](QString fromPath, QString destDir) {
            std::filesystem::path destDirPath, destDirFolder = destDir.toStdString(),
                                               fromDirPath = fromPath.toStdString();
            destDirPath = destDirFolder / fromDirPath.filename();

            AppSettings appSettings{};
            bool isValid = !destDir.isEmpty() &&
                            is_subpath(fromPath.toStdString(),
                                          appSettings.passwordStorePath().toStdString())
                           && (is_subpath(destDir.toStdString(),
                                          mainqmltype->getNearestGpgId().toStdString())
                               || destDirFolder
                                      == std::filesystem::path{
                                          mainqmltype->getNearestGit().toStdString()});

            if (!isValid) {
                QMessageBox msgBox;
                msgBox.setText("Move only within same .gpg_id authorization supported.");
                msgBox.exec();
                return;
            }

            if (fromDirPath == destDirPath) {
                return;
            }
            try {
                std::filesystem::rename(fromDirPath, destDirPath);
            } catch (std::filesystem::filesystem_error &e) {
                qDebug() << "Error moving file: " << e.what() << "\n";
            } catch (...) {
                qDebug() << "mv failed";
            }
        });
    connections << QObject::connect(filesystemModel,
                                    &AppFileSysModel::moveFinished,
                                    this,
                                    [=](QString destDirPath) {
                                        if (std::filesystem::exists(destDirPath.toStdString())) {
                                            initFileSystemModel(destDirPath);
                                        }
                                    });
}

void MainWindow::setTreeviewCurrentIndex(QString filePath)
{
    if (!filePath.isEmpty()) {
        const QModelIndex idx = filesystemModel->index(QDir::cleanPath(filePath));
        if (idx.isValid()) {
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
