--Chronophagus Causality
function c26075010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,26075010,EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c26075010.activate)
	c:RegisterEffect(e1)
	--turn count
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_FZONE)
	e2:SetOperation(c26075010.adjust)
	c:RegisterEffect(e2)
	--Enable turn count modulation
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(26075010)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	--increase ATK
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(LOCATION_MZONE,0)
	e5:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_SPIRIT))
	e5:SetValue(c26075010.atkval)
	c:RegisterEffect(e5)
	--Destroy replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_FZONE)
	e6:SetTarget(c26075010.desreptg)
	e6:SetOperation(c26075010.desrepop)
	c:RegisterEffect(e6)
	--pyro clock
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(26075011,2))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_REMOVE)
	e7:SetTarget(c26075010.advtg)
	e7:SetOperation(c26075010.advop)
	c:RegisterEffect(e7)
end
function c26075010.filter(c)
	return c:IsLevelAbove(1) and c:IsSetCard(0x675) and c:IsAbleToRemove()
end
function c26075010.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c26075010.filter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(26075010,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		local RESETS =RESET_EVENT|RESETS_STANDARD 
		tc:SetTurnCounter(0)
		local lv=tc:GetLevel()
		tc:RegisterFlagEffect(26075010,RESETS,0,lv)
		tc:RegisterFlagEffect(26075000,RESETS,0,lv)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetLabel(lv)
		e1:SetOwnerPlayer(tp)
		e1:SetOperation(c26075010.thop)
		e1:SetReset(RESET_PHASE|PHASE_STANDBY,lv)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(1082946)
		e2:SetLabelObject(e1)
		e2:SetOwnerPlayer(tp)
		e2:SetOperation(c26075010.forward)
		e2:SetReset(RESETS,lv)
		tc:RegisterEffect(e2)
	end
end
function c26075010.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(26075010)==0 then
		tc:SetTurnCounter(0); e:Reset(); return 
	end
	local ct=tc:GetTurnCounter()
	ct=ct+1
	tc:SetTurnCounter(ct)
	if ct>=e:GetLabel() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		tc:SetTurnCounter(0)
		e:Reset()
	end
end
function c26075010.forward(e,tp,eg,ep,ev,re,r,rp)
	c26075010.thop(e:GetLabelObject(),tp,0,nil,0,nil,0,nil)
end
function c26075010.atkval(e,c)
	return e:GetHandler():GetTurnCounter()*100
end
--register turn count
	function c26075010.adjust(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:HasFlagEffect(26075000) then
			c:SetTurnCounter(0)
			c:RegisterFlagEffect(26075000,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(26075010,3))
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(26075001,3))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EVENT_PHASE|PHASE_END)
			e1:SetRange(LOCATION_FZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(c26075010.turncount)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(1082946)
			e2:SetRange(LOCATION_FZONE)
			e2:SetOperation(c26075010.reset)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	end
	function c26075010.turncount(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Group.CreateGroup()
		for i,pe in ipairs({Duel.GetPlayerEffect(tp,26075010)}) do
			g:AddCard(pe:GetHandler())
		end
		g:Sub(c)
		local tc=g:GetFirst()
		if #g>0 and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(26075010,1)) then
			tc=g:GetFirst() 
			if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
			c26075010.clock(e,tp,tc)
		else
			c26075010.clock(e,tp,c)
		end
	end
	function c26075010.reset(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local ct=c:GetTurnCounter()
		ct=ct+1
		c:SetTurnCounter(ct)
		if ct>11 then
			Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		end
	end
function c26075010.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsReason(REASON_REPLACE+REASON_RULE)
		and e:GetHandler():GetTurnCounter() end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c26075010.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local eff=c:GetCardEffect(1082946)
	local op=eff:GetOperation()
	op(eff,tp,nil,0,1082946,nil,0,0)
end

function c26075010.advfilter(c)
	return c:IsHasEffect(1082946) and c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(26075000)~=0
end
function c26075010.advtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26075010.advfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
end
function c26075010.advop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local tc=Duel.SelectMatchingCard(tp,c26075010.advfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil):GetFirst()
	tc:CreateEffectRelation(e) 
	if tc and c26075010.clock(e,tp,tc) then
		if tc:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(26075004,2)) then
			c26075010.clock(e,tp,tc)
		end
	end
end
function c26075010.clock(e,tp,tc)
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