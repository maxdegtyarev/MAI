#include "mainwindow.h"
#include "ui_mainwindow.h"

#include "qcustomplot.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);

    ui->widget->xAxis->setAutoTickStep(true);
    ui->widget->yAxis->setAutoTickStep(true);

    ui->widget->rescaleAxes(true);
    ui->widget->installEventFilter(this);

    ui->widget->xAxis->setLabel("X");
    ui->widget->yAxis->setLabel("Y");

}

MainWindow::~MainWindow()
{
    delete ui;
}

bool MainWindow::eventFilter(QObject *target, QEvent *event)
{
    if(target == ui->widget && event->type() == QEvent::MouseMove)
    {
        QMouseEvent *mouseEvent = static_cast<QMouseEvent*>(event);
    }
    return false;
}

void MainWindow::loadFromFile(const QString & filename)
{
    QFile fin(filename);
    int lineSize;

    QVector<QVector<Point>> points;

    if (!fin.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        QMessageBox::critical(this, "Ошибка", "Не получается открыть файл", "OK");
        return;
    }

    QTextStream InputStream(&fin);

    while(!InputStream.atEnd())
    {
        QString line = InputStream.readLine();
        QStringList list = line.split("   ", QString::SkipEmptyParts);

        switch (list.size()) {
        case 1:
        {
            foreach (QString temporary, list) {
                lineSize = temporary.toInt();
            }
            points.resize(points.size() + 1);
            break;
        }
        case 2:
        {
            if (lineSize-- > 0)
            {
                Point point;

                foreach (QString temporary, list) {
                    point.add(temporary.toDouble());
                }

                points[points.size()-1].append(point);
            }
            break;
        }
        default:
            break;
        }
    }

    fin.close();

    addGraphs(points);
}

void MainWindow::addGraphs(const QVector<QVector<Point>>& points)
{
    int graphs = 0;

    for (int i = 0; i < points.size(); i++)
    {
        ui->widget->addGraph();

        QVector<double> x;
        QVector<double> y;

        for (int j = 0; j < points[i].size(); j++)
        {
            x.append(points[i][j].x);
            y.append(points[i][j].y);
        }

        ui->widget->graph(graphs)->setPen(QColor(255, 50, 50, 255));//задаем цвет точки
        ui->widget->graph(graphs)->setLineStyle(QCPGraph::lsLine);
        ui->widget->graph(graphs)->setScatterStyle(QCPScatterStyle(QCPScatterStyle::ssCircle, 4));

        ui->widget->graph(graphs++)->setData(x,y);
    }

    ui->widget->replot();
}

void MainWindow::on_scalePlus_clicked()
{
    currentScaleX += 0.1;
    currentScaleY += 0.1;
    update();
}

void MainWindow::on_scaleMinus_clicked()
{
    currentScaleX -= 0.1;
    currentScaleY -= 0.1;
    update();
}

void MainWindow::update()
{
    ui->widget->xAxis->scaleRange(currentScaleX,0);
    ui->widget->yAxis->scaleRange(currentScaleY,0);
    ui->widget->replot();
}

void MainWindow::on_pushButton_clicked()
{
    ui->widget->clearGraphs();

    QString filename = QFileDialog::getOpenFileName(this, tr("Open file with data"), "", tr("Text Files (*.txt)"));

    loadFromFile(filename);
}

void MainWindow::on_actionAbout_triggered()
{
    QMessageBox::about(this, "Author", "Maxim Degtyarev\n80-212б-17б");
}
