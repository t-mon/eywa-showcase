#include "engine.h"

#include <QDebug>

Engine::Engine(QObject *parent) : QObject(parent)
{
    m_blocks = new Blocks(this);
    m_blocksProxy = new BlocksProxy(this);

    m_blocksProxy->setBlocks(m_blocks);

    m_dataManager = new DataManager(this);
    connect(m_dataManager, &DataManager::logsRefreshed, this, &Engine::onLogsReady);
    connect(m_dataManager, &DataManager::resultsRefreshed, this, &Engine::onResultsReady);
    connect(m_dataManager, &DataManager::blocksRefreshed, this, &Engine::onBlocksReady);

    m_houshold1 = new Houshold("Haushalt 1", 1, this);
    m_houshold2 = new Houshold("Haushalt 2", 2, this);
    m_houshold3 = new Houshold("Haushalt 3", 3, this);
    m_houshold4 = new Houshold("Haushalt 4", 4, this);
    m_houshold5 = new Houshold("Haushalt 5", 5, this);

    m_housHolds.append(m_houshold1);
    m_housHolds.append(m_houshold2);
    m_housHolds.append(m_houshold3);
    m_housHolds.append(m_houshold4);
    m_housHolds.append(m_houshold5);

    m_timer = new QTimer(this);
    m_timer->setSingleShot(true);
    m_timer->setInterval(m_simulationSpeed);

    connect(m_timer, &QTimer::timeout, this, &Engine::onTick);

    // FIXME
    //m_dataManager->refresh();
}

DataManager *Engine::dataManager()
{
    return m_dataManager;
}

