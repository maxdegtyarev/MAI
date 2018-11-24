#ifndef GRAPHICOBJECT_H
#define GRAPHICOBJECT_H

#include <QGraphicsView>
#include <QMouseEvent>
#include <QDebug>

class graphicObject : public QGraphicsView
{
public:
    explicit graphicObject(QWidget *parent = 0);
protected:
    virtual void mousePressEvent(QMouseEvent *event);
    virtual void mouseMoveEvent(QMouseEvent *event);
    virtual void mouseReleaseEvent(QMouseEvent *event);
};

#endif // GRAPHICOBJECT_H
