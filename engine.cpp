#include "engine.h"

#include <QDebug>

Engine::Engine(QObject *parent) : QObject(parent)
{
    m_housholdOne = new Houshold("Haushalt 1", this);
    m_housholdOne->loadFile(":/data/houshold-1.csv");

    m_housholdTwo = new Houshold("Haushalt 2", this);
    m_housholdTwo->loadFile(":/data/houshold-2.csv");

    m_housHolds.append(m_housholdOne);
    m_housHolds.append(m_housholdTwo);

    m_timer = new QTimer(this);
    m_timer->setSingleShot(true);
    m_timer->setInterval(m_simulationSpeed);

    connect(m_timer, &QTimer::timeout, this, &Engine::onTick);
}

bool Engine::running()
{
    return m_running;
}

int Engine::timeSlot() const
{
    return m_timeSlot;
}

double Engine::progress() const
{
    return m_progress;
}

int Engine::simulationSpeed() const
{
    return m_simulationSpeed;
}

void Engine::setSimulationSpeed(int simulationSpeed)
{
    m_simulationSpeed = simulationSpeed;



    emit simulationSpeedChanged();
}

Houshold *Engine::getHoushold(int number)
{
    Q_ASSERT(number < m_housHolds.count());
    qDebug() << "Get houshold" << number;

    return m_housHolds.at(number);
}

void Engine::setTimeSlot(int timeSlot)
{
    m_timeSlot = timeSlot;
    emit timeSlotChanged();

    // Calculate progress
    setProgress(m_timeSlot * 100.0 / m_maxTimeSlots);
}

void Engine::setProgress(double progress)
{
    m_progress = progress;
    emit progressChanged();
}

void Engine::setRunning(bool running)
{
    m_running = running;
    emit runningChanged();
}

void Engine::onTick()
{
    if (m_timeSlot >= m_maxTimeSlots) {
        qDebug() << "Simulation finished";
        m_timer->stop();
        setRunning(false);
        return;
    }

    int timeSlot = m_timeSlot + 1;
    setTimeSlot(timeSlot);

    qDebug() << "Tick:" << m_timeSlot << "/" << m_maxTimeSlots << "-->" << m_progress << "%";
    foreach (Houshold *houshold, m_housHolds) {
        houshold->setTimeSlot(m_timeSlot);
    }

    emit tick(m_timeSlot);

    if (m_running) {
        m_timer->start(m_simulationSpeed);
    }
}

void Engine::play()
{
    m_timer->start();
    setRunning(true);
}

void Engine::pause()
{
    m_timer->stop();
    setRunning(false);
}

void Engine::stop()
{
    m_timer->stop();
    setRunning(false);
    setTimeSlot(0);
    emit reset();
}
