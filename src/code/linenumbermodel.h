// Copyright (C) 2023 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

#pragma once

#include <QAbstractItemModel>
#include <QQmlEngine>

class LineNumberModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    
    Q_PROPERTY(int lineCount READ lineCount WRITE setLineCount NOTIFY lineCountChanged)

public:
    explicit LineNumberModel(QObject *parent = nullptr);

    int lineCount() const;
    void setLineCount(int lineCount);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

Q_SIGNALS:
    void lineCountChanged();

private:
    int m_lineCount = 0;
};

