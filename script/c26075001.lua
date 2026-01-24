--Chronophagus Newcomb
function c26075001.initial_effect(c)
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
	e1:SetOperation(c26075001.adjust)
	c:RegisterEffect(e1)
	--extra normal summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26075001,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,26075001)
	e2:SetLabel(1)
	e2:SetCost(c26075001.cost)
	e2:SetTarget(c26075001.target1)
	e2:SetOperation(c26075001.operation1)
	c:RegisterEffect(e2)
	--search "Singularity"
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26075001,1))
	e3:SetCategory(CATEGORY_TOHAND|CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,{26075001,1})
	e3:SetLabel(2)
	e3:SetCost(c26075001.cost)
	e3:SetTarget(c26075001.target2)
	e3:SetOperation(c26075001.operation2)
	c:RegisterEffect(e3)
end
--spirit effects
function c26075001.mdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:ResetFlagEffect(FLAG_SPIRIT_RETURN)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c26075001.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	c:ResetFlagEffect(FLAG_SPIRIT_RETURN)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end
function c26075001.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		c:SetTurnCounter(0)
	end
end
--register turn count
	function c26075001.adjust(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:HasFlagEffect(26075000) then
			c:SetTurnCounter(0)
			local ct=3; if c:IsNormalSummoned() then ct=5 end
			c:RegisterFlagEffect(26075000,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(26075001,5+ct))
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(26075001,3))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EVENT_PHASE|PHASE_END)
			e1:SetRange(LOCATION_MZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(c26075001.turncount)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(1082946)
			e2:SetRange(LOCATION_MZONE)
			e2:SetOperation(c26075001.reset)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(26075001,3))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT|RESETS_STANDARD)
			e3:SetCondition(c26075001.delay)
			e3:SetValue(ct)
			c:RegisterEffect(e3)
		end
	end
	function c26075001.turncount(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Group.CreateGroup()
		for i,pe in ipairs({Duel.GetPlayerEffect(tp,26075010)}) do
			g:AddCard(pe:GetHandler())
		end
		local tc=g:GetFirst()
		if #g>0 and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(26075010,1)) then
			tc=g:GetFirst() 
			if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
			c26075001.clock(e,tp,tc)
		else
			c26075001.clock(e,tp,c)
		end
	end
	function c26075001.delay(e,tp,eg,ep,ev,re,r,rp,chk)
		return e:GetHandler():GetTurnCounter()<e:GetValue()
	end
	function c26075001.reset(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local ct=c:GetTurnCounter()
		ct=ct+1
		c:SetTurnCounter(ct)
		if not c:HasFlagEffect(FLAG_SPIRIT_RETURN) then
			c:RegisterFlagEffect(FLAG_SPIRIT_RETURN,RESET_CHAIN,0,1)
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+26075001,e,REASON_EFFECT,tp,tp,1082946)
		end
	end
function c26075001.filter(c)
	return c:IsSetCard(0x675) and c:IsSummonable(true,nil)
end
function c26075001.ctfilter(c)
	return c:IsHasEffect(1082946) and c:GetFlagEffect(26075000)~=0
	and (c:IsSetCard(0x675) and c:IsOnField() or
	c:IsLocation(LOCATION_REMOVED))
end
function c26075001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	local lb=e:GetLabel()
	local g=Duel.GetMatchingGroup(c26075001.ctfilter,tp,LOCATION_ONFIELD,0,nil)
	local eff,op=0,0
	if chk==0 then return #g>=lb end
	local sg=g:Select(tp,lb,lb,nil)
	local tc=sg:GetFirst()
	for tc in aux.Next(sg) do
		c26075001.clock(e,tp,tc)
	end
end
function c26075001.clock(e,tp,tc)
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
function c26075001.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26075001.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26075001.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26075001.filter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c26075001.thactfilter(c,tp)
	return c:IsCode(26075010) and (c:IsAbleToHand() or c:GetActivateEffect():IsActivatable(tp,true,true))
end
function c26075001.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26075001.thactfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then Duel.RegisterFlagEffect(tp,CARD_MAGICAL_MIDBREAKER,RESET_CHAIN,0,1) end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c26075001.operation2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(26075001,2))
	local sc=Duel.GetFirstMatchingCard(c26075001.thactfilter,tp,LOCATION_DECK,0,nil,tp)
	Duel.ConfirmCards(tp,sc)
	aux.ToHandOrElse(sc,tp,
		function()
			return sc:GetActivateEffect():IsActivatable(tp,true,true)
		end,
		function()
			Duel.ActivateFieldSpell(sc,e,tp,eg,ep,ev,re,r,rp)
		end,
		aux.Stringid(26075001,2)
	)
end