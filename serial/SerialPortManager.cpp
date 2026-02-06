#include "SerialPortManager.h"
#include <QDebug>

SerialPortManager::SerialPortManager(QObject *parent)
    : QObject(parent)
    , m_serialPort(new QSerialPort(this))
    , m_isConnected(false)
{
    updateAvailablePorts();

    connect(m_serialPort, &QSerialPort::readyRead, this, &SerialPortManager::onReadyRead);
    connect(m_serialPort, &QSerialPort::errorOccurred, this, &SerialPortManager::onErrorOccurred);
}

SerialPortManager::~SerialPortManager()
{
    if (m_serialPort->isOpen()) {
        m_serialPort->close();
    }
}

QStringList SerialPortManager::availablePorts() const
{
    return m_availablePorts;
}

bool SerialPortManager::isConnected() const
{
    return m_isConnected;
}

QString SerialPortManager::currentPort() const
{
    return m_currentPort;
}

void SerialPortManager::refreshPorts()
{
    updateAvailablePorts();
    emit availablePortsChanged();
}

bool SerialPortManager::openPort(const QString &portName, int baudRate)
{
    if (m_serialPort->isOpen()) {
        m_serialPort->close();
    }

    m_serialPort->setPortName(portName);
    m_serialPort->setBaudRate(baudRate);
    m_serialPort->setDataBits(QSerialPort::Data8);
    m_serialPort->setParity(QSerialPort::NoParity);
    m_serialPort->setStopBits(QSerialPort::OneStop);
    m_serialPort->setFlowControl(QSerialPort::NoFlowControl);

    if (m_serialPort->open(QIODevice::ReadWrite)) {
        m_isConnected = true;
        m_currentPort = portName;
        emit isConnectedChanged();
        emit currentPortChanged();
        return true;
    } else {
        emit errorOccurred(m_serialPort->errorString());
        return false;
    }
}

void SerialPortManager::closePort()
{
    if (m_serialPort->isOpen()) {
        m_serialPort->close();
        m_isConnected = false;
        m_currentPort.clear();
        emit isConnectedChanged();
        emit currentPortChanged();
    }
}

bool SerialPortManager::sendData(const QString &data)
{
    if (!m_serialPort->isOpen()) {
        emit errorOccurred("串口未打开");
        return false;
    }

    QByteArray byteArray = data.toUtf8();
    qint64 bytesWritten = m_serialPort->write(byteArray);
    return bytesWritten != -1;
}

QString SerialPortManager::readData()
{
    QString data = QString::fromUtf8(m_readBuffer);
    m_readBuffer.clear();
    return data;
}

void SerialPortManager::onReadyRead()
{
    QByteArray data = m_serialPort->readAll();
    m_readBuffer.append(data);
    emit dataReceived(QString::fromUtf8(data));
}

void SerialPortManager::onErrorOccurred(QSerialPort::SerialPortError error)
{
    if (error != QSerialPort::NoError) {
        emit errorOccurred(m_serialPort->errorString());
    }
}

void SerialPortManager::updateAvailablePorts()
{
    m_availablePorts.clear();
    const auto ports = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo &port : ports) {
        m_availablePorts.append(port.portName());
    }
}
