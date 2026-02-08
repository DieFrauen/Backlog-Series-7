--Polterghast Nightmare - REM
function c26073008.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,3,3,c26073008.ovfilter,aux.Stringid(26073008,0),Xyz.InfiniteMats)
	c:EnableReviveLimit()
	--flip face-down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26073008,1))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SET)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_FLIP|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,26073008)
	e1:SetTarget(c26073008.fdtg)
	e1:SetOperation(c26073008.fdop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1a:SetCondition(c26073008.xcon)
	c:RegisterEffect(e1a)
	--Both players may not Normal summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_SUMMON)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(function(e)
		return Duel.GetFlagEffect(e:GetHandlerPlayer(),26073008)==0 end)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e3:SetTargetRange(0,1)
	e3:SetCondition(function(e)
		return Duel.GetFlagEffect(1-e:GetHandlerPlayer(),26073008)==0 end)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCode(EVENT_FLIP)
	e4:SetOperation(function(e) e:GetHandler():RegisterFlagEffect(26073008,RESETS_STANDARD_PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26073008,2)) end)
	c:RegisterEffect(e4)
	--cannot Flip Summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e5:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c26073008.setcon)
	e5:SetTarget(c26073008.settg)
	e5:SetTargetRange(1,1)
	c:RegisterEffect(e5)
	aux.GlobalCheck(c26073008,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MSET)
		ge1:SetOperation(c26073008.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SSET)
		ge2:SetOperation(c26073008.checkop)
		Duel.RegisterEffect(ge2,0)
	end)
	--Subconscious (condition FLIP effects)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(26073008)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
end
function c26073008.ovfilter(c,tp,lc)
	return c:IsType(TYPE_XYZ) and c:IsStatus(STATUS_FLIP_SUMMON_TURN) and c:IsRankBelow(2)
end
function c26073008.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsXyzSummoned() and Duel.IsPlayerAffectedByEffect(tp,26073008)
end
function c26073008.posfilter(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE)
	and (c:IsFacedown() or c:IsCanChangePosition())
end
function c26073008.fdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanTurnSet() end
	if chk==0 then return Duel.IsExistingTarget(c26073008.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c26073008.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,#g,tp,POS_FACEUP_DEFENSE)
end
function c26073008.chkfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE)
	and c26073008.posfilter(c)
end
function c26073008.fdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c26073008.chkfilter,nil,e)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
	end
end
function c26073008.setcon(e)
	return e:GetHandler():HasFlagEffect(26073008)
	and Duel.GetFlagEffect(1-e:GetHandlerPlayer(),26073008)>0
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
function c26073008.settg(e,c)
	return not c:IsType(TYPE_FLIP)
end