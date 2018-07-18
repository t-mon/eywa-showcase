#ifndef ENGINE_H
#define ENGINE_H

#include <QObject>
#include <QTimer>

#include "datamanager.h"
#include "houshold.h"

class Engine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(DataManager *dataManager READ dataManager CONSTANT)
    Q_PROPERTY(int timeSlot READ timeSlot NOTIFY timeSlotChanged)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(int simulationSpeed READ simulationSpeed WRITE setSimulationSpeed NOTIFY simulationSpeedChanged)
    Q_PROPERTY(int iterationCount READ iterationCount NOTIFY iterationCountChanged)
    Q_PROPERTY(int currentIteration READ currentIteration WRITE setCurrentIteration NOTIFY currentIterationChanged)

public:
    explicit Engine(QObject *parent = nullptr);

    DataManager *dataManager();

    bool running();
    int timeSlot() const;
    double progress() const;

    int iterationCount() const;

    int simulationSpeed() const;
    void setSimulationSpeed(int simulationSpeed);

    int currentIteration() const;
    void setCurrentIteration(int iteration);

    Q_INVOKABLE Houshold *getHoushold(int number);

private:
    QTimer *m_timer = nullptr;

    DataManager *m_dataManager = nullptr;

    Houshold *m_houshold1 = nullptr;
    Houshold *m_houshold2 = nullptr;
    Houshold *m_houshold3 = nullptr;
    Houshold *m_houshold4 = nullptr;
    Houshold *m_houshold5 = nullptr;

    QList<Houshold *> m_housHolds;

    bool m_running = false;
    int m_timeSlot = 0;
    int m_simulationSpeed = 500;
    int m_maxTimeSlots = 24;
    double m_progress = 0;
    int m_iterationCount = 0;
    int m_currentIteration = 1;

    void setRunning(bool running);
    void setTimeSlot(int timeSlot);
    void setProgress(double progress);

    DataSeries *findDataSeries(const QString &name, const QList<DataSeries *> &seriesList);

signals:
    void runningChanged();
    void timeSlotChanged();
    void progressChanged();
    void simulationSpeedChanged();
    void iterationCountChanged(int iterationCount);
    void currentIterationChanged(int iteration);

    void tick(int timeSlot);
    void reset();

private slots:
    void onTick();

    void onLogsReady(const QVariantList &logsList);
    void onResultsReady(const QVariantList &resultsList);

public slots:
    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();

};

#endif // ENGINE_H
