#include "UiGuard.h"

UiGuard::UiGuard(QWidget *ui)
    : widget(ui)
{
    widget->grabMouse();
    widget->grabKeyboard();
    widget->installEventFilter(this);
}

UiGuard::~UiGuard()
{
    widget->releaseKeyboard();
    widget->releaseMouse();
}

bool UiGuard::eventFilter(QObject *, QEvent *event)
{
    return dynamic_cast<QInputEvent *>(event); // Eat up the input events
}
