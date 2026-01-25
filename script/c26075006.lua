--Chronophagus Eschateo
function c26075006.initial_effect(c)
	local se1,se2=Spirit.AddProcedure(c)
	local se3,se4=se1:Clone(),se2:Clone()
	se3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	se3:SetCode(EVENT_CUSTOM+26075001)
	se3:SetTarget(c26075006.mdtg)
	se3:SetOperation(c26075006.op)
	c:RegisterEffect(se3)
	se4:SetType(EFFECT_TYPE_TRIGGER_O)
	se4:SetProperty(EFFECT_FLAG_DELAY)
	se4:SetCode(EVENT_CUSTOM+26075001)
	se4:SetTarget(c26075006.optg)
	se4:SetOperation(c26075006.op)
	c:RegisterEffect(se4)
	--turn count
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c26075006.adjust)
	c:RegisterEffect(e1)
	--summon with no tribute
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26075005,0))
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetCondition(c26075006.ntcon)
	e3:SetOperation(c26075006.ntop)
	c:RegisterEffect(e3)
	--send targets to gy (eventually)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(26075006,0))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET|EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c26075006.target)
	c:RegisterEffect(e4)
	--these targets
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EVENT_CHAIN_SOLVED)
	e5:SetLabelObject(e1)
	e5:SetCondition(aux.PersistentTgCon)
	e5:SetOperation(c26075006.tgop)
	c:RegisterEffect(e5)
	--pyro clock
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(26075005,3))
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCode(EVENT_REMOVE)
	e7:SetTarget(c26075006.advtg)
	e7:SetOperation(c26075006.advop)
	c:RegisterEffect(e7)
end
function c26075006.ntcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c26075006.ntfilter,tp,LOCATION_ONFIELD,0,2,nil)
end
function c26075006.ntfilter(c)
	return c:IsHasEffect(1082946)   
	and c:GetFlagEffect(26075000)~=0
	and c:IsSetCard(0x675) and c:IsOnField()
end
function c26075006.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c26075006.ntfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,2,2,nil)
	--e:GetLabelObject():SetLabel(#sg)
	local tc=sg:GetFirst()
	for tc in aux.Next(sg) do
		c26075006.clock(e,tp,tc)
	end
end
--register turn count
	function c26075006.adjust(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:HasFlagEffect(26075000) then
			c:SetTurnCounter(0)
			c:RegisterFlagEffect(26075000,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,1,aux.Stringid(26075001,6))
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(26075001,3))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EVENT_PHASE|PHASE_END)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(c26075006.turncount)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(1082946)
			e2:SetRange(LOCATION_MZONE)
			e2:SetOperation(c26075006.reset)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	end
	function c26075006.turncount(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Group.CreateGroup()
		for i,pe in ipairs({Duel.GetPlayerEffect(tp,26075010)}) do
			g:AddCard(pe:GetHandler())
		end
		local tc=g:GetFirst()
		if #g>0 and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(26075010,1)) then
			tc=g:GetFirst() 
			if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
			c26075006.clock(e,tp,tc)
		else
			c26075006.clock(e,tp,c)
		end
	end
	function c26075006.reset(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local ct=c:GetTurnCounter()
		ct=ct+1
		c:SetTurnCounter(ct)
		if not c:HasFlagEffect(FLAG_SPIRIT_RETURN) then
			c:RegisterFlagEffect(FLAG_SPIRIT_RETURN,RESET_CHAIN,0,1)
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+26075001,e,REASON_EFFECT,tp,tp,1082946)
		end
	end

function c26075006.advfilter(c)
	return c:IsHasEffect(1082946) and
	(c:IsSetCard(0x675) and c:IsOnField() or
	c:IsLocation(LOCATION_REMOVED) and c:GetFlagEffect(26075000)~=0)
end
function c26075006.advtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26075006.advfilter,tp,LOCATION_ONFIELD|LOCATION_REMOVED,0,1,nil) end
end
function c26075006.advop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(1082946,0))
	local g=Duel.SelectMatchingCard(tp,c26075006.advfilter,tp,LOCATION_ONFIELD|LOCATION_REMOVED,0,1,1,nil)
	local tc=g:GetFirst()
	tc:CreateEffectRelation(e) 
	if tc and c26075006.clock(e,tp,tc) then
		if tc:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(26075004,2)) then
			c26075006.clock(e,tp,tc)
		end
	end
end
function c26075006.clock(e,tp,tc)
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
function c26075006.reset(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	c:RegisterFlagEffect(FLAG_SPIRIT_RETURN,RESETS_STANDARD_PHASE_END,0,1)
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+26075001,e,0,tp,tp,0)
end
function c26075006.mdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=c:GetCardTarget():Filter(Card.IsAbleToRemove,nil)
	c:ResetFlagEffect(FLAG_SPIRIT_RETURN)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	if #g>0 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
end
function c26075006.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetCardTarget():Filter(Card.IsAbleToRemove,nil)
	g:AddCard(c)
	if chk==0 then return g:Filter(Card.IsAbleToHand,nil)>0 end
	c:ResetFlagEffect(FLAG_SPIRIT_RETURN)
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	if #g>0 then
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	end
end
function c26075006.op(e,tp,eg,ep,ev,re,r,rp)
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
			Duel.SendtoGrave(tc,REASON_EFFECT)
		end
	end
end
function c26075006.tgfilter(c,g)
	return c:IsAbleToGrave() and c:IsFaceup() and not g:IsContains(c)
end
function c26075006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=e:GetHandler():GetCardTarget()
	if chkc then return chkc:IsControler(1-tp)
	and c26075006.tgfilter(chkc,g) end
	if chk==0 then return Duel.IsExistingTarget(c26075006.tgfilter,tp,0,LOCATION_ONFIELD,1,nil,g) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c26075006.tgfilter,tp,0,LOCATION_ONFIELD,1,1,nil,g)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
end
function c26075006.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(re) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,re)
	local tc=g:GetFirst()
	for tc in aux.Next(g) do
		c:SetCardTarget(tc)
	end
end
function c26075006.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetCardTarget():Filter(Card.IsLocation,nil,LOCATION_ONFIELD)
	Duel.SendtoGrave(g,REASON_EFFECT)
end