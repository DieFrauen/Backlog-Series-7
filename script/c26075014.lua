--Chronophagus Instrumentality
function c26075014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c26075014.accost)
	c:RegisterEffect(e1)   
	--Activate the turn is set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26075014,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetValue(function(e,c) e:SetLabel(1) end)
	e2:SetCondition(c26075014.thcond)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	--roll back 1 turn/Set Pyro Clock
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26075014,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE|TIMING_SSET)
	e3:SetCountLimit(1,26075014)
	e3:SetCost(c26075014.cost)
	e3:SetTarget(c26075014.revtg)
	e3:SetOperation(c26075014.revop)
	c:RegisterEffect(e3)
	--shuffle card to Deck
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26075014,2))
	e4:SetCategory(CATEGORY_TODECK)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_SZONE)
	e4:SetHintTiming(0,TIMING_END_PHASE|TIMING_SSET)
	e4:SetCountLimit(1,{26075014,1})
	e4:SetCost(c26075014.tdcost)
	e4:SetTarget(c26075014.tdtg)
	e4:SetOperation(c26075014.tdop)
	c:RegisterEffect(e4)
	--turn count
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c26075014.adjust)
	c:RegisterEffect(e5)
	--maintain
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(26075014,3))
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetOperation(c26075014.mtop)
	c:RegisterEffect(e6)
end
function c26075014.ctfilter(c)
	return c:IsHasEffect(1082946) and
	(c:IsSetCard(0x675) and c:IsOnField() and c:IsFaceup() or
	c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(26075000)~=0)
end
function c26075014.costfilter(c)
	return c:IsRitualMonster() and c:IsDiscardable() and c:IsAbleToGraveAsCost()
end
function c26075014.thcond(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c26075014.ctfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,2,e:GetHandler())
end
function c26075014.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26075014.ctfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	local oe=e:GetLabelObject()
	if chk==0 then oe:SetLabel(0) return true end
	if oe:GetLabel()>0 then
		oe:SetLabel(0)
		local sg=g:Select(tp,2,2,nil)
		local sc=sg:GetFirst()
		for sc in aux.Next(sg) do
			c26075011.clock(e,tp,sc)
		end
	end
end
function c26075014.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,26075014)==0 end
	Duel.RegisterFlagEffect(tp,26075014,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c26075014.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c26075014.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	local oe=e:GetLabelObject()
	if chk==0 then return #g>0 and c26075014.cost(e,tp,eg,ep,ev,re,r,rp,0) end
	c26075014.cost(e,tp,eg,ep,ev,re,r,rp,1)
	local sg=g:Select(tp,1,1,e:GetHandler())
	local sc=sg:GetFirst()
	for sc in aux.Next(sg) do
		c26075011.clock(e,tp,sc)
	end
end
function c26075014.clock(e,tp,tc)
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
function c26075014.setfilter(c)
	return c:IsCode(1082946) and c:IsSSetable()
end
function c26075014.revfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x675) and c:GetTurnCounter()>=1
end
function c26075014.revtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26075014.setfilter,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE,0,1,nil) and Duel.IsExistingMatchingCard(c26075014.revfilter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c26075014.revop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local pc=Duel.GetFirstMatchingCard(c26075014.setfilter,tp,LOCATION_DECK|LOCATION_HAND|LOCATION_GRAVE,0,nil)
	local tc=Duel.SelectMatchingCard(tp,c26075014.revfilter,tp,LOCATION_ONFIELD,0,1,1,nil):GetFirst()
	if pc and tc then
		if pc:IsPublic() then Duel.HintSelection(pc)
		else Duel.ConfirmCards(1-tp,pc) end
		local ct=tc:GetTurnCounter()
		tc:SetTurnCounter(ct-1)
		Duel.SSet(tp,pc)
	end
end
function c26075014.tdfilter(c)
	return c:IsAbleToDeck() and (c:IsFacedown() or not c:IsOnField())
end
function c26075014.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local LOC =LOCATION_ONFIELD|LOCATION_GRAVE|LOCATION_REMOVED 
	if chk==0 then return Duel.IsExistingMatchingCard(c26075014.tdfilter,tp,LOC,LOC,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c26075014.tdop(e,tp,eg,ep,ev,re,r,rp)
	local LOC =LOCATION_ONFIELD|LOCATION_GRAVE|LOCATION_REMOVED 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c26075014.tdfilter,tp,LOC,LOC,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
--register turn count
	function c26075014.adjust(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:HasFlagEffect(26075000) then
			c:SetTurnCounter(0)
			c:RegisterFlagEffect(26075000,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(26075014,3))
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(26075001,3))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EVENT_PHASE|PHASE_END)
			e1:SetRange(LOCATION_SZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(c26075014.turncount)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(1082946)
			e2:SetRange(LOCATION_SZONE)
			e2:SetOperation(c26075014.reset)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	end
	function c26075014.turncount(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Group.CreateGroup()
		for i,pe in ipairs({Duel.GetPlayerEffect(tp,26075014)}) do
			g:AddCard(pe:GetHandler())
		end
		local tc=g:GetFirst()
		if #g>0 and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(26075014,1)) then
			tc=g:GetFirst() 
			if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
			c26075014.clock(e,tp,tc)
		else
			c26075014.clock(e,tp,c)
		end
	end
	function c26075014.reset(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local ct=c:GetTurnCounter()
		ct=ct+1
		c:SetTurnCounter(ct)
	end

function c26075014.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()*100
	if Duel.CheckLPCost(tp,ct) and Duel.SelectYesNo(tp,aux.Stringid(26075014,4)) then
		Duel.PayLPCost(tp,ct)
	else
		Duel.SendtoHand(c,REASON_COST)
	end
end