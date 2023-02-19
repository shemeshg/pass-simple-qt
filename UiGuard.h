#pragma once
#include <QInputEvent>
#include <QWidget>

class UiGuard : public QObject
{
public:
    UiGuard(QWidget *ui);
    ~UiGuard() override;
    bool eventFilter(QObject *, QEvent *event) override;

private:
    QWidget *widget;
};
