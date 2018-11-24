#include "graphicobject.h"

graphicObject::graphicObject(QWidget *parent) : QGraphicsView(parent)
{

}

void graphicObject::mouseReleaseEvent(QMouseEvent *event)
{
qDebug() << "Released";
}