BlocksProxy *Engine::blocksProxy()
{
    return m_blocksProxy;
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

int Engine::iterationCount() const
{
    return m_iterationCount;
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

int Engine::currentIteration() const
{
    return m_currentIteration;
}

void Engine::setCurrentIteration(int iteration)
{
    if (m_currentIteration == iteration)
        return;

    m_currentIteration = iteration;
    qDebug() << "Current iteration changed" << m_currentIteration;
    emit currentIterationChanged(m_currentIteration);
}

Houshold *Engine::getHoushold(int number)
{
    Q_ASSERT(number <= m_housHolds.count());
    //qDebug() << "Get houshold" << number;

    foreach (Houshold *houshold, m_housHolds) {
        if (houshold->number() == number) {
            return houshold;
        }
    }

    return nullptr;
}

DataSeries *Engine::getGridDataSeries(int iterationNumber) const
{
    foreach (DataIteration *iteration, m_gridIterations) {
        if (iteration->iterationNumber() == iterationNumber) {
            return iteration->dataSeries().first();
        }
    }
    return nullptr;
}


void Engine::setTimeSlot(int timeSlot)
{
    m_timeSlot = timeSlot;
    emit timeSlotChanged();

    // Calculate progress
    setProgress(m_timeSlot * 100.0 / m_maxTimeSlots - 1);
}

void Engine::setProgress(double progress)
{
    m_progress = progress;
    emit progressChanged();
}

DataSeries *Engine::findDataSeries(const QString &name, const QList<DataSeries *> &seriesList)
{
    foreach (DataSeries *series, seriesList) {
        if (series->name() == name) {
            return series;
        }
    }

    return nullptr;
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

    qDebug() << "Tick:" << m_timeSlot << "/" << m_maxTimeSlots - 1 << "-->" << m_progress << "%";
    foreach (Houshold *houshold, m_housHolds) {
        houshold->setTimeSlot(m_timeSlot);
    }

    foreach (DataIteration *iteration, m_gridIterations) {
        for (int column = 0; column < iteration->dataSeries().count(); column++) {

            Q_ASSERT(column < iteration->dataSeries().count());

            DataSeries *series = iteration->dataSeries().at(column);
            series->setCurrentValue(m_timeSlot);
        }
    }

    emit tick(m_timeSlot);

    if (m_running) {
        m_timer->start(m_simulationSpeed);
    }

    int timeSlot = m_timeSlot + 1;
    setTimeSlot(timeSlot);
}

void Engine::onLogsReady(const QVariantList &logsList)
{
    // Clear houshold logs
    foreach (Houshold *houshold, m_housHolds) {
        houshold->logEntries()->clearModel();
    }

    foreach (const QVariant &logVariant, logsList) {
        QVariantMap logMap = logVariant.toMap();

        // Parse houshold, add them and sort them by timestamp
        LogEntry *logEntry = new LogEntry();
        logEntry->setMessage(logMap.value("msg").toString());
        logEntry->setMessageType(logMap.value("t").toString());
        logEntry->setTimeStamp(logMap.value("tstp").toInt());

        int housholdNumber = logMap.value("client").toString().remove("HH").toInt();

        Houshold *housHold = getHoushold(housholdNumber);

        if (!housHold) {
            qWarning() << "Could not find houshold for log" << logMap;
            continue;
        }

        housHold->logEntries()->addLogEntry(logEntry);
    }
}

void Engine::onResultsReady(const QVariantList &resultsList)
{
    foreach (Houshold *houshold, m_housHolds) {
        houshold->reset();
    }

    qDeleteAll(m_gridIterations);
    m_gridIterations.clear();

    stop();

    m_iterationCount = 0;
    foreach (const QVariant &resultVariant, resultsList) {
        QVariantMap resultMap = resultVariant.toMap();

        int housHoldNumber = resultMap.value("client").toString().remove("HH").toInt();
        int iterationNumber = resultMap.value("iteration").toInt();

        if (iterationNumber == 0)
            continue;

        qDebug() << "-----------------------------------------";
        DataIteration *iteration = new DataIteration(iterationNumber, this);


        qDebug() << "Parsing data for houshold" << housHoldNumber << "iteration:" << iterationNumber;
        QVariantMap valuesMap = resultMap.value("values").toMap();

        QList<DataSeries *> dataSeriesList;

        foreach (const QString &value, valuesMap.keys()) {
            DataSeries *dataSeries = new DataSeries(iteration);
            dataSeries->setName(value);

            QVariantList valueList = valuesMap.value(value).toList();

            QList<double> values;
            for (int i = 0; i < valueList.count(); i++) {
                values.append(valueList.value(i).toDouble());
            }

            if (housHoldNumber == 2)
                qDebug() << "    -> " << dataSeries->name() << values;

            dataSeries->setValues(values);
            dataSeriesList.append(dataSeries);
        }

        // Create custom series
        DataSeries *energyPriceSeries = findDataSeries("Energiepreis [€/kWh]", dataSeriesList);
        DataSeries *networkPriceSeries = findDataSeries("Netzpreis [€/kWh]", dataSeriesList);

        // Energy price sum
        if (energyPriceSeries && networkPriceSeries) {
            DataSeries *priceSeries = new DataSeries(iteration);
            priceSeries->setName("Bezugspreis Brutto [€/kWh]");
            QList<double> newValues;
            for (int i = 0; i < energyPriceSeries->values().count(); i++) {
                newValues.append(energyPriceSeries->values().at(i) + networkPriceSeries->values().at(i));
            }
            priceSeries->setValues(newValues);
            dataSeriesList.append(priceSeries);

        } else {
            qWarning() << "Could not find Energiepreis [€/kWh] or Netzpreis [€/kWh] series";
        }


        DataSeries *housholdSeries = findDataSeries("Nicht steuerbar [kW]", dataSeriesList);
        DataSeries *ecarSeries = findDataSeries("Verbrauch E-Auto [kW]", dataSeriesList);
        DataSeries *batterySeries = findDataSeries("Verbrauch Batterie [kW]", dataSeriesList);
        DataSeries *heatpumpSeries = findDataSeries("Verbrauch WP [kW]", dataSeriesList);

        // Energy custom series
        if (ecarSeries && housholdSeries && batterySeries && heatpumpSeries) {

            // Ecar + battery
            DataSeries *housholdEcarSumSeries = new DataSeries(iteration);
            housholdEcarSumSeries->setName("houshold + ecar");

            QList<double> newValues;
            for (int i = 0; i < housholdSeries->values().count(); i++) {
                newValues.append(housholdSeries->values().at(i) + ecarSeries->values().at(i));
            }
            housholdEcarSumSeries->setValues(newValues);
            dataSeriesList.append(housholdEcarSumSeries);

            // houshold + Ecar + battery
            DataSeries *housholdEcarBatterySumSeries = new DataSeries(iteration);
            housholdEcarBatterySumSeries->setName("houshold + ecar + battery");

            QList<double> newValuesFinal;
            for (int i = 0; i < housholdEcarSumSeries->values().count(); i++) {
                newValuesFinal.append(housholdEcarSumSeries->values().at(i) + batterySeries->values().at(i));
            }
            housholdEcarBatterySumSeries->setValues(newValuesFinal);
            dataSeriesList.append(housholdEcarBatterySumSeries);

            // houshold + Ecar + battery + heatpump
            DataSeries *housholdEcarBatteryHeatpumpSumSeries = new DataSeries(iteration);
            housholdEcarBatteryHeatpumpSumSeries->setName("houshold + ecar + battery + heatpump");

            QList<double> newValuesOthers;
            for (int i = 0; i < housholdEcarBatterySumSeries->values().count(); i++) {
                newValuesOthers.append(housholdEcarBatterySumSeries->values().at(i) + heatpumpSeries->values().at(i));
            }
            housholdEcarBatteryHeatpumpSumSeries->setValues(newValuesOthers);
            dataSeriesList.append(housholdEcarBatteryHeatpumpSumSeries);


        } else {
            qWarning() << "Could not find create custom series for enery consumption";
        }        

        iteration->setDataSeries(dataSeriesList);

        Houshold *houshold = getHoushold(housHoldNumber);
        houshold->addIteration(iteration);
    }

    int iterationCount = 0;

    foreach (Houshold *houshold, m_housHolds) {
        if (houshold->iterationCount() >= iterationCount) {
            iterationCount = houshold->iterationCount();
        }
    }

    m_iterationCount = iterationCount;
    qDebug() << "Interation count changed" << m_iterationCount;
    emit iterationCountChanged(m_iterationCount);

    // Create grid data for each iteration
    for (int i = 0; i < m_iterationCount; i++) {
        int iterationNumber = i + 1;
        DataIteration *iteration = new DataIteration(iterationNumber, this);
        int dataCount = m_houshold1->getDataSeries(iterationNumber, "Gesamtverbrauch [kW]")->values().count();
        DataSeries *gridDataSeries = new DataSeries(iteration);
        for (int x = 0; x < dataCount; x++) {
            int sum = 0;
            foreach (Houshold *houshold, m_housHolds) {
                DataSeries *totalConsumptionHousholdSeries = houshold->getDataSeries(iterationNumber, "Gesamtverbrauch [kW]");
                sum += totalConsumptionHousholdSeries->getValue(x);
            }
            gridDataSeries->appendValue(sum);
        }
        iteration->setDataSeries( {gridDataSeries} );
        m_gridIterations.append(iteration);
    }
}

void Engine::onBlocksReady(const QVariantList &blocksList)
{
    m_blocks->clearModel();

    foreach (const QVariant &blockVariant, blocksList) {
        QVariantMap blockMap = blockVariant.toMap();

        Block *block = new Block(m_blocks);
        block->setMessage(blockMap.value("msg").toString());
        block->setClient(blockMap.value("client").toString());
        block->setNumber(blockMap.value("num").toInt());
        block->setHash(blockMap.value("hash").toString());
        block->setTimeStamp(blockMap.value("tstp").toInt());

        qDebug() << "####### add block" << block->number() << block->message();

        m_blocks->addBlock(block);
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
