--Theriomachination
function c26074015.initial_effect(c)
	--place on field after being tributed
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(26074015,0))
	e0:SetCategory(CATEGORY_LEAVE_GRAVE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e0:SetCode(EVENT_DISCARD)
	e0:SetTarget(c26074015.tftg)
	e0:SetOperation(c26074015.tfop)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--instant
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(26074015,1))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(TIMING_END_PHASE,TIMINGS_CHECK_MONSTER_E+TIMING_BATTLE_START)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(1)
	e1:SetCountLimit(1,26074015)
	e1:SetCost(c26074015.cost)
	e1:SetTarget(c26074015.target1)
	e1:SetOperation(c26074015.operation1)
	c:RegisterEffect(e1)
	--geminize
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(26074015,2))
	e2:SetCategory(0)
	e2:SetHintTiming(0,TIMING_DRAW|TIMING_STANDBY_PHASE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetLabel(2)
	e2:SetCountLimit(1,{26074015,1})
	e2:SetTarget(c26074015.target2)
	e2:SetOperation(c26074015.operation2)
	c:RegisterEffect(e2)
	--flick Monster
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(26074015,3))
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetLabel(3)
	e3:SetCountLimit(1,{26074015,2})
	e3:SetTarget(c26074015.target3)
	e3:SetOperation(c26074015.operation3)
	c:RegisterEffect(e3)
	--negate
	local e4=e2:Clone()
	e4:SetDescription(aux.Stringid(26074015,4))
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e4:SetCategory(CATEGORY_DISABLE)
	e4:SetLabel(4)
	e4:SetCountLimit(1,{26074015,3})
	e4:SetTarget(c26074015.target4)
	e4:SetOperation(c26074015.operation4)
	c:RegisterEffect(e4)
	--tohand
	local e5=e2:Clone()
	e5:SetDescription(aux.Stringid(26074015,5))
	e5:SetCategory(CATEGORY_DISABLE)
	e5:SetLabel(5)
	e5:SetCountLimit(1,{26074015,4})
	e5:SetTarget(c26074015.target5)
	e5:SetOperation(c26074015.operation5)
	c:RegisterEffect(e5)
end
function c26074015.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lb=e:GetLabel()
	if chk==0 then return Duel.GetFlagEffect(tp,26074015)==0 end
	Duel.RegisterFlagEffect(tp,26074015,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(26074015,lb))
	e:GetHandler():RegisterFlagEffect(0,RESETS_STANDARD_PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(26074015,5+lb))
end
function c26074015.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,tp,0)
end
function c26074015.tfop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c26074015.filter1(c,tp)
	return c:IsSummonable(true,nil)
	and c:IsType(TYPE_GEMINI)
	and (c:IsOnField() or Duel.GetLocationCount(tp,LOCATION_MZONE)>0)
end
function c26074015.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c26074015.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26074015.operation1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c26074015.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function c26074015.filter2(c)
	return c:IsFaceup() and c:IsType(TYPE_GEMINI) and not c:IsGeminiStatus()
end
function c26074015.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingTarget(c26074015.filter2,tp,LOCATION_HAND|LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c26074015.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetPossibleOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c26074015.operation2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c26074015.filter2(tc) then
		tc:EnableGeminiStatus()
	end
end
function c26074015.filter3(c)
	return c:IsFaceup() and c:IsAbleToRemove()
end
function c26074015.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c26074015.filter3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26074015.filter3,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectTarget(tp,c26074015.filter3,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	if tc:GetFirst():IsGeminiState() then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function c26074015.operation3(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(tp) and Duel.Remove(tc,0,REASON_EFFECT|REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetReset(RESET_PHASE|PHASE_END)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(c26074015.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c26074015.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end
function c26074015.filter4(c)
	return c:IsNegatableMonster() and c:IsType(TYPE_EFFECT)
end
function c26074015.target4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c:IsControler(1-tp) and c26074015.filter4(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26074015.filter4,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SelectTarget(tp,c26074015.filter4,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,tp,0)
end
function c26074015.operation4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		tc:NegateEffects(e:GetHandler(),RESET_PHASE|PHASE_END,true)
	end
end
function c26074015.filter5(c)
	return (c:IsFaceup() or not c:IsOnField()) and c:IsSetCard(0x674) and c:IsAbleToHand()
end
function c26074015.target5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local LOC =LOCATION_ONFIELD|LOCATION_GRAVE
	if chkc then return chkc:IsLocation(LOC)
		and c26074015.filter5(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c26074015.filter5,tp,LOC,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c26074015.filter5,tp,LOC,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,0)
end
function c26074015.operation5(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
	end
end