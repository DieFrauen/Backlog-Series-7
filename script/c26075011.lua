--Chronophagus Phenomena
function c26075011.initial_effect(c)
	--Add to hand (now or later)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26075011,0))
	e0:SetCategory(CATEGORY_TOHAND|CATEGORY_SEARCH|CATEGORY_REMOVE)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCountLimit(1,26075011,EFFECT_COUNT_CODE_OATH)
	e0:SetTarget(c26075011.target)
	e0:SetOperation(c26075011.activate)
	c:RegisterEffect(e0)
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26075011,1))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE|LOCATION_REMOVED)
	e1:SetCountLimit(1,26075011,EFFECT_COUNT_CODE_OATH)
	e1:SetLabel(1)
	e1:SetTarget(c26075011.target2)
	e1:SetOperation(c26075011.activate1)
	c:RegisterEffect(e1)
	--banish from deck for 5 turns
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(26075011,2))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetLabel(2)
	e2:SetOperation(c26075011.activate2)
	c:RegisterEffect(e2)
	--mulligan
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(26075011,3))
	e3:SetLabel(3)
	e3:SetOperation(c26075011.activate3)
	c:RegisterEffect(e3)
end
function c26075011.thfilter(c)
	return (c:IsCode(26075010) or c:IsSetCard(0x675) and c:IsMonster())
	and (c:IsAbleToHand() or c:IsAbleToRemove())
end
function c26075011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26075011.thfilter,tp,LOCATION_DECK|LOCATION_GRAVE,0,1,nil) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK|LOCATION_GRAVE)
end
function c26075011.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c26075011.thfilter),tp,LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if not sc then return end
	aux.ToHandOrElse(sc,tp,
		function() return sc:IsAbleToRemove() end,
		function()
			Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
			local RESETS =RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_STANDBY 
			Duel.Remove(sc,POS_FACEUP,REASON_EFFECT)
			sc:RegisterFlagEffect(26075011,RESETS,0,1)
			sc:RegisterFlagEffect(26075000,RESETS,0,1)
			local e1=Effect.CreateEffect(sc)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
			e1:SetCountLimit(1)
			e1:SetLabelObject(sc)
			e1:SetOwnerPlayer(tp)
			e1:SetCondition(c26075011.retcon)
			e1:SetOperation(c26075011.retop)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
			e2:SetCode(1082946)
			e2:SetLabelObject(e1)
			e2:SetOwnerPlayer(tp)
			e2:SetOperation(c26075011.forward)
			e2:SetReset(RESETS,1)
			sc:RegisterEffect(e2)
		end,
		aux.Stringid(26075011,4)
	)
end
function c26075011.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c and c:GetFlagEffect(26075011)~=0 then return true
	else e:Reset(); return false end
end
function c26075011.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local ct=c:GetTurnCounter()+1
	c:SetTurnCounter(ct)
	if ct>=1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,e:GetHandler())
		c:SetTurnCounter(0)
		e:Reset()
	end
end
function c26075011.forward(e,tp,eg,ep,ev,re,r,rp)
	c26075011.thop(e:GetLabelObject(),tp,0,nil,0,nil,0,nil)
end
function c26075011.ctfilter(c)
	return c:IsHasEffect(1082946) and c:GetFlagEffect(26075000)~=0
	and c:IsSetCard(0x675) and c:IsOnField()
end
function c26075011.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsFaceup() and c26075011.ctfilter(chkc) and chkc:IsControler(tp) end
	local lb=e:GetLabel()
	local b1=(lb==1 and Duel.IsExistingMatchingCard(c26075011.remfilter,tp,LOCATION_DECK,0,1,nil))
	local b2=(lb==2 and Duel.IsPlayerCanDraw(tp,1))
	local b3= lb==3 and Duel.IsExistingMatchingCard(c26075011.advfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
	if chk==0 then return Duel.IsExistingTarget(c26075011.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) and (b1 or b2 or b3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c26075011.ctfilter,tp,LOCATION_ONFIELD,0,1,99,nil)
	if lb==2 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,#g+2,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,#g,tp,LOCATION_HAND)
	end
end
function c26075011.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,nil,LOCATION_DECKSHF,REASON_EFFECT)
	local g=Duel.GetTargetCards(e)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		c26075011.clock(e,tp,tc)
		--Unaffected
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(3104)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetRange(tc:GetLocation())
		e1:SetReset(RESET_CHAIN)
		e1:SetValue(c26075011.efilter)
		tc:RegisterEffect(e1)
	end
end
function c26075011.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,nil,LOCATION_DECKSHF,REASON_EFFECT)
	local g=Duel.GetTargetCards(e)
	local rc=g:GetFirst()
	for rc in aux.Next(g) do
		c26075011.clock(e,tp,rc)
	end
	Duel.Draw(tp,#g,REASON_EFFECT)
	Duel.ShuffleHand(tp)
	Duel.BreakEffect()
	local dg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,#g-1,#g-1,nil)
	if #dg<1 then return end
	Duel.SendtoDeck(dg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
end
function c26075011.advfilter(c)
	return c:IsHasEffect(1082946) and c:GetFlagEffect(26075000)~=0
end
function c26075011.activate3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,nil,LOCATION_DECKSHF,REASON_EFFECT)
	local g1=Duel.GetTargetCards(e)
	local rc=g1:GetFirst()
	for rc in aux.Next(g1) do
		c26075011.clock(e,tp,rc)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g2=Duel.GetMatchingGroup(c26075011.advfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	for tc in aux.Next(g2) do
		tc:CreateEffectRelation(e)
	end
	local ct,mt=#g1,1
	local sc=nil
	while #g2>0 and ct>0 do
		Duel.BreakEffect()
		if sc and g2:IsContains(sc) and not sc:IsRelateToEffect(e) then
			g2:Sub(sc)
		end
		sc=g2:Select(tp,mt,1,nil):GetFirst()
		if sc then
			c26075011.clock(e,tp,sc)
			ct=ct-1
			mt=0
		end
	end
end
function c26075011.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c26075011.clock(e,tp,tc)
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
function c26075011.forward(e,tp,eg,ep,ev,re,r,rp)
	c26075011.thop(e:GetLabelObject(),tp,0,nil,0,nil,0,nil)
end