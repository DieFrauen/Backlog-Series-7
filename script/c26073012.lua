--Polterghast Paralysis
function c26073012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(26073012,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetCode(EFFECT_EXTRA_SET_COUNT)
	e2:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e2)
	--Negate targeting
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c26073012.retgcon)
	e3:SetOperation(c26073012.retgop)
	c:RegisterEffect(e3)
	--special summon flips/set and rearrange
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION|CATEGORY_SPECIAL_SUMMON|CATEGORY_SET)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetDescription(aux.Stringid(26073012,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O|EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,26073012)
	e4:SetCondition(c26073012.poscon)
	e4:SetTarget(c26073012.postg)
	e4:SetOperation(c26073012.posop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
function c26073012.posfilter(c,tp)
	return c:GetSummonType()==SUMMON_TYPE_SPECIAL 
	and c:GetSummonLocation()==LOCATION_EXTRA 
end
function c26073012.poscon(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c26073012.posfilter,1,nil,tp) then
		e:GetHandler():RegisterFlagEffect(26073012,RESET_CHAIN,0,1)
	end
	return true
end
function c26073012.retgfilter(c,e,tp) 
	return c:IsLocation(LOCATION_ONFIELD) and c:IsAbleToHand() and not c:IsImmuneToEffect(e)
end
function c26073012.retgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g==0 or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	return rp==tp and re:IsActiveType(EFFECT_TYPE_FLIP) and re:GetHandler():IsSetCard(0x673) and Duel.GetFlagEffect(tp,26073012)==0
	and g:IsExists(c26073012.retgfilter,1,nil,e,tp)
	and not g:IsContains(e:GetHandler())
end
function c26073012.retgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c26073012.retgfilter,nil,e,tp)
	if #g>0 and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.RegisterFlagEffect(tp,26073012,RESET_PHASE+PHASE_END,0,1)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Hint(HINT_CARD,1-tp,26073012)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c26073012.posfilter(c,tp,lb)
	return (c:IsType(TYPE_FLIP) and c:IsControler(tp) or lb)
	and c:IsFaceup() and c:IsCanTurnSet()
end
function c26073012.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lb=c:GetFlagEffect(26073012)>0
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c26073012.posfilter(chkc,tp,lb) end
	if chk==0 then return Duel.IsExistingTarget(c26073012.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,lb) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectTarget(tp,c26073012.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,lb)
	e:SetLabel(0)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c26073012.posop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
	end
end