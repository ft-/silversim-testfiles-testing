default
{
	state_entry()
	{
		osForceAttachToOtherAvatarFromInventory(NULL_KEY, "Hello", 10);
		osForceDetachFromAvatar();
		list at = osGetNumberOfAttachments(NULL_KEY, [ATTACH_HEAD, ATTACH_LHAND, ATTACH_RHAND]);
		osDropAttachment();
		osDropAttachmentAt(<1,1,1>, ZERO_ROTATION);
		osForceDropAttachment();
		osForceDropAttachmentAt(<1,1,1>,ZERO_ROTATION);
	}
}