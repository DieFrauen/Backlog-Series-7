--Chronophagus Singularity
function c26075013.initial_effect(c)
	c:SetUniqueOnField(1,0,26075013)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--turn count
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c26075013.adjust)
	c:RegisterEffect(e2)
	--future fusion
	local e4=Fusion.CreateSummonEff(c,c26075013.fusfilter,c26075013.matfilter,c26075013.extrafil,c26075013.extraop,nil,c26075013.stage2,nil,nil,nil,nil,nil,nil,nil,c26075013.extratg)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_CUSTOM+26075013)
	e4:SetCondition(c26075013.fuscond)
	e4:SetCountLimit(1)
	c:RegisterEffect(e4)
	aux.GlobalCheck(c26075013,function()
		c26075013.should_check=false
		c26075013.lvcheck=12
		local geff=Effect.CreateEffect(c)
		geff:SetType(EFFECT_TYPE_FIELD)
		geff:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		geff:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		geff:SetTargetRange(1,1)
		geff:SetTarget(function(e,c)
			if c26075013.should_check then
				return c:IsLevelBelow(c26075013.lvcheck)
			end
			return false
		end)
		Duel.RegisterEffect(geff,0)
	end)
	--Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetRange(LOCATION_SZONE)
	e5:SetOperation(c26075013.desop)
	c:RegisterEffect(e5)
	--Destroy2
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_LEAVE_FIELD)
	e6:SetCondition(c26075013.descon2)
	e6:SetOperation(c26075013.desop2)
	c:RegisterEffect(e6)
	--maintain
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(26075001,1))
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1)
	e7:SetOperation(c26075013.mtop)
	c:RegisterEffect(e7)
end
--register turn count
	function c26075013.adjust(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if not c:HasFlagEffect(26075000) then
			c:SetTurnCounter(0)
			c:RegisterFlagEffect(26075000,RESET_EVENT|RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,ct,aux.Stringid(26075013,3))
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(26075001,3))
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EVENT_PHASE|PHASE_END)
			e1:SetRange(LOCATION_SZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(c26075013.turncount)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(1082946)
			e2:SetRange(LOCATION_SZONE)
			e2:SetOperation(c26075013.reset)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
	end
	function c26075013.turncount(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Group.CreateGroup()
		for i,pe in ipairs({Duel.GetPlayerEffect(tp,26075013)}) do
			g:AddCard(pe:GetHandler())
		end
		local tc=g:GetFirst()
		if #g>0 and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(26075013,1)) then
			tc=g:GetFirst() 
			if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
			c26075013.clock(e,tp,tc)
		else
			c26075013.clock(e,tp,c)
		end
	end
	function c26075013.reset(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local ct=c:GetTurnCounter()
		ct=ct+1
		c:SetTurnCounter(ct)
	end
function c26075013.clock(e,tp,tc)
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
function c26075013.fuscond(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCardTargetCount()==0
end
function c26075013.reset(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	local lb=12
	c:SetTurnCounter(ct)
	if ct>lb then
		--Duel.Remove(c,POS_FACEUP,REASON_RULE)
	end
	Duel.RaiseSingleEvent(c,EVENT_CUSTOM+26075013,e,0,tp,tp,0)
end
function c26075013.checkmat(tp,sg,fc)
	c26075013.should_check=true
	if fc:IsLevelBelow(c26075013.lvcheck) then
		c26075013.should_check=false
		return true
	end
	c26075013.should_check=false
end
function c26075013.extrafil(e,tp,mg)
	c26075013.lvcheck=e:GetHandler():GetTurnCounter()
	if not Duel.IsPlayerAffectedByEffect(tp,CARD_SPIRIT_ELIMINATION) then
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE|LOCATION_DECK|LOCATION_EXTRA|LOCATION_HAND|LOCATION_ONFIELD,0,nil),c26075013.checkmat
	else
		return Duel.GetMatchingGroup(Fusion.IsMonsterFilter(Card.IsAbleToRemove),tp,LOCATION_DECK|LOCATION_EXTRA|LOCATION_HAND|LOCATION_ONFIELD,0,nil)
	end
	return nil,c26075013.checkmat
end
function c26075013.extratg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_DECK|LOCATION_EXTRA|LOCATION_DECK|LOCATION_HAND|LOCATION_MZONE)
end
function c26075013.extraop(e,tc,tp,sg)
	local rg=sg:Clone()
	if #rg>0 then
		Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		sg:Sub(rg)
	end
end
function c26075013.stage2(e,tc,tp,sg,chk)
	if chk==1 then
		e:GetHandler():SetCardTarget(tc)
	end
end
function c26075013.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c26075013.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc) and tc:IsReason(REASON_DESTROY)
end
function c26075013.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c26075013.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()*100
	if Duel.CheckLPCost(tp,ct) and Duel.SelectYesNo(tp,aux.Stringid(26075013,2)) then
		Duel.PayLPCost(tp,ct)
	else
		Duel.Destroy(c,REASON_COST)
	end
end