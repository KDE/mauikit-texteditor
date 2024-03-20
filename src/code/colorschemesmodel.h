#pragma once
#include <QObject>
#include <QAbstractListModel>
#include <QQmlParserStatus>

#if defined Q_OS_MACOS || defined Q_OS_WIN32
#include <KF5/KSyntaxHighlighting/Repository>
#include <KF5/KSyntaxHighlighting/Theme>
#else
#include <KSyntaxHighlighting/Repository>
#include <KSyntaxHighlighting/Theme>
#endif

class ColorSchemesModel : public QAbstractListModel, public QQmlParserStatus
{
    Q_INTERFACES(QQmlParserStatus)
    Q_OBJECT
public:

    enum Role
    {
        Name,
        Foreground,
        Background,
        Highlight,
        Color3,
        Color4,
        Color5
    };


    ColorSchemesModel(QObject * parent = nullptr);

    // QQmlParserStatus interface
public:
    void classBegin() override final;
    void componentComplete() override final;

private:
    QVector<KSyntaxHighlighting::Theme>  m_list;
    void setList();

    // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override final;
    QVariant data(const QModelIndex &index, int role) const override final;
    QHash<int, QByteArray> roleNames() const override final;
};

