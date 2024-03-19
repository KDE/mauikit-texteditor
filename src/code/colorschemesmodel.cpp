#include "colorschemesmodel.h"

#include <QDebug>

ColorSchemesModel::ColorSchemesModel(QObject *parent) : QAbstractListModel(parent)
{

}

void ColorSchemesModel::classBegin()
{
}

void ColorSchemesModel::componentComplete()
{
    this->setList();
}

void ColorSchemesModel::setList()
{
    m_list.clear();

    beginResetModel();

    
       auto repository = new KSyntaxHighlighting::Repository();
    
    m_list = repository->themes();

    endResetModel();
}


int ColorSchemesModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
      {
          return 0;
      }

      return m_list.count();
}

QVariant ColorSchemesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
         return QVariant();

     KSyntaxHighlighting::Theme item = m_list[index.row()];

     switch(role)
     {
     case Role::Name: return item.name();
     case Role::Background: return QColor(item.backgroundColor(KSyntaxHighlighting::Theme::Normal));
     case Role::Foreground: return QColor(item.textColor(KSyntaxHighlighting::Theme::Keyword));
     case Role::Highlight: return QColor(item.selectedBackgroundColor(KSyntaxHighlighting::Theme::Keyword));
     case Role::Color3: return QColor(item.textColor(KSyntaxHighlighting::Theme::Variable));
     case Role::Color4: return QColor(item.textColor(KSyntaxHighlighting::Theme::Function));
     case Role::Color5: return QColor(item.textColor(KSyntaxHighlighting::Theme::Normal));
     default: return QVariant();
     }
}

QHash<int, QByteArray> ColorSchemesModel::roleNames() const
{
    return {{Role::Name, "name"},
        {Role::Background, "background"},
        {Role::Foreground, "foreground"},
        {Role::Highlight, "highlight"},
        {Role::Color3, "color3"},
        {Role::Color4, "color4"},
        {Role::Color5, "color5"}};
}
