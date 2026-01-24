--Chronophagus Paradragox
function c26075009.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixRep(c,true,true,c26075009.matfilter,2,4,c26075009.mfilter)
	local se1,se2=Spirit.AddProcedure(c)
	local se3,se4=se1:Clone(),se2:Clone()
	se3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	se3:SetCode(EVENT_CUSTOM+26075001)
	se3:SetTarget(c26075009.mdtg)
	se3:SetOperation(c26075009.op)
	c:RegisterEffect(se3)
	se4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	se4:SetProperty(EFFECT_FLAG_DELAY)
	se4:SetCode(EVENT_CUSTOM+26075001)
	se4:SetTarget(c26075009.optg)
	se4:SetOperation(c26075009.op)
	c:RegisterEffect(se4)
	--turn count
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c26075009.adjust)
	c:RegisterEffect(e1)
	--matcheck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c26075009.matcheck)
	e1:SetLabelObject(e2)
	c:RegisterEffect(e2)
	--rewrite into advancing turn counts
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26075009,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c26075009.recon)
	e3:SetOperation(c26075009.reop)
	c:RegisterEffect(e3)
	--return targets to hand (eventually)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26075009,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetLabelObject(e2)
	e4:SetCondition(function(e) return e:GetHandler():IsFusionSummoned() end)
	e4:SetTarget(c26075009.target)
	c:RegisterEffect(e4)
	--these targets
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetLabelObject(e4)
	e5:SetCondition(aux.PersistentTgCon)
	e5:SetOperation(c26075009.remop)
	c:RegisterEffect(e5)
end
c26075009.listed_series={0x675}
c26075009.material_setcode=0x675
function c26075009.matfilter(c,fc,sumtype,tp)
	return c:IsSetCard(0x675,fc,sumtype,tp)
end
function c26075009.mfilter(c,fc,sumtype,tp)
	return c:IsLevelAbove(5)
	and (c:IsType(TYPE_FUSION,fc,sumtype,tp)
	or c:IsSetCard(0x675,fc,sumtype,tp))
end
function c26075009.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c26075009.matcheck(e,c)
	local mt=e:GetHandler():GetMaterial()
	mt:KeepAlive()
	e:SetLabelObject(mt)
end
function c26075009.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lb=e:GetLabelObject():GetLabelObject()
	local mt=lb:FilterCount(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp)
	and chkc:IsFaceup() and chkc:IsAbleToRemove() end
	if chk==0 then return mt>0 and Duel.IsExistingTarget(aux.AND(Card.IsFaceup,Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,aux.AND(Card.IsFaceup,Card.IsAbleToRemove),tp,0,LOCATION_ONFIELD,1,mt,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
end
function c26075009.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(re) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,re)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		c:SetCardTarget(tc)
	end
end
function c26075009.mdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:ResetFlagEffect(FLAG_SPIRIT_RETURN)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c26075009.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtra() end
	c:ResetFlagEffect(FLAG_SPIRIT_RETURN)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c26075009.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetCardTarget()
	g:AddCard(c)
	g=g:Filter(Card.IsAbleToHand,nil)
	local tc=g:GetFirst()
	if c:IsRelateToEffect(e) and #g>0 then
		if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
		if tc==c then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		else
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
--register turn count
	function c26075009.adjust(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:HasFlagEffect(26075000) then
			c:SetTurnCounter(0)
			local ct=e:GetLabelObject():GetLabelObject()
			local ct=#ct
			c:RegisterFlagEffect(26075000,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(26075001,5+ct))
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(26075001,3))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EVENT_PHASE|PHASE_END)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(c26075009.turncount)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(1082946)
			e2:SetRange(LOCATION_MZONE)
			e2:SetOperation(c26075009.reset)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(26075001,3))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT|RESETS_STANDARD)
			e3:SetCondition(c26075009.delay)
			e3:SetValue(ct)
			c:RegisterEffect(e3)
		end
	end
	function c26075009.turncount(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Group.CreateGroup()
		for i,pe in ipairs({Duel.GetPlayerEffect(tp,26075010)}) do
			g:AddCard(pe:GetHandler())
		end
		local tc=g:GetFirst()
		if #g>0 and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(26075010,1)) then
			tc=g:GetFirst() 
			if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
			c26075009.clock(e,tp,tc)
		else
			c26075009.clock(e,tp,c)
		end
	end
	function c26075009.delay(e,tp,eg,ep,ev,re,r,rp,chk)
		return e:GetHandler():GetTurnCounter()<e:GetValue()
	end
	function c26075009.reset(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local ct=c:GetTurnCounter()
		ct=ct+1
		c:SetTurnCounter(ct)
		if not c:HasFlagEffect(FLAG_SPIRIT_RETURN) then
			c:RegisterFlagEffect(FLAG_SPIRIT_RETURN,RESET_CHAIN,0,1)
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+26075001,e,REASON_EFFECT,tp,tp,1082946)
		end
	end
function c26075009.recon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rp==1-tp and rc:IsOnField() and Duel.IsChainDisablable(ev)
	and not re:GetHandler():IsStatus(STATUS_DISABLED)
end
function c26075009.reop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:GetFlagEffect(26075109)==0
	and Duel.SelectEffectYesNo(tp,c) then
		c:RegisterFlagEffect(26075109,RESET_CHAIN,0,1)
		c26075009.clock(e,tp,c)
		Duel.NegateEffect(ev)
	end
end
function c26075009.clock(e,tp,tc)
	local eff={tc:GetCardEffect(1082946)}
	local sel={}
	local seld={}
	local turne
	for _,te in ipairs(eff) do
		table.insert(sel,te)
		table.insert(seld,te:GetDescription())
	end
	if #sel==1 then turne=sel[1] elseif #sel>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		local op=Duel.SelectOption(tp,table.unpack(seld))+1
		turne=sel[op]
	end
	if not turne then return end
	local op=turne:GetOperation()
	op(turne,turne:GetOwnerPlayer(),nil,0,1082946,nil,0,0)
	return true
end