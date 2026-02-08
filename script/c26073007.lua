--Polterghast Nimbucus
function c26073007.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsType,TYPE_FLIP),2,2,nil,nil,Xyz.InfiniteMats)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26073007,1))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_FLIP)
	e1:SetCountLimit(1,26073007)
	e1:SetTarget(c26073007.fltg)
	e1:SetOperation(c26073007.flop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1a:SetCondition(c26073007.xcon)
	c:RegisterEffect(e1a)
	--flip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26073007,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY|EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_FLIP)
	e2:SetCountLimit(1,26073007)
	e2:SetCost(c26073007.applycost)
	e2:SetTarget(c26073007.applytg)
	e2:SetOperation(c26073007.applyop)
	c:RegisterEffect(e2)
	local e2a=e2:Clone()
	e2a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2a:SetCondition(c26073007.xcon)
	c:RegisterEffect(e2a)
	--Your opponent cannot activate Spell/Trap Cards that were not Set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,1)
	e3:SetCondition(function(e)
		return e:GetHandler():HasFlagEffect(26073007) end)
	e3:SetValue(function(e,re,tp)
		local rc=re:GetHandler()
		return re:IsHasType(EFFECT_TYPE_ACTIVATE)
		and not rc:IsLocation(LOCATION_SZONE)
		and not rc:IsSetCard(0x673) end)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_FLIP)
	e4:SetOperation(function(e) e:GetHandler():RegisterFlagEffect(26073007,RESETS_STANDARD_PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26073007,2)) end)
	c:RegisterEffect(e4)
	--cannot SSet twice
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e5:SetCode(EFFECT_CANNOT_SSET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c26073007.setcon)
	e5:SetTarget(c26073007.settg)
	e5:SetTargetRange(0,1)
	c:RegisterEffect(e5)
	aux.GlobalCheck(c26073007,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c26073007.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
function c26073007.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsXyzSummoned() and Duel.IsPlayerAffectedByEffect(tp,26073008)
end
function c26073007.filter(c)
	return c:IsSpellTrap() and c:IsAbleToHand()
end
function c26073007.fltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c26073007.filter,tp,0,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c26073007.filter,tp,0,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,#sg,0,0)
end
function c26073007.flop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c26073007.filter,tp,0,LOCATION_ONFIELD,e:GetHandler())
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end
function c26073007.ovfilter(c,e,tp)
	if not c:IsType(TYPE_FLIP) and c:IsMonster() then return false end
	local effs={c:GetOwnEffects()}
	for _,eff in ipairs(effs) do
		if eff:GetType()&EFFECT_TYPE_FLIP ~=0 then
			local con=eff:GetCondition()
			local tg=eff:GetTarget()
			if (con==nil or con(eff,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,0))
				and (tg==nil or tg(eff,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,0)) then
				return true
			end
		end
	end
	return false
end
function c26073007.applycost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:IsExists(c26073007.ovfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=og:FilterSelect(tp,c26073007.ovfilter,1,1,nil,e,tp):GetFirst()
	Duel.Hint(HINT_CARD,1-tp,rc:GetCode())
	local available_effs={}
	local effs={rc:GetOwnEffects()}
	for _,eff in ipairs(effs) do
		if eff:GetType()&EFFECT_TYPE_FLIP ~=0 and not eff:IsHasProperty(EFFECT_FLAG_UNCOPYABLE) then
			local con=eff:GetCondition()
			local tg=eff:GetTarget()
			if (con==nil or con(eff,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,0))
				and (tg==nil or tg(eff,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE,0)) then
				table.insert(available_effs,eff)
			end
		end
	end
	e:SetLabelObject(available_effs)
end
function c26073007.applytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local eff=e:GetLabelObject()
		return eff and eff:GetTarget() and eff:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return true end
	local eff=nil
	local available_effs=e:GetLabelObject()
	if #available_effs>1 then
		local available_effs_desc={}
		for _,eff in ipairs(available_effs) do
			table.insert(available_effs_desc,eff:GetDescription())
		end
		local op=Duel.SelectOption(tp,table.unpack(available_effs_desc))
		eff=available_effs[op+1]
	else
		eff=available_effs[1]
	end
	Duel.Hint(HINT_OPSELECTED,1-tp,eff:GetDescription())
	e:SetLabel(eff:GetLabel())
	e:SetLabelObject(eff:GetLabelObject())
	e:SetProperty(eff:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and EFFECT_FLAG_CARD_TARGET or 0)
	local tg=eff:GetTarget()
	if tg then
		tg(e,tp,eg,ep,ev,re,r,rp,1)
	end
	eff:SetLabel(e:GetLabel())
	eff:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(eff)
	Duel.ClearOperationInfo(0)
end
function c26073007.applyop(e,tp,eg,ep,ev,re,r,rp)
	local eff=e:GetLabelObject()
	if not eff then return end
	e:SetLabel(eff:GetLabel())
	e:SetLabelObject(eff:GetLabelObject())
	local op=eff:GetOperation()
	if op then
		op(e,tp,Group.CreateGroup(),PLAYER_NONE,0,e,REASON_EFFECT,PLAYER_NONE)
	end
	e:SetLabel(0)
	e:SetLabelObject(nil)
end
function c26073007.checkop(e,tp,eg,ep,ev,re,r,rp)
	local PHASE =Duel.IsMainPhase() and Duel.GetCurrentPhase() or 0
	if eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND) then
		local g=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND)
		for tc in aux.Next(g) do
			if PHASE and tc:GetFlagEffect(26073007)==0 then
				tc:RegisterFlagEffect(26073007,RESET_EVENT|(RESETS_STANDARD&~RESET_TURN_SET),0,1)
				Duel.RegisterFlagEffect(rp,26073007,RESET_PHASE|PHASE,0,1)
			end
		end
	end
end
function c26073007.setcon(e)
	return e:GetHandler():HasFlagEffect(26073007)
	and Duel.GetFlagEffect(1-e:GetHandlerPlayer(),26073007)>0
end
function c26073007.settg(e,c)
	return c:IsLocation(LOCATION_HAND)
end