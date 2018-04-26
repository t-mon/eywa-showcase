#ifndef ENGINE_H
#define ENGINE_H

#include <QObject>
#include <QTimer>

#include "houshold.h"

class Engine : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool running READ running NOTIFY runningChanged)
    Q_PROPERTY(int timeSlot READ timeSlot NOTIFY timeSlotChanged)
    Q_PROPERTY(double progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(int simulationSpeed READ simulationSpeed WRITE setSimulationSpeed NOTIFY simulationSpeedChanged)

public:
    explicit Engine(QObject *parent = nullptr);

    bool running();
    int timeSlot() const;
    double progress() const;

    int simulationSpeed() const;
    void setSimulationSpeed(int simulationSpeed);

    Q_INVOKABLE Houshold *getHoushold(int number);

private:
    QTimer *m_timer = nullptr;

    Houshold *m_housholdOne = nullptr;
    Houshold *m_housholdTwo = nullptr;
    QList<Houshold *> m_housHolds;

    bool m_running = false;
    int m_timeSlot = 0;
    int m_simulationSpeed = 500;
    int m_maxTimeSlots = 96;
    double m_progress = 0;

    void setRunning(bool running);
    void setTimeSlot(int timeSlot);
    void setProgress(double progress);

signals:
    void runningChanged();
    void timeSlotChanged();
    void progressChanged();
    void simulationSpeedChanged();

    void tick(int timeSlot);
    void reset();

private slots:
    void onTick();

public slots:
    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();

};

#endif // ENGINE_H
