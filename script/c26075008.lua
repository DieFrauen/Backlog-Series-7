--Chronophagus Laplace
function c26075008.initial_effect(c)
	Fusion.AddProcMixRep(c,false,false,aux.FilterBoolFunctionEx(Card.IsSetCard,0x675),2,3)
	local se1,se2=Spirit.AddProcedure(c)
	local se3,se4=se1:Clone(),se2:Clone()
	se3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	se3:SetCode(EVENT_CUSTOM+26075001)
	se3:SetTarget(c26075008.mdtg)
	c:RegisterEffect(se3)
	se4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	se4:SetProperty(EFFECT_FLAG_DELAY)
	se4:SetCode(EVENT_CUSTOM+26075001)
	se4:SetTarget(c26075008.optg)
	c:RegisterEffect(se4)
	--turn count
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c26075008.adjust)
	c:RegisterEffect(e1)
	--matcheck
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c26075008.matcheck)
	e1:SetLabelObject(e2)
	c:RegisterEffect(e2)
	--Negate activation
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(26075008,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_SET)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_CHAINING)
	e3:SetLabel(1)
	e3:SetCost(c26075008.discost)
	e3:SetCondition(c26075008.discon)
	e3:SetTarget(c26075008.distg)
	e3:SetOperation(c26075008.disop)
	c:RegisterEffect(e3)
end
function c26075008.matcheck(e,c)
	local ct=c:GetMaterialCount()
	ct=1+ct
	e:SetLabel(ct)
end
function c26075008.mdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	c:ResetFlagEffect(FLAG_SPIRIT_RETURN)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c26075008.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtra() end
	c:ResetFlagEffect(FLAG_SPIRIT_RETURN)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
--register turn count
	function c26075008.adjust(e,tp,eg,ep,ev,re,r,rp)
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
			e1:SetOperation(c26075008.turncount)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(1082946)
			e2:SetRange(LOCATION_MZONE)
			e2:SetOperation(c26075008.reset)
			e2:SetReset(RESET_EVENT|RESETS_STANDARD)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(26075001,3))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE|EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_SPIRIT_MAYNOT_RETURN)
			e3:SetRange(LOCATION_MZONE)
			e3:SetReset(RESET_EVENT|RESETS_STANDARD)
			e3:SetCondition(c26075008.delay)
			e3:SetValue(ct)
			c:RegisterEffect(e3)
		end
	end
	function c26075008.turncount(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local g=Group.CreateGroup()
		for i,pe in ipairs({Duel.GetPlayerEffect(tp,26075010)}) do
			g:AddCard(pe:GetHandler())
		end
		local tc=g:GetFirst()
		if #g>0 and Duel.SelectEffectYesNo(tp,tc,aux.Stringid(26075010,1)) then
			tc=g:GetFirst() 
			if #g>1 then tc=g:Select(tp,1,1,nil):GetFirst() end
			c26075008.clock(e,tp,tc)
		else
			c26075008.clock(e,tp,c)
		end
	end
	function c26075008.delay(e,tp,eg,ep,ev,re,r,rp,chk)
		return e:GetHandler():GetTurnCounter()<e:GetValue()
	end
	function c26075008.reset(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local ct=c:GetTurnCounter()
		ct=ct+1
		c:SetTurnCounter(ct)
		if not c:HasFlagEffect(FLAG_SPIRIT_RETURN) then
			c:RegisterFlagEffect(FLAG_SPIRIT_RETURN,RESET_CHAIN,0,1)
			Duel.RaiseSingleEvent(c,EVENT_CUSTOM+26075001,e,REASON_EFFECT,tp,tp,1082946)
		end
	end
function c26075008.clock(e,tp,tc)
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
function c26075008.ctfilter(c)
	return c:IsHasEffect(1082946) and c:GetFlagEffect(26075000)~=0 and
	(c:IsSetCard(0x675) and c:IsOnField() or
	c:IsLocation(LOCATION_REMOVED))
end
function c26075008.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	local lb=e:GetLabel()
	local g=Duel.GetMatchingGroup(c26075008.ctfilter,tp,LOCATION_ONFIELD|LOCATION_REMOVED,LOCATION_REMOVED,nil)
	local eff,op=0,0
	if chk==0 then return #g>=lb end
	local sg=g:Select(tp,lb,lb,nil)
	local tc=sg:GetFirst()
	for tc in aux.Next(sg) do
		c26075008.clock(e,tp,tc)
	end
end
function c26075008.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and ep==1-tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev)
end
function c26075008.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c26075008.disop(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and tc:IsRelateToEffect(re) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)==0 then return end
		local RESETS =RESET_EVENT|RESETS_STANDARD 
		tc:SetTurnCounter(0)
		tc:RegisterFlagEffect(26075000,RESETS,0,1)
		tc:RegisterFlagEffect(26075008,RESETS,0,1)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		e1:SetCondition(c26075008.retcon)
		e1:SetOperation(c26075008.retop)
		Duel.RegisterEffect(e1,tc:GetOwner())
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCode(1082946)
		e2:SetLabelObject(e1)
		e2:SetOwnerPlayer(tp)
		e2:SetOperation(c26075008.forward)
		e2:SetReset(RESETS,2)
		tc:RegisterEffect(e2)
	end
end
function c26075008.retcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c and c:GetFlagEffect(26075008)~=0 then return true
	else e:Reset(); return false end
end
function c26075008.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local ct=c:GetTurnCounter()+1
	c:SetTurnCounter(ct)
	if ct>1 then
		Duel.HintSelection(Group.FromCards(c))
		Duel.ReturnToField(c,c:GetPreviousPosition())
		c:SetTurnCounter(0)
	end
end
function c26075008.forward(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if  c26075008.retcon(te,tp,nil,tp,1082946,te,0,tp)
	then c26075008.retop(te,tp,nil,tp,1082946,te,0,tp) end
end