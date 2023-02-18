#pragma once
#include <QInputEvent>
#include <QWidget>

class UiGuard : public QObject
{
public:
    UiGuard(QWidget *ui)
        : widget(ui)
    {
        widget->grabMouse();
        widget->grabKeyboard();
        widget->installEventFilter(this);
    }

    ~UiGuard() override
    {
        widget->releaseKeyboard();
        widget->releaseMouse();
    }

    bool eventFilter(QObject *, QEvent *event) override
    {
        return dynamic_cast<QInputEvent *>(event); // Eat up the input events
    }

private:
    QWidget *widget;
};
