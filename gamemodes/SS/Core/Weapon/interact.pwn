public OnPlayerGetItem(playerid, itemid)
{
	UpdatePlayerWeaponItem(playerid);

	#if defined itmw_OnPlayerGetItem
		return itmw_OnPlayerGetItem(playerid, itemid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerGetItem
	#undef OnPlayerGetItem
#else
	#define _ALS_OnPlayerGetItem
#endif
 
#define OnPlayerGetItem itmw_OnPlayerGetItem
#if defined itmw_OnPlayerGetItem
	forward itmw_OnPlayerGetItem(playerid, itemid);
#endif

public OnPlayerGivenItem(playerid, targetid, itemid)
{
	if(GetItemTypeWeapon(GetItemType(itemid)) != -1)
	{
		RemovePlayerWeapon(playerid);
		UpdatePlayerWeaponItem(targetid);
	}

	#if defined itmw_OnPlayerGivenItem
		return itmw_OnPlayerGivenItem(playerid, targetid, itemid);
	#else
		return 0;
	#endif
}
#if defined _ALS_OnPlayerGivenItem
	#undef OnPlayerGivenItem
#else
	#define _ALS_OnPlayerGivenItem
#endif
#define OnPlayerGivenItem itmw_OnPlayerGivenItem
#if defined itmw_OnPlayerGivenItem
	forward itmw_OnPlayerGivenItem(playerid, targetid, itemid);
#endif

public OnPlayerDroppedItem(playerid, itemid)
{
	if(GetItemTypeWeapon(GetItemType(itemid)) != -1)
	{
		RemovePlayerWeapon(playerid);
	}

	#if defined itmw_OnPlayerDroppedItem
		return itmw_OnPlayerDroppedItem(playerid, itemid);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerDroppedItem
	#undef OnPlayerDroppedItem
#else
	#define _ALS_OnPlayerDroppedItem
#endif
 
#define OnPlayerDroppedItem itmw_OnPlayerDroppedItem
#if defined itmw_OnPlayerDroppedItem
	forward itmw_OnPlayerDroppedItem(playerid, itemid);
#endif

public OnPlayerUseItemWithItem(playerid, itemid, withitemid)
{
	if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED || IsPlayerOnAdminDuty(playerid) || IsPlayerKnockedOut(playerid) || GetPlayerAnimationIndex(playerid) == 1381)
		return 1;

	_PickUpAmmoTransferCheck(playerid, itemid, withitemid);

	#if defined itmw_OnPlayerUseItemWithItem
		return itmw_OnPlayerUseItemWithItem(playerid, itemid, withitemid);
	#else
		return 0;
	#endif
}
#if defined _ALS_OnPlayerUseItemWithItem
	#undef OnPlayerUseItemWithItem
#else
	#define _ALS_OnPlayerUseItemWithItem
#endif
#define OnPlayerUseItemWithItem itmw_OnPlayerUseItemWithItem
#if defined itmw_OnPlayerUseItemWithItem
	forward itmw_OnPlayerUseItemWithItem(playerid, itemid, withitemid);
#endif

_PickUpAmmoTransferCheck(playerid, helditemid, ammoitemid)
{
	new
		ItemType:helditemtype,
		ItemType:ammoitemtype,
		heldtypeid;

	// Item being held and used with world item
	helditemtype = GetItemType(helditemid);
	// Item in the world
	ammoitemtype = GetItemType(ammoitemid);
	// Weapon type of held item
	heldtypeid = GetItemTypeWeapon(helditemtype);

	if(heldtypeid != -1) // Player is holding a weapon
	{
		new ammotypeid = GetItemTypeWeapon(ammoitemtype);

		if(ammotypeid != -1) // Transfer ammo from weapon to held weapon
		{
			new heldcalibre = GetItemWeaponCalibre(heldtypeid);

			if(heldcalibre == NO_CALIBRE)
				return 1;

			if(heldcalibre != GetItemWeaponCalibre(ammotypeid))
			{
				ShowActionText(playerid, "Wrong calibre for weapon", 3000);
				return 1;
			}

			new ItemType:loadedammoitemtype = GetItemWeaponItemAmmoItem(helditemid);

			if(GetItemTypeAmmoType(loadedammoitemtype) != -1)
			{
				if(loadedammoitemtype != GetItemWeaponItemAmmoItem(ammoitemid))
				{
					ShowActionText(playerid, "A different ammunition type is already loaded in this weapon", 5000);
					return 1;
				}
			}

			ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_IN", 5.0, 1, 0, 0, 0, 450);
			defer _TransferWeaponToWeapon(playerid, ammoitemid, helditemid);

			return 1;
		}

		ammotypeid = GetItemTypeAmmoType(ammoitemtype);

		if(ammotypeid != -1) // Transfer ammo from ammo item to held weapon
		{
			new heldcalibre = GetItemWeaponCalibre(heldtypeid);

			if(heldcalibre == NO_CALIBRE)
				return 1;

			if(heldcalibre != GetAmmoTypeCalibre(ammotypeid))
			{
				ShowActionText(playerid, "Wrong calibre for weapon", 3000);
				return 1;
			}

			new ItemType:loadedammoitemtype = GetItemWeaponItemAmmoItem(helditemid);

			if(GetItemTypeAmmoType(loadedammoitemtype) != -1)
			{
				if(loadedammoitemtype != ammoitemtype)
				{
					ShowActionText(playerid, "A different ammunition type is already loaded in this weapon", 5000);
					return 1;
				}
			}

			ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_IN", 5.0, 1, 0, 0, 0, 450);
			defer _TransferTinToWeapon(playerid, ammoitemid, helditemid);

			return 1;
		}
	}

	heldtypeid = GetItemTypeAmmoType(helditemtype);

	if(heldtypeid != -1) // Player is holding an ammo item
	{
		new ammotypeid = GetItemTypeWeapon(ammoitemtype);

		if(ammotypeid != -1) // Transfer ammo from weapon to held ammo item
		{
			new heldcalibre = GetAmmoTypeCalibre(heldtypeid);

			if(heldcalibre == NO_CALIBRE)
				return 1;

			if(heldcalibre != GetItemWeaponCalibre(ammotypeid))
			{
				ShowActionText(playerid, "Wrong calibre in weapon", 3000);
				return 1;
			}

			new ItemType:loadedammoitemtype = GetItemWeaponItemAmmoItem(ammoitemid);

			if(GetItemTypeAmmoType(loadedammoitemtype) != -1)
			{
				if(loadedammoitemtype != helditemtype)
				{
					ShowActionText(playerid, "A different ammunition type is already loaded in this weapon", 5000);
					return 1;
				}
			}

			ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_IN", 5.0, 1, 0, 0, 0, 450);
			defer _TransferWeaponToTin(playerid, ammoitemid, helditemid);

			return 1;
		}

		ammotypeid = GetItemTypeAmmoType(ammoitemtype);

		if(ammotypeid != -1) // Transfer ammo from ammo item to held ammo item
		{
			/*if(GetItemExtraData(helditemid) == 0)
			{
				new heldcalibre = GetAmmoTypeCalibre(heldtypeid);

				if(heldcalibre == NO_CALIBRE)
					return 1;

				if(heldcalibre != GetAmmoTypeCalibre(ammotypeid))
				{
					ShowActionText(playerid, "Wrong calibre in ammo tin", 3000);
					return 1;
				}
			}*/

			if(ammoitemtype != helditemtype)
			{
				ShowActionText(playerid, "Ammo types can't be mixed in tins", 5000);
				return 1;
			}

			ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_IN", 5.0, 1, 0, 0, 0, 450);
			defer _TransferTinToTin(playerid, ammoitemid, helditemid);

			return 1;
		}
	}

	return 1;
}


// Transfer ammo from weapon to held weapon
timer _TransferWeaponToWeapon[400](playerid, srcitem, tgtitem)
{
	new
		magammo,
		reserveammo,
		remainder;

	magammo = GetItemWeaponItemMagAmmo(srcitem);
	reserveammo = GetItemWeaponItemReserve(srcitem);

	if(reserveammo + magammo > 0)
	{
		SetItemWeaponItemAmmoItem(tgtitem, GetItemWeaponItemAmmoItem(srcitem));
		remainder = GivePlayerAmmo(playerid, reserveammo + magammo);

		SetItemWeaponItemMagAmmo(srcitem, 0);
		SetItemWeaponItemReserve(srcitem, remainder);

		ShowActionText(playerid, sprintf("Transferred %d rounds from weapon to weapon", (reserveammo + magammo) - remainder), 3000);
	}

	ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_2IDLE", 4.0, 0, 0, 0, 0, 0);
}

// Transfer ammo from ammo item to held weapon
// Damn y_timers and it's length restrictions!
timer _TransferTinToWeapon[400](playerid, srcitem, tgtitem)
{
	new
		ammo,
		remainder;

	ammo = GetItemExtraData(srcitem);

	if(ammo > 0)
	{
		SetItemWeaponItemAmmoItem(tgtitem, GetItemType(srcitem));
		remainder = GivePlayerAmmo(playerid, ammo);

		SetItemExtraData(srcitem, remainder);

		ShowActionText(playerid, sprintf("Transferred %d rounds from ammo tin to weapon", ammo - remainder), 3000);
	}

	ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_2IDLE", 4.0, 0, 0, 0, 0, 0);
}

// Transfer ammo from weapon to held ammo item
timer _TransferWeaponToTin[400](playerid, srcitem, tgtitem)
{
	new
		existing = GetItemExtraData(tgtitem),
		amount = GetItemWeaponItemMagAmmo(srcitem) + GetItemWeaponItemReserve(srcitem);

	SetItemExtraData(tgtitem, existing + amount);
	SetItemWeaponItemMagAmmo(srcitem, 0);
	SetItemWeaponItemReserve(srcitem, 0);

	ShowActionText(playerid, sprintf("Transferred %d rounds from weapon to ammo tin", amount), 3000);

	ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_2IDLE", 4.0, 0, 0, 0, 0, 0);
}

// Transfer ammo from ammo item to held ammo item
timer _TransferTinToTin[400](playerid, srcitem, tgtitem)
{
	new
		existing = GetItemExtraData(tgtitem),
		amount = GetItemExtraData(srcitem);

	SetItemExtraData(tgtitem, existing + amount);
	SetItemExtraData(srcitem, 0);

	ShowActionText(playerid, sprintf("Transferred %d rounds from ammo tin to ammo tin", amount), 3000);

	ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_2IDLE", 4.0, 0, 0, 0, 0, 0);
}
