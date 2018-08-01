--[[
AddCSLuaFile()

SWEP.PrintName = "Walkie talkie"
SWEP.Author = "Shark_vil"
SWEP.Purpose = "Heal people with your primary attack, or yourself with the secondary."

SWEP.Slot = 5
SWEP.SlotPos = 3

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/fg/c_arms_walkie_talkie.mdl" )
SWEP.WorldModel = Model( "models/weapons/fg/c_arms_walkie_talkie.mdl" )
SWEP.ViewModelFOV = 54
SWEP.UseHands = false

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Think()
	-- self:SetSequence( "open" )
	
	-- local dur = self.Owner:SequenceDuration("ActionIdle")
	
	-- self.Owner:NextThink(CurTime() + dur)
end

function SWEP:Initialize()
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:OnRemove()
end

function SWEP:Holster()
end

function SWEP:CustomAmmoDisplay()
end

function SWEP:GetViewModelPosition( pos, ang )
	local rpos = Vector(0, 0, 0)
	local rang = Vector(90, 0, 0)
	return rpos, rang
end
]]