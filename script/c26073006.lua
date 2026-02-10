--Polterghast - Smoggart
function c26073006.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,2,2,c26073006.ovfilter,aux.Stringid(26073006,0),2,c26073006.xyzop)
	c:EnableReviveLimit()
	--flip face-down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26073006,1))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SET)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_FLIP|EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,26073006)
	e1:SetTarget(c26073006.fdtg)
	e1:SetOperation(c26073006.fdop)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1a:SetCondition(c26073006.x2con)
	c:RegisterEffect(e1a)
	--search "Polterghast Cyclone"
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26073006,2))
	e2:SetCategory(CATEGORY_TOHAND|CATEGORY_SEARCH|CATEGORY_SET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c26073006.xcon)
	e2:SetCountLimit(1,{26073006,1})
	e2:SetTarget(c26073006.thtg)
	e2:SetOperation(c26073006.thop)
	c:RegisterEffect(e2)
	--copies "Polterghast" flip effects
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26073006,3))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{26073006,2})
	e3:SetCost(c26073006.applycost)
	e3:SetTarget(c26073006.applytg)
	e3:SetOperation(c26073006.applyop)
	c:RegisterEffect(e3)
end
function c26073006.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,26073006)==0 end
	Duel.RegisterFlagEffect(tp,26073006,RESET_PHASE|PHASE_END,0,1)
	return true
end
function c26073006.ovfilter(c,tp,xyzc)
	return c:IsFaceup() and c:IsSetCard(0x673,xyzc,SUMMON_TYPE_XYZ,tp) and c:GetLevel()==2
end
function c26073006.xcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsXyzSummoned() 
end
function c26073006.x2con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsXyzSummoned() and Duel.IsPlayerAffectedByEffect(tp,26073008)
end
function c26073006.fdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanTurnSet() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,Card.IsCanTurnSet,tp,LOCATION_MZONE,LOCATION_MZONE,1,1+c:GetOverlayCount(),nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,tp,POS_FACEDOWN_DEFENSE)
end
function c26073006.chkfilter(c,e)
	return c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup()
end
function c26073006.fdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c26073006.chkfilter,nil,e)
	if #g>0 then
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
function c26073006.rmfilter(c,e,tp)
	if not (c:IsSetCard({0x673}) and c:IsMonster() and c:GetLevel()==2 and c:IsAbleToGraveAsCost()) then return false end
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
function c26073006.thfilter(c,tp)
	return c:IsCode(26073010) and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp,true,true))
end
function c26073006.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26073006.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then Duel.RegisterFlagEffect(tp,CARD_MAGICAL_MIDBREAKER,RESET_CHAIN,0,1) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26073006.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sc=Duel.GetFirstMatchingCard(c26073006.thfilter,tp,LOCATION_DECK,0,nil,tp)
	Duel.ConfirmCards(tp,sc)
	aux.ToHandOrElse(sc,tp,
		function()
			return sc:IsSSetable()
		end,
		function()
			Duel.SSet(tp,sc)
		end,
		aux.Stringid(26073006,4)
	)
end
function c26073006.applycost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:IsExists(c26073006.rmfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=og:FilterSelect(tp,c26073006.rmfilter,1,1,nil,e,tp):GetFirst()
	Duel.SendtoGrave(rc,REASON_COST)
	local available_effs={}
	local effs={rc:GetOwnEffects()}
	for _,eff in ipairs(effs) do
		if eff:GetType()&EFFECT_TYPE_FLIP ~=0 then
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
function c26073006.applytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
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
function c26073006.applyop(e,tp,eg,ep,ev,re,r,rp)
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