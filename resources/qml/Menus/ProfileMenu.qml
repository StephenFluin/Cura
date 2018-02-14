// Copyright (c) 2016 Ultimaker B.V.
// Cura is released under the terms of the LGPLv3 or higher.

import QtQuick 2.8
import QtQuick.Controls 1.4

import UM 1.2 as UM
import Cura 1.0 as Cura

Menu
{
    id: menu

    Instantiator
    {
        model: Cura.NewQualityProfilesModel

        MenuItem
        {
            text: (model.layer_height != "") ? model.name + " - " + model.layer_height : model.name
            checkable: true
            checked: Cura.MachineManager.activeQualityGroup && (Cura.MachineManager.activeQualityGroup.getName() == model.name)
            exclusiveGroup: group
            onTriggered: {
                Cura.MachineManager.setQualityGroup(model.quality_group)
            }
            visible: model.available
        }

        onObjectAdded: menu.insertItem(index, object);
        onObjectRemoved: menu.removeItem(object);
    }

    MenuSeparator
    {
        id: customSeparator
        visible: Cura.UserProfilesModel.rowCount > 0
    }

    Instantiator
    {
        id: customProfileInstantiator
        model: Cura.NewCustomQualityProfilesModel

        Connections
        {
            target: Cura.NewCustomQualityProfilesModel
            onModelReset: customSeparator.visible = Cura.NewCustomQualityProfilesModel.rowCount() > 0
        }

        MenuItem
        {
            text: model.name
            checkable: model.available
            checked: Cura.MachineManager.activeQualityChangesId == model.id  // TODO: fix for new
            exclusiveGroup: group
            onTriggered: Cura.MachineManager.setActiveQuality(model.id) // TODO: fix for new
        }

        onObjectAdded:
        {
            customSeparator.visible = model.rowCount() > 0;
            menu.insertItem(index, object);
        }
        onObjectRemoved:
        {
            customSeparator.visible = model.rowCount() > 0;
            menu.removeItem(object);
        }
    }

    ExclusiveGroup { id: group; }

    MenuSeparator { id: profileMenuSeparator }

    MenuItem { action: Cura.Actions.addProfile }
    MenuItem { action: Cura.Actions.updateProfile }
    MenuItem { action: Cura.Actions.resetProfile }
    MenuSeparator { }
    MenuItem { action: Cura.Actions.manageProfiles }
}
