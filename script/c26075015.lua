--Chronophagus Determinism
function c26075015.initial_effect(c)
	--rewind counter
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26075015,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,26075015)
	e1:SetCondition(c26075015.condition1)
	e1:SetTarget(c26075015.target1)
	e1:SetOperation(c26075015.activate1)
	c:RegisterEffect(e1)
	--Omni-negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26075015,1))
	e2:SetCategory(CATEGORY_NEGATE|CATEGORY_REMOVE|CATEGORY_SET)
	e2:SetCountLimit(1,{26075015,1})
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCost(c26075015.cost)
	e2:SetTarget(c26075015.target2)
	e2:SetOperation(c26075015.activate2)
	c:RegisterEffect(e2)
	--pyro clock
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26075015,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetTarget(c26075015.revtg)
	e3:SetOperation(c26075015.revop)
	c:RegisterEffect(e3) 
	--Trap activate in set turn
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e4:SetDescription(aux.Stringid(26075015,3))
	c:RegisterEffect(e4)   
end
function c26075015.condition1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return Duel.IsChainNegatable(ev) and rc:IsSetCard(0x675)
	and rc:IsOnField() and rc:IsMonster() and rc:GetTurnCounter()>0
end
function c26075015.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c26075015.activate1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.NegateActivation(ev) and rc:IsRelateToEffect(re) then
		rc:SetTurnCounter(0)
	end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable(true) and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.BreakEffect()
		c:CancelToGrave()
		Duel.ChangePosition(c,POS_FACEDOWN)
		Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
	end
end
function c26075015.ctfilter(c)
	return c:IsSetCard(0x675) and c:IsFaceup() and c:GetTurnCounter() and c:GetCardEffect(1082946)
end
function c26075015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	local g=Duel.GetMatchingGroup(c26075015.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	local eff,op=0,0
	if chk==0 then return #g>1 end
	local sg=g:Select(tp,2,2,nil)
	local tc=sg:GetFirst()
	for tc in aux.Next(sg) do
		c26075015.clock(e,tp,tc)
	end
end
function c26075015.clock(e,tp,tc)
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
function c26075015.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c26075015.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
		local RESETS =RESET_EVENT|RESETS_STANDARD 
		tc:SetTurnCounter(0)
		tc:RegisterFlagEffect(26075000,RESETS,0,1)
		tc:RegisterFlagEffect(26075015,RESETS,0,1)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetCondition(c26075015.retcon)
		e1:SetOperation(c26075015.retop)
		Duel.RegisterEffect(e1,tc:GetOwner())
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(1082946)
		e2:SetLabelObject(e1)
		e2:SetOwnerPlayer(tp)
		e2:SetOperation(c26075015.forward)
		e2:SetReset(RESETS,3)
		tc:RegisterEffect(e2)
	end
end
function c26075015.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c and c:GetFlagEffect(26075015)~=0 then return true
	else e:Reset(); return false end
end
function c26075015.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local ct=c:GetTurnCounter()+1
	c:SetTurnCounter(ct)
	if ct>1 then
		Duel.SendtoHand(c,nil,REASON_RULE|REASON_RETURN)
		c:SetTurnCounter(0)
		e:Reset()
	end
end
function c26075015.forward(e,tp,eg,ep,ev,re,r,rp)
	c26075015.retop(e:GetLabelObject(),tp,0,nil,0,nil,0,nil)
end
function c26075015.revfilter(c)
	return c:IsHasEffect(1082946) and c:IsSetCard(0x675) and c:IsOnField() and c:GetTurnCounter()>0
end
function c26075015.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26075015.revfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c26075015.revop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c26075015.revfilter,tp,LOCATION_ONFIELD|LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		tc:SetTurnCounter(0)
	end
end