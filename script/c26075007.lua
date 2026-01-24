--Chronophagus HGW
function c26075007.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,aux.FilterBoolFunctionEx(Card.IsSetCard,0x675),c26075007.matfilter)
	Fusion.AddContactProc(c,c26075007.contactfil,c26075007.contactop,c26075007.splimit)
	local se1,se2=Spirit.AddProcedure(c)
	local se3,se4=se1:Clone(),se2:Clone()
	se3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	se3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	se3:SetCode(EVENT_CUSTOM+26075001)
	se3:SetTarget(c26075007.mdtg)
	c:RegisterEffect(se3)
	se4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	se4:SetProperty(EFFECT_FLAG_DELAY|EFFECT_FLAG_SINGLE_RANGE)
	se4:SetCode(EVENT_CUSTOM+26075001)
	se4:SetTarget(c26075007.optg)
	c:RegisterEffect(se4)
	--turn count
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c26075007.adjust)
	c:RegisterEffect(e1)
	--matcheck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c26075007.matcheck)
	e1:SetLabelObject(e2)
	c:RegisterEffect(e2)
	--banish target (temp)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26075007,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e3:SetLabel(1)
	e3:SetCost(c26075007.rmcost)
	e3:SetTarget(c26075007.rmtg)
	e3:SetOperation(c26075007.rmop)
	c:RegisterEffect(e3)
end
c26075007.listed_series={0x675}
c26075007.material_setcode=0x675
function c26075007.matfilter(c,fc,sumtype,tp)
	return c:IsRace(RACE_MACHINE,fc,sumtype,tp)
	and c:IsType(TYPE_SPIRIT,fc,sumtype,tp)
end
function c26075007.contactfil(tp)
	return Duel.GetMatchingGroup(function(c) return c:IsMonster() and c:GetTurnCounter() end,tp,LOCATION_ONFIELD,0,nil)
end
function c26075007.contactop(g,tp)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		if tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.HintSelection(Group.FromCards(tc))
		end
	end
	Duel.SendtoHand(g,nil,REASON_COST|REASON_FUSION|REASON_MATERIAL)
	Duel.RegisterFlagEffect(tp,26075107,RESET_PHASE|PHASE_END,0,1)
end
function c26075007.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
	or (e:GetHandler():GetLocation()~=LOCATION_EXTRA and Duel.GetFlagEffect(tp,26075107)==0)
end
function c26075007.matcheck(e,c)
	local ct=c:GetMaterialCount()+1
	e:SetLabel(ct)
end
function c26075007.mdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:ResetFlagEffect(FLAG_SPIRIT_RETURN)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c26075007.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() or c:IsAbleToExtra() end
	c:ResetFlagEffect(FLAG_SPIRIT_RETURN)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
--register turn count
	function c26075007.adjust(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:HasFlagEffect(26075000) then
			c:SetTurnCounter(0)
			local ct=e:GetLabelObject():GetLabel()
			c:RegisterFlagEffect(26075000,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(26075001,5+ct))
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(26075001,3))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EVENT_PHASE|PHASE_END)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(c26075007.turncount)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(1082946)
			e2:SetRange(LOCATION_MZONE)
			e2:SetOperation(c26075007.reset)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(26075001,3))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT|RESETS_STANDARD)
			e3:SetCondition(c26075007.delay)
			e3:SetValue(ct)
			c:RegisterEffect(e3)
		end
	end
	function c26075007.turncount(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Group.CreateGroup()
		for i,pe in ipairs({Duel.GetPlayerEffect(tp,26075010)}) do
			g:AddCard(pe:GetHandler())
		end
		local tc=g:GetFirst()
		if #g>0 and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(26075010,1)) then
			tc=g:GetFirst() 
			if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
			c26075007.clock(e,tp,tc)
		else
			c26075007.clock(e,tp,c)
		end
	end
	function c26075007.delay(e,tp,eg,ep,ev,re,r,rp,chk)
		return e:GetHandler():GetTurnCounter()<e:GetValue()
	end
	function c26075007.reset(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local ct=c:GetTurnCounter()
		ct=ct+1
		c:SetTurnCounter(ct)
		if not c:HasFlagEffect(FLAG_SPIRIT_RETURN) then
			c:RegisterFlagEffect(FLAG_SPIRIT_RETURN,RESET_CHAIN,0,1)
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+26075001,e,REASON_EFFECT,tp,tp,1082946)
		end
	end
function c26075007.ctfilter(c)
	return c:IsHasEffect(1082946) and c:GetFlagEffect(26075000)~=0 and
	(c:IsSetCard(0x675) and c:IsOnField() or
	c:IsLocation(LOCATION_REMOVED))
end
function c26075007.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	local lb=e:GetLabel()
	local g=Duel.GetMatchingGroup(c26075007.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	local eff,op=0,0
	if chk==0 then return #g>=lb end
	local sg=g:Select(tp,lb,lb,nil)
	local tc=sg:GetFirst()
	for tc in aux.Next(sg) do
		c26075007.clock(e,tp,tc)
	end
end
function c26075007.clock(e,tp,tc)
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
function c26075007.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c26075007.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)==0 then return end 
		local RESETS =RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_STANDBY 
		tc:SetTurnCounter(0)
		tc:RegisterFlagEffect(26075000,RESETS,0,2)
		tc:RegisterFlagEffect(26075007,RESETS,0,2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetCondition(c26075007.retcon)
		e1:SetOperation(c26075007.retop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(1082946)
		e2:SetLabelObject(e1)
		--e2:SetOwnerPlayer(tp)
		e2:SetOperation(c26075007.forward)
		e2:SetReset(RESETS,2)
		tc:RegisterEffect(e2)
	end
end
function c26075007.retcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffect(26075007)~=0 then return true
	else e:Reset(); return false end
end
function c26075007.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ct=tc:GetTurnCounter()+1
	tc:SetTurnCounter(ct)
	if ct>1 then
		Duel.HintSelection(Group.FromCards(tc))
		Duel.ReturnToField(tc,tc:GetPreviousPosition())
		tc:SetTurnCounter(0)
	end
end
function c26075007.forward(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if  c26075007.retcon(te,tp,nil,tp,1082946,te,0,tp)
	then c26075007.retop(te,tp,nil,tp,1082946,te,0,tp) end
end