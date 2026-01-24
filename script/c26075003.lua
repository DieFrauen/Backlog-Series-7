--Chronophagus Bootstrap
function c26075003.initial_effect(c)
	local se1,se2=Spirit.AddProcedure(c)
	local se3,se4=se1:Clone(),se2:Clone()
	se3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	se3:SetCode(EVENT_CUSTOM+26075001)
	c:RegisterEffect(se3)
	se4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	se4:SetProperty(EFFECT_FLAG_DELAY)
	se4:SetCode(EVENT_CUSTOM+26075001)
	c:RegisterEffect(se4)
	--turn count
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c26075003.adjust)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26075003,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,26075003)
	e2:SetCondition(c26075003.spcon)
	e2:SetTarget(c26075003.sptg)
	e2:SetOperation(c26075003.spop)
	c:RegisterEffect(e2)
	--Banish Monster from Deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26075003,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetCountLimit(1,{26075003,1})
	e3:SetTarget(c26075003.target)
	e3:SetOperation(c26075003.operation)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
--register turn count
	function c26075003.adjust(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:HasFlagEffect(26075000) then
			c:SetTurnCounter(0)
			local ct=1; if c:IsNormalSummoned() then ct=3 end
			c:RegisterFlagEffect(26075000,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(26075001,5+ct))
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(26075001,3))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EVENT_PHASE|PHASE_END)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(c26075003.turncount)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(1082946)
			e2:SetRange(LOCATION_MZONE)
			e2:SetOperation(c26075003.reset)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(26075001,3))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT|RESETS_STANDARD)
			e3:SetCondition(c26075003.delay)
			e3:SetValue(ct)
			c:RegisterEffect(e3)
		end
	end
	function c26075003.turncount(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Group.CreateGroup()
		for i,pe in ipairs({Duel.GetPlayerEffect(tp,26075010)}) do
			g:AddCard(pe:GetHandler())
		end
		local tc=g:GetFirst()
		if #g>0 and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(26075010,1)) then
			tc=g:GetFirst() 
			if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
			c26075003.clock(e,tp,tc)
		else
			c26075003.clock(e,tp,c)
		end
	end
	function c26075003.delay(e,tp,eg,ep,ev,re,r,rp,chk)
		return e:GetHandler():GetTurnCounter()<e:GetValue()
	end
	function c26075003.reset(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local ct=c:GetTurnCounter()
		ct=ct+1
		c:SetTurnCounter(ct)
		if not c:HasFlagEffect(FLAG_SPIRIT_RETURN) then
			c:RegisterFlagEffect(FLAG_SPIRIT_RETURN,RESET_CHAIN,0,1)
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+26075001,e,REASON_EFFECT,tp,tp,1082946)
		end
	end
function c26075003.remfilter(c)
	return c:IsSetCard(0x675) and c:IsMonster() and c:IsAbleToRemove()
end
function c26075003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26075003.remfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function c26075003.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26075003.remfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil)
	local c=e:GetHandler()
	local tc=g:GetFirst()
	if tc then
		local RESETS =RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_STANDBY 
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		tc:RegisterFlagEffect(26075003,RESETS,0,2)
		tc:RegisterFlagEffect(26075000,RESETS,0,2)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetOwnerPlayer(tp)
		e1:SetCondition(c26075003.retcon)
		e1:SetOperation(c26075003.retop)
		e1:SetReset(RESETS,2)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(1082946)
		e2:SetLabelObject(e1)
		e2:SetOwnerPlayer(tp)
		e2:SetOperation(c26075003.forward)
		e2:SetReset(RESETS,2)
		tc:RegisterEffect(e2)
	end
end
function c26075003.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c and c:GetFlagEffect(26075003)~=0 then return true
	else e:Reset(); return false end
end
function c26075003.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local ct=c:GetTurnCounter()+1
	c:SetTurnCounter(ct)
	if ct>1 then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
		c:SetTurnCounter(0)
		e:Reset()
	end
end
function c26075003.forward(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if  c26075003.retcon(te,tp,nil,tp,1082946,te,0,tp)
	then c26075003.retop(te,tp,nil,tp,1082946,te,0,tp) end
end
function c26075003.advfilter(c)
	return c:IsHasEffect(1082946) and c:GetFlagEffect(26075000)~=0 and
	(c:IsSetCard(0x675) and c:IsOnField() or
	c:IsLocation(LOCATION_REMOVED))
end
function c26075003.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26075003.advfilter,tp,LOCATION_ONFIELD|LOCATION_REMOVED,0,1,nil)
end
function c26075003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,0)
end
function c26075003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local tc=Duel.SelectMatchingCard(tp,c26075003.advfilter,tp,LOCATION_ONFIELD|LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if tc and c26075003.clock(e,tp,tc) and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c26075003.clock(e,tp,tc)
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