#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

#include <QDir>
#include <QString>
#include <QMessageBox>
#include <QTextStream>
#include <QDebug>
#include <QVector>

#include "qcustomplot.h"


struct Point
{
public:
    double x,y;

    void add(const double value)
    {
        if (!addedNum)
        {
            x = value;
            addedNum = true;
        }
        else
            y = value;
    }
private:
    bool addedNum = false;
};

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    void loadFromFile(const QString&);
    void addGraphs(const QVector<QVector<Point>>&);
    ~MainWindow();


private slots:
    void on_scalePlus_clicked();
    void on_scaleMinus_clicked();
    void update();
    bool eventFilter(QObject *target, QEvent *event);

    void on_pushButton_clicked();

    void on_actionAbout_triggered();

private:

    Ui::MainWindow *ui;

    double currentScaleX = 1,
           currentScaleY = 1,
            ox = 0,
            oy = 0;

};

#endif // MAINWINDOW_H
